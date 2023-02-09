import 'package:flutter/material.dart';
import '../../controllerstate/listitemcontrollerstate/empty_container_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/row_container_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../../listitemcontrollerstatewrapperparameter/list_item_controller_state_wrapper_parameter.dart';
import '../../listitemcontrollerstatewrapperparameter/vertical_grid_list_item_controller_state_wrapper_parameter.dart';
import '../../typedef.dart';
import '../item_type_list_sub_interceptor.dart';

typedef OnCheckLastRowContainerListing = void Function({
  required List<ListItemControllerState> listItemControllerStateList,
  void Function(RowContainerListItemControllerState)? beforeCheckLastRowContainerListing,
  void Function(RowContainerListItemControllerState)? afterCheckLastRowContainerListing,
  VerticalGridPaddingContentSubInterceptorSupportParameter? verticalGridPaddingContentSubInterceptorSupportParameter
});

typedef OnAddFirstRowChildIndex = void Function(
  ListItemControllerState oldItemType,
  VerticalGridPaddingContentSubInterceptorSupportParameter? verticalGridPaddingContentSubInterceptorSupportParameter
);

typedef OnAddFirstRowChildIndexAndCheckLastRowContainerListing = void Function(
  ListItemControllerState oldItemType,
  List<ListItemControllerState> listItemControllerStateList,
  VerticalGridPaddingContentSubInterceptorSupportParameter? verticalGridPaddingContentSubInterceptorSupportParameter
);

abstract class VerticalGridItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  late int _i;
  late int _maxRow;
  late int _indexedMaxRow;
  late int _rowChildIndex;
  late int _createdRowCount;

  late OnCheckLastRowContainerListing _onCheckLastRowContainerListing;
  late OnAddFirstRowChildIndex _onAddFirstRowChildIndex;
  late OnAddFirstRowChildIndexAndCheckLastRowContainerListing _onAddFirstRowChildIndexAndCheckLastRowContainerListing;

  VerticalGridItemTypeListSubInterceptor({
    required this.padding,
    required this.itemSpacing,
    required this.listItemControllerStateItemTypeInterceptorChecker
  }) {
    _i = 0;
    _maxRow = 2;
    _indexedMaxRow = _maxRow - 1;
    _rowChildIndex = 0;
    _createdRowCount = 0;
  }

  @override
  void onInit(List<ListItemControllerState> oldItemTypeList, List<ListItemControllerState> newItemTypeList) {
    // ignore: prefer_function_declarations_over_variables
    _onCheckLastRowContainerListing = ({
      required listItemControllerStateList,
      beforeCheckLastRowContainerListing,
      afterCheckLastRowContainerListing,
      verticalGridPaddingContentSubInterceptorSupportParameter
    }) {
      ListItemControllerState lastNewItemType = newItemTypeList[newItemTypeList.length - 1];
      if (lastNewItemType is RowContainerListItemControllerState) {
        if (beforeCheckLastRowContainerListing != null) {
          beforeCheckLastRowContainerListing(lastNewItemType);
        }
        if (afterCheckLastRowContainerListing != null) {
          afterCheckLastRowContainerListing(lastNewItemType);
        }
        if (_i == listItemControllerStateList.length - 1) {
          if (_rowChildIndex < _indexedMaxRow) {
            int remaining = _indexedMaxRow - _rowChildIndex;
            int j = 0;
            while (j < remaining) {
              lastNewItemType.rowChildListItemControllerState.addAll(
                <ListItemControllerState>[
                  VirtualSpacingListItemControllerState(width: itemSpacing()),
                  EmptyContainerListItemControllerState(),
                ]
              );
              j++;
            }
          }
          void addBottomVirtualSpacing({double? bottom}) => newItemTypeList.add(
            VirtualSpacingListItemControllerState(height: bottom ?? padding())
          );
          if (verticalGridPaddingContentSubInterceptorSupportParameter == null) {
            addBottomVirtualSpacing();
          } else {
            double? paddingBottom = verticalGridPaddingContentSubInterceptorSupportParameter.paddingBottom;
            if (paddingBottom != null) {
              if (!paddingBottom.isNegative) {
                addBottomVirtualSpacing(bottom: paddingBottom);
              }
            } else {
              addBottomVirtualSpacing();
            }
          }
        }
      }
    };
    // ignore: prefer_function_declarations_over_variables
    _onAddFirstRowChildIndex = (oldItemType, verticalGridPaddingContentSubInterceptorSupportParameter) {
      _rowChildIndex = 0;
      void addTopVirtualSpacing({double? top}) => newItemTypeList.add(
        VirtualSpacingListItemControllerState(height: top ?? padding())
      );

      if (_createdRowCount == 0) {
        if (verticalGridPaddingContentSubInterceptorSupportParameter == null) {
          addTopVirtualSpacing();
        } else {
          double? paddingTop = verticalGridPaddingContentSubInterceptorSupportParameter.paddingTop;
          if (paddingTop != null) {
            if (!paddingTop.isNegative) {
              addTopVirtualSpacing(top: paddingTop);
            }
          } else {
            addTopVirtualSpacing();
          }
        }
      } else {
        addTopVirtualSpacing(top: itemSpacing());
      }
      newItemTypeList.add(
        RowContainerListItemControllerState(
          padding: EdgeInsets.symmetric(horizontal: padding()),
          rowChildListItemControllerState: [oldItemType]
        )
      );
      _createdRowCount += 1;
    };
    // ignore: prefer_function_declarations_over_variables
    _onAddFirstRowChildIndexAndCheckLastRowContainerListing = (oldItemType, listItemControllerStateList, verticalGridPaddingContentSubInterceptorSupportParameter) {
      _onAddFirstRowChildIndex(oldItemType, verticalGridPaddingContentSubInterceptorSupportParameter);
      _onCheckLastRowContainerListing(listItemControllerStateList: listItemControllerStateList);
    };
  }

  @override
  bool intercept(
    int i,
    ListItemControllerStateWrapper oldItemTypeWrapper,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newItemTypeList
  ) {
    _i = i;
    ListItemControllerState oldItemType = oldItemTypeWrapper.listItemControllerState;
    if (oldItemType is VerticalGridPaddingContentSubInterceptorSupportListItemControllerState) {
      _i = 0;
      int j = 0;
      List<ListItemControllerState> childListItemControllerStateList = oldItemType.childListItemControllerStateList;
      while (j < childListItemControllerStateList.length) {
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          _i,
          ParameterizedListItemControllerStateWrapper(
            childListItemControllerStateList[j],
            VerticalListItemControllerStateWrapperParameter(
              verticalGridPaddingContentSubInterceptorSupportParameter: oldItemType.verticalGridPaddingContentSubInterceptorSupportParameter
            )
          ),
          childListItemControllerStateList,
          newItemTypeList
        );
        _i += 1;
        j++;
      }
      return true;
    } else {
      VerticalListItemControllerStateWrapperParameter? verticalListItemControllerStateWrapperParameter;
      if (oldItemTypeWrapper is ParameterizedListItemControllerStateWrapper) {
        ListItemControllerStateWrapperParameter listItemControllerStateWrapperParameter = oldItemTypeWrapper.listItemControllerStateWrapperParameter;
        if (listItemControllerStateWrapperParameter is VerticalListItemControllerStateWrapperParameter) {
          verticalListItemControllerStateWrapperParameter = listItemControllerStateWrapperParameter;
        }
      }
      if (checkingListItemControllerState(oldItemType)) {
        int indexedMaxRow = _maxRow - 1;
        if (_createdRowCount == 0 || _rowChildIndex >= indexedMaxRow) {
          _onAddFirstRowChildIndexAndCheckLastRowContainerListing(
            oldItemType, oldItemTypeList, verticalListItemControllerStateWrapperParameter?.verticalGridPaddingContentSubInterceptorSupportParameter
          );
        } else {
          _onCheckLastRowContainerListing(
            listItemControllerStateList: oldItemTypeList,
            beforeCheckLastRowContainerListing: (listItemControllerState) {
              listItemControllerState.rowChildListItemControllerState.addAll(
                <ListItemControllerState>[
                  VirtualSpacingListItemControllerState(width: itemSpacing()),
                  oldItemType,
                ]
              );
            },
            afterCheckLastRowContainerListing: (listItemControllerState) => _rowChildIndex += 1
          );
        }
        return true;
      } else {
        _rowChildIndex = 0;
        _createdRowCount = 0;
        return false;
      }
    }
  }

  bool checkingListItemControllerState(ListItemControllerState oldItemType);
}

class VerticalGridPaddingContentSubInterceptorSupportListItemControllerState extends ListItemControllerState {
  List<ListItemControllerState> childListItemControllerStateList;
  VerticalGridPaddingContentSubInterceptorSupportParameter? verticalGridPaddingContentSubInterceptorSupportParameter;

  VerticalGridPaddingContentSubInterceptorSupportListItemControllerState({
    required this.childListItemControllerStateList,
    this.verticalGridPaddingContentSubInterceptorSupportParameter
  });
}

class VerticalGridPaddingContentSubInterceptorSupportParameter {
  double? paddingTop;
  double? paddingBottom;

  VerticalGridPaddingContentSubInterceptorSupportParameter({
    this.paddingTop,
    this.paddingBottom
  });
}