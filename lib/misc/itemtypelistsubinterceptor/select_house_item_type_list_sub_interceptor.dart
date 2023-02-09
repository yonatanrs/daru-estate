import 'package:daru_estate/misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import 'package:daru_estate/misc/controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/entity/house/house.dart';
import '../constant.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/selectgenderlistitemcontrollerstate/select_house_input_mediator_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/selectgenderlistitemcontrollerstate/select_house_item_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/selectgenderlistitemcontrollerstate/select_house_list_item_controller_state.dart';
import '../controllerstate/select_house_input_controller_state.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';

class SelectHouseItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;

  SelectHouseItemTypeListSubInterceptor({
    required this.padding,
    required this.itemSpacing
  });

  @override
  bool intercept(
    int i,
    ListItemControllerStateWrapper oldItemTypeWrapper,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newItemTypeList
  ) {
    ListItemControllerState oldItemType = oldItemTypeWrapper.listItemControllerState;
    SelectHouseInputControllerState? selectHouseInputControllerState;
    if (oldItemType is SelectHouseInputMediatorListItemControllerState) {
      selectHouseInputControllerState = oldItemType.selectHouseInputControllerState;
      oldItemType = oldItemType.childListItemControllerState;
      oldItemTypeWrapper.listItemControllerState = oldItemType;
    }
    if (oldItemType is SelectHouseListItemControllerState) {
      SelectHouseListItemControllerState selectHouseListItemControllerState = oldItemType;
      List<House> houseList = selectHouseListItemControllerState.houseList;
      int j = 0;
      while (j < houseList.length) {
        House house = houseList[j];
        newItemTypeList.addAll(<ListItemControllerState>[
          VirtualSpacingListItemControllerState(height: Constant.paddingListItem),
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            paddingChildListItemControllerState: SelectHouseItemListItemControllerState(
              house: house,
              selectedHouseId: selectHouseInputControllerState?.lastSelectedHouseId,
              onHouseSelected: (house) {
                selectHouseInputControllerState?.lastSelectedHouseId = house.id;
                selectHouseInputControllerState?.selectedHouse = house;
                if (selectHouseListItemControllerState.onHouseSelected != null) {
                  selectHouseListItemControllerState.onHouseSelected!(house);
                }
                if (selectHouseListItemControllerState.onUpdateListItemControllerState != null) {
                  selectHouseListItemControllerState.onUpdateListItemControllerState!();
                }
              },
            )
          )
        ]);
        j++;
      }
      VirtualSpacingListItemControllerState(height: Constant.paddingListItem);
      return true;
    }
    return false;
  }
}