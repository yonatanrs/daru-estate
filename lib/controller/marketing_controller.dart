import 'package:daru_estate/misc/ext/future_ext.dart';
import 'package:daru_estate/misc/ext/paging_controller_ext.dart';
import 'package:daru_estate/misc/ext/paging_ext.dart';
import 'package:daru_estate/misc/ext/rx_ext.dart';
import 'package:daru_estate/misc/ext/string_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../domain/entity/customer/customer.dart';
import '../domain/entity/customer/get_customer_based_marketing_id_list_parameter.dart';
import '../domain/entity/house/get_house_list_parameter.dart';
import '../domain/entity/house/house.dart';
import '../domain/entity/mybill/bill.dart';
import '../domain/repository/source_repository.dart';
import '../misc/canceltokenmapkey/page_and_string_cancel_token_map_key.dart';
import '../misc/constant.dart';
import '../misc/controllerstate/listitemcontrollerstate/bill_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/colorful_chip_tab_bar_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/customerlistitemcontrollerstate/vertical_customer_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/house_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../misc/controllerstate/marketing_category_controller_state.dart';
import '../misc/controllerstate/paging_controller_state.dart';
import '../misc/load_data_result.dart';
import '../misc/login_helper.dart';
import '../misc/manager/controller_manager.dart';
import '../misc/paging/modified_paging_controller.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import '../misc/paging/pagingresult/paging_result.dart';
import '../presentation/widget/colorful_chip_tab_bar.dart';
import 'base_getx_controller.dart';

class MarketingController extends BaseGetxController {
  final SourceRepository sourceRepository;

  late final ModifiedPagingController<int, ListItemControllerState> _marketingListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _marketingListItemPagingControllerState;
  late final Rx<PagingControllerState<int, ListItemControllerState>> marketingListItemPagingControllerStateRx;

  final ColorfulChipTabBarController _mainMenuCategoryColorfulChipTabBarController = ColorfulChipTabBarController(0);
  final List<String> menuColorfulChipTabBarList = <String>["Customer", "Rumah"];
  late final MarketingCategoryControllerState _marketingCategoryControllerState;
  late final Rx<MarketingCategoryControllerState> marketingCategoryControllerStateRx;

  void Function(Customer)? _onClickCustomer;
  void Function(House)? _onClickHouse;

  MarketingController(ControllerManager? controllerManager, this.sourceRepository) : super(controllerManager) {
    _marketingListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      apiRequestManager: apiRequestManager,
    );
    _marketingListItemPagingControllerState = PagingControllerState(
      pagingController: _marketingListItemPagingController,
      isPagingControllerExist: false
    );
    marketingListItemPagingControllerStateRx = _marketingListItemPagingControllerState.obs;
    _marketingCategoryControllerState = MarketingCategoryControllerState(
      marketingCategoryIndex: 0
    );
    marketingCategoryControllerStateRx = _marketingCategoryControllerState.obs;
  }

  @override
  void onInitController() {
    _marketingListItemPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: _marketingListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _marketingListItemPagingControllerState.isPagingControllerExist = true;
    _mainMenuCategoryColorfulChipTabBarController.addListener(() {
      _marketingListItemPagingController.resetToDesiredPageKey(2);
      _marketingCategoryControllerState.marketingCategoryIndex = _mainMenuCategoryColorfulChipTabBarController.value;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _updateMarketingState();
      });
    });
    _updateMarketingState();
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _marketingListItemPagingControllerStateListener(int pageKey) async {
    int categoryIndex = _mainMenuCategoryColorfulChipTabBarController.value;
    if (pageKey == 1) {
      return SuccessLoadDataResult<PagingDataResult<ListItemControllerState>>(
        value: PagingDataResult<ListItemControllerState>(
          page: 1,
          totalPage: 2,
          totalItem: 1,
          itemList: <ListItemControllerState>[
            VirtualSpacingListItemControllerState(height: Constant.paddingListItem),
            ColorfulChipTabBarListItemControllerState(
              colorfulChipTabBarController: _mainMenuCategoryColorfulChipTabBarController,
              colorfulChipTabBarDataList: menuColorfulChipTabBarList.map<ColorfulChipTabBarData>((element) {
                return ColorfulChipTabBarData(
                  color: Constant.colorMain,
                  title: element.toStringNonNull
                );
              }).toList()
            )
          ]
        )
      );
    } else {
      int effectivePageKey = pageKey - 1;
      if (categoryIndex == 0) {
        return sourceRepository.getCustomerBasedMarketingIdList(
          GetCustomerBasedMarketingIdListParameter(marketingId: LoginHelper.getMarketingId().result, page: effectivePageKey)
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPartWithStringKey(PageAndStringCancelTokenMapKey(page: pageKey, key: 'customer-based-marketing-id')).value
        ).map<PagingDataResult<ListItemControllerState>>(
          (result) {
            PagingDataResult<ListItemControllerState> customerPagingDataResult = result.customerPagingDataResult.map<ListItemControllerState>(
              (value) => VerticalCustomerListItemControllerState(customer: value, onClickCustomer: _onClickCustomer)
            );
            customerPagingDataResult.itemList.insertAll(0, <ListItemControllerState>[
              VirtualSpacingListItemControllerState(height: Constant.paddingListItem),
              PaddingContainerListItemControllerState(
                padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
                  title: "Customer Sudah Didaftarkan",
                  description: "Berikut ini merupakan customer yang sudah didaftarkan.",
                  verticalSpace: 0.5.h
                )
              )
            ]);
            return customerPagingDataResult;
          }
        ).toPagingResult();
      } else {
        return sourceRepository.getHouseList(
          GetHouseListParameter(page: effectivePageKey)
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPartWithStringKey(PageAndStringCancelTokenMapKey(page: pageKey, key: 'house')).value
        ).map<PagingDataResult<ListItemControllerState>>(
          (result) {
            PagingDataResult<ListItemControllerState> customerPagingDataResult = result.housePagingDataResult.map<ListItemControllerState>((house) => CompoundListItemControllerState(
              listItemControllerState: <ListItemControllerState>[
                VirtualSpacingListItemControllerState(height: Constant.paddingListItem),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  paddingChildListItemControllerState: HouseListItemControllerState(
                    house: house,
                  )
                )
              ]
            ));
            if (pageKey == 1) {
              customerPagingDataResult.itemList.insertAll(0, <ListItemControllerState>[
                VirtualSpacingListItemControllerState(height: Constant.paddingListItem),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
                    title: "Rumah",
                    verticalSpace: 0.5.h
                  )
                )
              ]);
            }
            return customerPagingDataResult;
          }
        ).toPagingResult();
      }
    }
  }

  void setOnClickHouse(void Function(House) onClickHouse) {
    _onClickHouse = onClickHouse;
  }

  void setOnClickCustomer(void Function(Customer) onClickCustomer) {
    _onClickCustomer = onClickCustomer;
  }

  void _updateMarketingState() {
    marketingListItemPagingControllerStateRx.valueFromLast((value) => _marketingListItemPagingControllerState.copy());
    marketingCategoryControllerStateRx.valueFromLast((value) => _marketingCategoryControllerState.copy());
    update();
  }

  void logout(void Function() onSuccessLogout) async {
    await LoginHelper.deleteToken().future();
    onSuccessLogout();
  }

  @override
  void onClose() {
    super.onClose();
    _marketingListItemPagingController.dispose();
  }
}