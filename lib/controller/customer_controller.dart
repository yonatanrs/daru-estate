import 'package:daru_estate/misc/controllerstate/listitemcontrollerstate/horizontal_justified_title_and_description_list_item_controller_state.dart';
import 'package:daru_estate/misc/controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import 'package:daru_estate/misc/ext/future_ext.dart';
import 'package:daru_estate/misc/ext/paging_controller_ext.dart';
import 'package:daru_estate/misc/ext/paging_ext.dart';
import 'package:daru_estate/misc/ext/rx_ext.dart';
import 'package:daru_estate/misc/ext/string_ext.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../domain/entity/customer/customer.dart';
import '../domain/entity/mybill/get_my_bill_parameter.dart';
import '../domain/entity/mydata/get_my_data_parameter.dart';
import '../domain/entity/mydata/get_my_data_response.dart';
import '../domain/repository/source_repository.dart';
import '../misc/canceltokenmapkey/page_and_string_cancel_token_map_key.dart';
import '../misc/constant.dart';
import '../misc/controllerstate/listitemcontrollerstate/bill_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/colorful_chip_tab_bar_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/customer_detail_header_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/load_data_result_dynamic_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../misc/controllerstate/paging_controller_state.dart';
import '../misc/errorprovider/error_provider.dart';
import '../misc/injector.dart';
import '../misc/load_data_result.dart';
import '../misc/login_helper.dart';
import '../misc/manager/controller_manager.dart';
import '../misc/paging/modified_paging_controller.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import '../misc/paging/pagingresult/paging_list_result.dart';
import '../misc/paging/pagingresult/paging_result.dart';
import '../presentation/widget/colorful_chip_tab_bar.dart';
import '../presentation/widget/customer/customer_item.dart';
import '../presentation/widget/customer_header.dart';
import 'base_getx_controller.dart';

class CustomerController extends BaseGetxController {
  final SourceRepository sourceRepository;

  late final ModifiedPagingController<int, ListItemControllerState> _customerListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _customerListItemPagingControllerState;
  late final Rx<PagingControllerState<int, ListItemControllerState>> customerListItemPagingControllerStateRx;

  final ColorfulChipTabBarController _mainMenuCategoryColorfulChipTabBarController = ColorfulChipTabBarController(0);
  final List<String> menuColorfulChipTabBarList = <String>["Data Diri", "Tagihan Anda"];

  late final LoadDataResultDirectlyDynamicListItemControllerState<GetMyDataResponse> _getMyDataResponseDynamicListItemControllerState;
  CancelToken? _getMyDataResponseCancelToken;

  CustomerController(ControllerManager? controllerManager, this.sourceRepository) : super(controllerManager) {
    _getMyDataResponseDynamicListItemControllerState = LoadDataResultDirectlyDynamicListItemControllerState<GetMyDataResponse>(
      loadDataResult: NoLoadDataResult(),
      errorProvider: Injector.locator<ErrorProvider>(),
      onImplementLoadDataResultDirectlyListItemControllerState: (loadDataResult, errorProvider) {
        return WidgetSubstitutionListItemControllerState(
          widgetSubstitution: (BuildContext context, int index) {
            return CustomerHeader(
              errorProvider: Injector.locator<ErrorProvider>(),
              getMyDataResponseLoadDataResult: loadDataResult,
            );
          }
        );
      }
    );
    _customerListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      apiRequestManager: apiRequestManager,
    );
    _customerListItemPagingControllerState = PagingControllerState(
      pagingController: _customerListItemPagingController,
      isPagingControllerExist: false
    );
    customerListItemPagingControllerStateRx = _customerListItemPagingControllerState.obs;
  }

  @override
  void onInitController() {
    _customerListItemPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: _customerListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _customerListItemPagingControllerState.isPagingControllerExist = true;
    _mainMenuCategoryColorfulChipTabBarController.addListener(() {
      _customerListItemPagingController.resetToDesiredPageKey(2);
    });
    _updateCustomerState();
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _customerListItemPagingControllerStateListener(int pageKey) async {
    int categoryIndex = _mainMenuCategoryColorfulChipTabBarController.value;
    if (pageKey == 1) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _loadGetMyDataResponse(pageKey);
      });
      return SuccessLoadDataResult<PagingDataResult<ListItemControllerState>>(
        value: PagingDataResult<ListItemControllerState>(
          page: 1,
          totalPage: 2,
          totalItem: 1,
          itemList: <ListItemControllerState>[
            _getMyDataResponseDynamicListItemControllerState,
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
    } else if (pageKey == 2) {
      if (categoryIndex == 0) {
        return sourceRepository.getMyData(
          GetMyDataParameter(id: LoginHelper.getCustomerId().result)
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPartWithStringKey(PageAndStringCancelTokenMapKey(page: pageKey, key: 'customer-based-marketing-id')).value
        ).map<PagingDataResult<ListItemControllerState>>(
          (result) {
            Customer customer = result.customer;
            return PagingDataResult<ListItemControllerState>(
              page: 1,
              totalPage: 2,
              totalItem: 1,
              itemList: <ListItemControllerState>[
                VirtualSpacingListItemControllerState(height: Constant.paddingListItem),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
                    title: "Data Diri",
                    verticalSpace: 0.5.h
                  )
                ),
                VirtualSpacingListItemControllerState(height: 0.5.h),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  paddingChildListItemControllerState: HorizontalJustifiedTitleAndDescriptionListItemControllerState(
                    title: "NIK",
                    description: customer.nik,
                  ),
                ),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  paddingChildListItemControllerState: HorizontalJustifiedTitleAndDescriptionListItemControllerState(
                    title: "Nama",
                    description: customer.name,
                  ),
                ),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  paddingChildListItemControllerState: HorizontalJustifiedTitleAndDescriptionListItemControllerState(
                    title: "Tempat Lahir",
                    description: customer.birthdate,
                  ),
                ),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  paddingChildListItemControllerState: HorizontalJustifiedTitleAndDescriptionListItemControllerState(
                    title: "Tanggal Lahir",
                    description: customer.birthplace,
                  ),
                ),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  paddingChildListItemControllerState: HorizontalJustifiedTitleAndDescriptionListItemControllerState(
                    title: "Email",
                    description: customer.email,
                  ),
                ),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  paddingChildListItemControllerState: HorizontalJustifiedTitleAndDescriptionListItemControllerState(
                    title: "Alamat",
                    description: customer.address,
                  ),
                ),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  paddingChildListItemControllerState: HorizontalJustifiedTitleAndDescriptionListItemControllerState(
                    title: "Kelurahan",
                    description: customer.village,
                  ),
                ),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  paddingChildListItemControllerState: HorizontalJustifiedTitleAndDescriptionListItemControllerState(
                    title: "Kecamatan",
                    description: customer.subDistrict,
                  ),
                ),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  paddingChildListItemControllerState: HorizontalJustifiedTitleAndDescriptionListItemControllerState(
                    title: "Kota",
                    description: customer.city,
                  ),
                ),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  paddingChildListItemControllerState: HorizontalJustifiedTitleAndDescriptionListItemControllerState(
                    title: "Provinsi",
                    description: customer.province,
                  ),
                ),
              ]
            );
          }
        ).toPagingResult();
      } else if (categoryIndex == 1) {
        return _billPagingResult(pageKey - 1);
      } else {
        return SuccessLoadDataResult<PagingListResult<ListItemControllerState>>(
          value: PagingListResult<ListItemControllerState>(
            itemList: <ListItemControllerState>[]
          )
        );
      }
    } else {
      if (categoryIndex == 2) {
        return _billPagingResult(pageKey - 2);
      } else {
        return SuccessLoadDataResult<PagingListResult<ListItemControllerState>>(
          value: PagingListResult<ListItemControllerState>(
            itemList: <ListItemControllerState>[]
          )
        );
      }
    }
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _billPagingResult(int pageKey) {
    return sourceRepository.getMyBill(
      GetMyBillParameter(customerId: LoginHelper.getCustomerId().result, page: pageKey)
    ).future(
      parameter: apiRequestManager.addRequestToCancellationPartWithStringKey(PageAndStringCancelTokenMapKey(page: pageKey, key: 'bills')).value
    ).map<PagingDataResult<ListItemControllerState>>(
      (result) {
        PagingDataResult<ListItemControllerState> billPagingDataResult = result.billPagingDataResult.map((bill) => CompoundListItemControllerState(
          listItemControllerState: <ListItemControllerState>[
            VirtualSpacingListItemControllerState(height: Constant.paddingListItem),
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
              paddingChildListItemControllerState: BillListItemControllerState(
                bill: bill,
              )
            )
          ]
        ));
        if (pageKey == 1) {
          billPagingDataResult.itemList.insertAll(0, <ListItemControllerState>[
            VirtualSpacingListItemControllerState(height: Constant.paddingListItem),
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
              paddingChildListItemControllerState:TitleAndDescriptionListItemControllerState(
                title: "Tagihan Anda",
                description: "Berikut ini merupakan tagihan anda.",
                verticalSpace: 0.5.h
              )
            )
          ]);
        }
        return billPagingDataResult;
      }
    ).toPagingResult();
  }

  void _loadGetMyDataResponse(int pageKey) async {
    _getMyDataResponseDynamicListItemControllerState.loadDataResult = IsLoadingLoadDataResult<GetMyDataResponse>();
    _updateCustomerState();
    _getMyDataResponseCancelToken = apiRequestManager.addRequestToCancellationPartWithStringKey(PageAndStringCancelTokenMapKey(page: pageKey, key: 'customer-header')).value;
    LoadDataResult<GetMyDataResponse> getMyDataResponseLoadDataResult = await sourceRepository.getMyData(
      GetMyDataParameter(id: LoginHelper.getCustomerId().result)
    ).future(
      parameter: _getMyDataResponseCancelToken
    );
    _getMyDataResponseDynamicListItemControllerState.loadDataResult = getMyDataResponseLoadDataResult;
    _updateCustomerState();
  }

  void _updateCustomerState() {
    customerListItemPagingControllerStateRx.valueFromLast((value) => _customerListItemPagingControllerState.copy());
    update();
  }

  void logout(void Function() onSuccessLogout) async {
    await LoginHelper.deleteToken().future();
    onSuccessLogout();
  }

  @override
  void onClose() {
    super.onClose();
    _customerListItemPagingController.dispose();
  }
}