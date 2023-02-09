import 'dart:convert';

import 'package:daru_estate/misc/ext/load_data_result_ext.dart';
import 'package:daru_estate/misc/ext/paging_ext.dart';
import 'package:daru_estate/misc/ext/string_ext.dart';
import 'package:get/get.dart';
import 'package:daru_estate/misc/ext/future_ext.dart';
import 'package:daru_estate/misc/ext/paging_controller_ext.dart';
import 'package:daru_estate/misc/ext/rx_ext.dart';
import 'package:daru_estate/misc/manager/controller_manager.dart';

import '../domain/entity/house/get_house_list_parameter.dart';
import '../domain/entity/house/house.dart';
import '../domain/repository/source_repository.dart';
import '../misc/canceltokenmapkey/page_and_string_cancel_token_map_key.dart';
import '../misc/controllerstate/listitemcontrollerstate/house_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/no_content_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/page_keyed_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/selectgenderlistitemcontrollerstate/select_house_input_mediator_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/selectgenderlistitemcontrollerstate/select_house_list_item_controller_state.dart';
import '../misc/controllerstate/paging_controller_state.dart';
import '../misc/controllerstate/select_house_input_controller_state.dart';
import '../misc/error/validation_error.dart';
import '../misc/load_data_result.dart';
import '../misc/login_helper.dart';
import '../misc/paging/modified_paging_controller.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import '../misc/paging/pagingresult/paging_result.dart';
import '../misc/typedef.dart';
import 'base_getx_controller.dart';

typedef _OnShowSelectHouseRequestProcessLoadingCallback = Future<void> Function();
typedef _OnSelectHouseRequestProcessSuccessCallback = Future<void> Function(House);
typedef _OnShowSelectHouseRequestProcessFailedCallback = Future<void> Function(dynamic e);

class SelectHouseController extends BaseGetxController {
  final SourceRepository sourceRepository;

  late final ModifiedPagingController<int, ListItemControllerState> _selectHouseListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _selectHouseListItemPagingControllerState;
  late final Rx<PagingControllerState<int, ListItemControllerState>> selectHouseListItemPagingControllerStateRx;

  final SelectHouseInputControllerState _selectHouseInputControllerState = SelectHouseInputControllerState(lastSelectedHouseId: null, selectedHouse: null);
  late final Rx<SelectHouseInputControllerState> selectHouseInputControllerStateRx;

  SelectHouseController(ControllerManager? controllerManager, this.sourceRepository) : super(controllerManager) {
    _selectHouseListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      apiRequestManager: apiRequestManager,
    );
    _selectHouseListItemPagingControllerState = PagingControllerState(
      pagingController: _selectHouseListItemPagingController,
      isPagingControllerExist: false
    );
    selectHouseListItemPagingControllerStateRx = _selectHouseListItemPagingControllerState.obs;
    selectHouseInputControllerStateRx = _selectHouseInputControllerState.obs;
  }

  bool _hasInitSelectHouse = false;

  void initSelectHouse(String? selectedHouseJsonString) async {
    if (_hasInitSelectHouse) {
      return;
    }
    _hasInitSelectHouse = true;
    _selectHouseListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: (pageKey, itemList) => _selectGenderListItemPagingControllerStateListener(pageKey, itemList, selectedHouseJsonString),
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _selectHouseListItemPagingControllerState.isPagingControllerExist = true;
    _updateSelectHouseState();
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _selectGenderListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? itemList, String? selectedHouseJsonString) async {
    Map<String, dynamic>? selectedHouseJsonMap = selectedHouseJsonString.isEmptyString ? null : json.decode(selectedHouseJsonString!);
    LoadDataResult<PagingDataResult<House>> result = await sourceRepository.getHouseList(
      GetHouseListParameter(page: pageKey),
    ).future(
      parameter: apiRequestManager.addRequestToCancellationPartWithStringKey(PageAndStringCancelTokenMapKey(page: pageKey, key: 'house')).value
    ).map<PagingDataResult<House>>(
      (value) => value.housePagingDataResult
    );
    if (pageKey == 1) {
      return result.map<PagingDataResult<ListItemControllerState>>((result) {
        _selectHouseInputControllerState.lastSelectedHouseId = selectedHouseJsonMap != null ? selectedHouseJsonMap["id"] : null;
        return PagingDataResult<ListItemControllerState>(
          page: pageKey,
          totalPage: result.totalPage,
          totalItem: result.itemList.length,
          itemList: [
            SelectHouseInputMediatorListItemControllerState(
              selectHouseInputControllerState: _selectHouseInputControllerState,
              childListItemControllerState: SelectHouseListItemControllerState(
                onUpdateListItemControllerState: () => _updateSelectHouseState(),
                houseList: result.itemList
              )
            )
          ]
        );
      });
    } else {
      LoadDataResult<PagingDataResult<ListItemControllerState>> housePagingDataResult = result.map<PagingDataResult<ListItemControllerState>>((value) {
        return value.map<ListItemControllerState>((house) => NoContentListItemControllerState());
      });
      if (result.isSuccess) {
        if (itemList != null) {
          if (itemList.isNotEmpty) {
            ListItemControllerState listItemControllerState = itemList.first;
            if (listItemControllerState is PageKeyedListItemControllerState) {
              if (listItemControllerState.listItemControllerState != null) {
                listItemControllerState = listItemControllerState.listItemControllerState!;
              }
            }
            if (listItemControllerState is SelectHouseInputMediatorListItemControllerState) {
              SelectHouseInputMediatorListItemControllerState selectHouseInputMediatorListItemControllerState = listItemControllerState;
              ListItemControllerState childListItemControllerState = selectHouseInputMediatorListItemControllerState.childListItemControllerState;
              if (childListItemControllerState is SelectHouseListItemControllerState) {
                SelectHouseListItemControllerState selectHouseListItemControllerState = childListItemControllerState;
                selectHouseListItemControllerState.houseList.addAll(result.resultIfSuccess!.itemList);
              }
            }
          }
        }
        housePagingDataResult.toPagingResult().clearList();
      }
      return housePagingDataResult;
    }
  }

  void selectHouse({
    required OnUnfocusAllWidget onUnfocusAllWidget,
    // ignore: library_private_types_in_public_api
    required _OnShowSelectHouseRequestProcessLoadingCallback onShowSelectHouseRequestProcessLoadingCallback,
    // ignore: library_private_types_in_public_api
    required _OnSelectHouseRequestProcessSuccessCallback onSelectHouseRequestProcessSuccessCallback,
    // ignore: library_private_types_in_public_api
    required _OnShowSelectHouseRequestProcessFailedCallback onShowSelectHouseRequestProcessFailedCallback
  }) async {
    onUnfocusAllWidget();
    if (_selectHouseInputControllerState.selectedHouse != null) {
      onSelectHouseRequestProcessSuccessCallback(_selectHouseInputControllerState.selectedHouse!);
    } else {
      onShowSelectHouseRequestProcessFailedCallback(ValidationError(message: "House must be selected".tr));
    }
  }

  void _updateSelectHouseState() {
    selectHouseListItemPagingControllerStateRx.valueFromLast((value) => _selectHouseListItemPagingControllerState.copy());
    selectHouseInputControllerStateRx.valueFromLast((value) => _selectHouseInputControllerState.copy());
    update();
  }
}