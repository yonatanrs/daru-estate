import 'package:daru_estate/misc/ext/future_ext.dart';
import 'package:daru_estate/misc/ext/paging_controller_ext.dart';
import 'package:daru_estate/misc/ext/rx_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../domain/entity/customer/customer.dart';
import '../domain/entity/mydata/get_my_data_parameter.dart';
import '../domain/repository/source_repository.dart';
import '../misc/canceltokenmapkey/page_and_string_cancel_token_map_key.dart';
import '../misc/constant.dart';
import '../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../misc/controllerstate/paging_controller_state.dart';
import '../misc/load_data_result.dart';
import '../misc/manager/controller_manager.dart';
import '../misc/paging/modified_paging_controller.dart';
import '../misc/paging/pagingresult/paging_list_result.dart';
import '../misc/paging/pagingresult/paging_result.dart';
import 'base_getx_controller.dart';

class MarketingCustomerDetailController extends BaseGetxController {
  final SourceRepository sourceRepository;
  final String customerId;

  late final ModifiedPagingController<int, ListItemControllerState> _marketingCustomerDetailListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _marketingCustomerDetailListItemPagingControllerState;
  late final Rx<PagingControllerState<int, ListItemControllerState>> marketingCustomerDetailListItemPagingControllerStateRx;

  MarketingCustomerDetailController(
    ControllerManager? controllerManager,
    this.sourceRepository,
    this.customerId
  ) : super(controllerManager) {
    _marketingCustomerDetailListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      apiRequestManager: apiRequestManager,
    );
    _marketingCustomerDetailListItemPagingControllerState = PagingControllerState(
      pagingController: _marketingCustomerDetailListItemPagingController,
      isPagingControllerExist: false
    );
    marketingCustomerDetailListItemPagingControllerStateRx = _marketingCustomerDetailListItemPagingControllerState.obs;
  }

  @override
  void onInitController() {
    _marketingCustomerDetailListItemPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: _marketingCustomerDetailListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _marketingCustomerDetailListItemPagingControllerState.isPagingControllerExist = true;
    _updateMarketingCustomerDetailState();
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _marketingCustomerDetailListItemPagingControllerStateListener(int pageKey) async {
    return sourceRepository.getMyData(
      GetMyDataParameter(id: customerId)
    ).future(
      parameter: apiRequestManager.addRequestToCancellationPartWithStringKey(PageAndStringCancelTokenMapKey(page: pageKey, key: 'customer-based-marketing-id')).value
    ).map<PagingListResult<ListItemControllerState>>(
      (result) {
        Customer customer = result.customer;
        return PagingListResult<ListItemControllerState>(
          itemList: <ListItemControllerState>[
            VirtualSpacingListItemControllerState(height: Constant.paddingListItem),
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
              paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
                title: customer.name,
                description: customer.email,
                verticalSpace: 0.5.h
              )
            )
          ]
        );
      }
    ).toPagingResult();
  }

  void _updateMarketingCustomerDetailState() {
    marketingCustomerDetailListItemPagingControllerStateRx.valueFromLast((value) => _marketingCustomerDetailListItemPagingControllerState.copy());
    update();
  }

  @override
  void onClose() {
    super.onClose();
    _marketingCustomerDetailListItemPagingController.dispose();
  }
}