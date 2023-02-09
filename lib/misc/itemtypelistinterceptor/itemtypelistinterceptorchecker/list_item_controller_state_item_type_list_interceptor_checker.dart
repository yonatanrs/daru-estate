import '../../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../itemtypelistsubinterceptor/additional_loading_indicator_item_type_list_sub_interceptor.dart';
import '../../itemtypelistsubinterceptor/column_container_item_type_list_sub_interceptor.dart';
import '../../itemtypelistsubinterceptor/compound_item_type_list_sub_interceptor.dart';
import '../../itemtypelistsubinterceptor/dynamic_item_type_list_sub_interceptor.dart';
import '../../itemtypelistsubinterceptor/expandable_description_item_type_list_sub_interceptor.dart';
import '../../itemtypelistsubinterceptor/item_type_list_sub_interceptor.dart';
import '../../itemtypelistsubinterceptor/page_keyed_item_type_list_sub_interceptor.dart';
import '../../itemtypelistsubinterceptor/row_container_item_type_list_sub_interceptor.dart';
import '../../itemtypelistsubinterceptor/select_house_item_type_list_sub_interceptor.dart';
import '../../itemtypelistsubinterceptor/verticalgriditemtypelistsubinterceptor/customer_vertical_grid_item_type_list_sub_interceptor.dart';
import '../../typedef.dart';
import '../item_type_list_interceptor_parameter.dart';
import '../item_type_list_interceptor_result.dart';
import 'item_type_list_interceptor_checker.dart';

class ListItemControllerStateItemTypeInterceptorChecker extends ItemTypeListInterceptorChecker<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;

  late List<BaseItemTypeListSubInterceptor> _cachedItemTypeListSubInterceptorList;
  ItemTypeListInterceptorParameter? _cachedItemTypeListInterceptorParameter;

  ListItemControllerStateItemTypeInterceptorChecker({
    required this.padding,
    required this.itemSpacing
  }) : super();

  void interceptEachListItem(
    int i,
    ListItemControllerStateWrapper oldItemTypeWrapper,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newItemTypeList,
  ) {
    int j = 0;
    while (j < _cachedItemTypeListSubInterceptorList.length) {
      BaseItemTypeListSubInterceptor baseItemTypeListSubInterceptor = _cachedItemTypeListSubInterceptorList[j];
      if (baseItemTypeListSubInterceptor is ItemTypeListSubInterceptor) {
        if (baseItemTypeListSubInterceptor.intercept(i, oldItemTypeWrapper, oldItemTypeList, newItemTypeList)) {
          break;
        }
      } else if (baseItemTypeListSubInterceptor is ParameterizedItemTypeListSubInterceptor) {
        if (_cachedItemTypeListInterceptorParameter != null) {
          if (baseItemTypeListSubInterceptor.interceptWithParameter(i, oldItemTypeWrapper, oldItemTypeList, newItemTypeList, _cachedItemTypeListInterceptorParameter!)) {
            break;
          }
        } else {
          throw Exception("Cached item type list interceptor parameter cannot be null");
        }
      }
      if (j == _cachedItemTypeListSubInterceptorList.length - 1) {
        newItemTypeList.add(oldItemTypeWrapper.listItemControllerState);
        break;
      }
      j++;
    }
  }

  @override
  ItemTypeListInterceptorResult<ListItemControllerState> intercept(
    List<ListItemControllerState> oldItemTypeList,
    ItemTypeListInterceptorParameter<ListItemControllerState> itemTypeListInterceptorParameter
  ) {
    int i = 0;
    _cachedItemTypeListInterceptorParameter = itemTypeListInterceptorParameter;

    i = 0;
    List<ListItemControllerState> interceptedItemTypeList = [];
    _initItemTypeListSubInterceptor(oldItemTypeList, interceptedItemTypeList);
    while (i < oldItemTypeList.length) {
      ListItemControllerStateWrapper oldItemTypeWrapper = ListItemControllerStateWrapper(oldItemTypeList[i]);
      interceptEachListItem(i, oldItemTypeWrapper, oldItemTypeList, interceptedItemTypeList);
      i++;
    }

    i = 0;
    List<ListItemControllerState> oldAdditionalItemTypeList = itemTypeListInterceptorParameter.additionalItemTypeList;
    List<ListItemControllerState> interceptedAdditionalItemTypeList = [];
    _initItemTypeListSubInterceptor(oldAdditionalItemTypeList, interceptedAdditionalItemTypeList);
    while (i < oldAdditionalItemTypeList.length) {
      ListItemControllerStateWrapper oldAdditionalItemTypeWrapper = ListItemControllerStateWrapper(oldAdditionalItemTypeList[i]);
      interceptEachListItem(i, oldAdditionalItemTypeWrapper, oldAdditionalItemTypeList, interceptedAdditionalItemTypeList);
      i++;
    }
    return ItemTypeListInterceptorResult<ListItemControllerState>(
      allInterceptedItemTypeList: interceptedItemTypeList + interceptedAdditionalItemTypeList,
      interceptedItemTypeList: interceptedItemTypeList,
      interceptedAdditionalItemTypeList: interceptedAdditionalItemTypeList,
    );
  }

  void _initItemTypeListSubInterceptor(List<ListItemControllerState> oldItemTypeList, List<ListItemControllerState> outputInterceptedItemTypeList) {
    int i = 0;
    _cachedItemTypeListSubInterceptorList = itemTypeListSubInterceptorList;
    while (i < _cachedItemTypeListSubInterceptorList.length) {
      _cachedItemTypeListSubInterceptorList[i].onInit(oldItemTypeList, outputInterceptedItemTypeList);
      i++;
    }
  }

  List<BaseItemTypeListSubInterceptor> get itemTypeListSubInterceptorList => [
    PageKeyedItemTypeListSubInterceptor(),
    CustomerVerticalGridItemTypeListSubInterceptor(
      padding: padding,
      itemSpacing: itemSpacing,
      listItemControllerStateItemTypeInterceptorChecker: this
    ),
    SelectHouseItemTypeListSubInterceptor(
      padding: padding,
      itemSpacing: itemSpacing
    ),
    ExpandableDescriptionItemTypeListSubInterceptor(),
    AdditionalLoadingIndicatorItemTypeListSubInterceptor(
      padding: padding,
      itemSpacing: itemSpacing,
      listItemControllerStateItemTypeInterceptorChecker: this
    ),
    CompoundItemListSubInterceptor(
      listItemControllerStateItemTypeInterceptorChecker: this
    ),
    DynamicItemTypeListSubInterceptor(
      listItemControllerStateItemTypeInterceptorChecker: this
    ),
    ColumnContainerItemTypeListSubInterceptor(
      listItemControllerStateItemTypeInterceptorChecker: this
    ),
    RowContainerItemTypeListSubInterceptor(
      listItemControllerStateItemTypeInterceptorChecker: this
    ),
  ];
}