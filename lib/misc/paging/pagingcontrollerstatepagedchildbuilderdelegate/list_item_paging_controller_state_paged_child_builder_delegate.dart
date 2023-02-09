import 'package:flutter/material.dart' hide Notification, Banner;
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../domain/entity/customer/customer.dart';
import '../../../presentation/widget/bill_item.dart';
import '../../../presentation/widget/carousel_list_item.dart';
import '../../../presentation/widget/colorful_chip_tab_bar.dart';
import '../../../presentation/widget/house_item.dart';
import '../../../presentation/widget/icon_title_and_description_list_item.dart';
import '../../../presentation/widget/modified_divider.dart';
import '../../../presentation/widget/modified_tab_bar.dart';
import '../../../presentation/widget/customer/horizontal_customer_item.dart';
import '../../../presentation/widget/customer/vertical_customer_item.dart';
import '../../../presentation/widget/prompt_indicator.dart';
import '../../../presentation/widget/shimmer_carousel_item.dart';
import '../../../presentation/widget/titleanddescriptionitem/title_and_description_item.dart';
import '../../../presentation/widget/titledescriptionandcontentitem/title_description_and_content_item.dart';
import '../../../presentation/widget/customer_detail_header.dart';
import '../../constant.dart';
import '../../controllerstate/listitemcontrollerstate/bill_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/carousel_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/colorful_chip_tab_bar_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/column_container_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/dynamic_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/empty_container_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/failed_prompt_indicator_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/house_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/icon_title_and_description_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/loading_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/non_expanded_item_in_row_child_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/non_expanded_item_in_row_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/page_keyed_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/product_detail_header_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/customerlistitemcontrollerstate/customer_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/customerlistitemcontrollerstate/vertical_customer_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/row_container_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/selectgenderlistitemcontrollerstate/select_house_item_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/spacing_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/tab_bar_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/title_description_and_content_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../../controllerstate/paging_controller_state.dart';
import '../../errorprovider/error_provider.dart';
import '../../injector.dart';
import '../../listitempagingparameterinjection/list_item_paging_parameter_injection.dart';
import '../../typedef.dart';
import '../../widget_helper.dart';
import 'paging_controller_state_paged_child_builder_delegate.dart';

class ListItemPagingControllerStatePagedChildBuilderDelegate<PageKeyType> extends PagingControllerStatePagedChildBuilderDelegate<PageKeyType, ListItemControllerState> {
  final List<ListItemPagingParameterInjection> listItemPagingParameterInjectionList;

  ListItemPagingControllerStatePagedChildBuilderDelegate({
    required PagingControllerState<PageKeyType, ListItemControllerState> pagingControllerState,
    WidgetBuilderWithError? firstPageErrorIndicatorBuilderWithErrorParameter,
    WidgetBuilderWithError? newPageErrorIndicatorBuilderWithErrorParameter,
    WidgetBuilder? firstPageProgressIndicatorBuilder,
    WidgetBuilder? newPageProgressIndicatorBuilder,
    WidgetBuilder? noItemsFoundIndicatorBuilder,
    WidgetBuilder? noMoreItemsIndicatorBuilder,
    bool animateTransitions = false,
    final Duration transitionDuration = const Duration(milliseconds: 250),
    this.listItemPagingParameterInjectionList = const []
  }) : super(
    pagingControllerState: pagingControllerState,
    itemBuilder: (context, item, index) => Container(),
    firstPageErrorIndicatorBuilderWithErrorParameter: firstPageErrorIndicatorBuilderWithErrorParameter ?? (context, e) => WidgetHelper.buildFailedPromptIndicatorFromErrorProvider(
      context: context,
      errorProvider: Injector.locator<ErrorProvider>(),
      e: e
    ),
    newPageErrorIndicatorBuilderWithErrorParameter: firstPageErrorIndicatorBuilderWithErrorParameter ?? (context, e) => WidgetHelper.buildFailedPromptIndicatorFromErrorProvider(
      context: context,
      errorProvider: Injector.locator<ErrorProvider>(),
      e: e,
      promptIndicatorType: PromptIndicatorType.horizontal,
      onPressed: () => pagingControllerState.pagingController.retryLastFailedRequest(),
      buttonText: "Retry".tr
    ),
    firstPageProgressIndicatorBuilder: firstPageProgressIndicatorBuilder,
    newPageProgressIndicatorBuilder: newPageProgressIndicatorBuilder,
    noItemsFoundIndicatorBuilder: noItemsFoundIndicatorBuilder,
    noMoreItemsIndicatorBuilder: noMoreItemsIndicatorBuilder,
  );

  @override
  ItemWidgetBuilder<ListItemControllerState> get itemBuilder => _itemBuilder;

  Widget _itemBuilder<ListItemControllerState>(BuildContext context, ListItemControllerState item, int index) {
    if (item is FailedPromptIndicatorListItemControllerState) {
      return WidgetHelper.buildFailedPromptIndicatorFromErrorProvider(context: context, errorProvider: item.errorProvider, e: item.e);
    } else if (item is CarouselListItemControllerState || item is ShimmerCarouselListItemControllerState) {
      // ignore: prefer_function_declarations_over_variables
      WidgetBuilderWithItem widgetBuilderWithItem = (context, value) {
        if (value is Customer) {
          return HorizontalCustomerItem(customer: value);
        } else if (value is ShimmerCarouselItemValue) {
          return const ShimmerCarouselItem();
        } else {
          return Container();
        }
      };
      if (item is CarouselListItemControllerState) {
        return CarouselListItem(
          padding: item.padding,
          itemList: item.item,
          title: item.title,
          description: item.description,
          builderWithItem: widgetBuilderWithItem
        );
      } else if (item is ShimmerCarouselListItemControllerState) {
        return ShimmerCarouselListItem(
          builderWithItem: widgetBuilderWithItem,
          padding: item.padding,
          showTitleShimmer: item.showTitleShimmer,
          showDescriptionShimmer: item.showDescriptionShimmer,
          showItemShimmer: item.showItemShimmer,
          shimmerCarouselListItemGenerator: item.shimmerCarouselListItemGenerator,
        );
      } else {
        return Container();
      }
    } else if (item is CustomerListItemControllerState) {
      if (item is VerticalCustomerListItemControllerState) {
        if (item is ShimmerVerticalCustomerListItemControllerState) {
          return ShimmerVerticalCustomerItem(customer: item.customer);
        } else {
          return VerticalCustomerItem(customer: item.customer, onClickCustomer: item.onClickCustomer);
        }
      } else {
        return Container();
      }
    } else if (item is BillListItemControllerState) {
      return BillItem(bill: item.bill, onClickBill: item.onClickBill);
    } else if (item is SelectHouseItemListItemControllerState) {
      return HouseItem(house: item.house, selectedHouseId: item.selectedHouseId, onClickHouse: item.onHouseSelected);
    } else if (item is HouseListItemControllerState) {
      return HouseItem(house: item.house, onClickHouse: item.onClickHouse);
    } else if (item is LoadingListItemControllerState) {
      return const Center(child: CircularProgressIndicator());
    } else if (item is DynamicListItemControllerState) {
      if (item.listItemControllerState is DynamicListItemControllerState) {
        throw FlutterError("You cannot set DynamicListItemControllerState type in DynamicListItemControllerState's listItemControllerState parameter, because it will causing stack overflow.");
      }
      return item.listItemControllerState != null ? _itemBuilder(context, item.listItemControllerState!, index) : Container();
    } else if (item is RowContainerListItemControllerState) {
      List<Widget> result = [];
      for (var listItemControllerState in item.rowChildListItemControllerState) {
        if (listItemControllerState is RowContainerListItemControllerState) {
          throw FlutterError("You cannot set RowContainerListItemControllerState type in RowContainerListItemControllerState's listItemControllerState parameter, because it will causing stack overflow.");
        }
        Widget rowChild = _itemBuilder(context, listItemControllerState, index);
        if (listItemControllerState is NonExpandedItemInRowControllerState) {
          if (listItemControllerState is NonExpandedItemInRowChildControllerState) {
            result.add(_itemBuilder(context, listItemControllerState.childListItemControllerState, index));
          } else {
            result.add(rowChild);
          }
        } else {
          result.add(Expanded(child: rowChild));
        }
      }
      Widget row = Row(children: result);
      return item.padding != null ? Padding(padding: item.padding!, child: row) : row;
    } else if (item is ColumnContainerListItemControllerState) {
      List<Widget> result = [];
      for (var listItemControllerState in item.columnChildListItemControllerState) {
        if (listItemControllerState is ColumnContainerListItemControllerState) {
          throw FlutterError("You cannot set ColumnContainerListItemControllerState type in ColumnContainerListItemControllerState's listItemControllerState parameter, because it will causing stack overflow.");
        }
        Widget columnChild = _itemBuilder(context, listItemControllerState, index);
        result.add(columnChild);
      }
      Widget column = Column(crossAxisAlignment: CrossAxisAlignment.start, children: result);
      return item.padding != null ? Padding(padding: item.padding!, child: column) : column;
    } else if (item is EmptyContainerListItemControllerState) {
      return Container();
    } else if (item is VirtualSpacingListItemControllerState) {
      return SizedBox(width: item.width, height: item.height ?? Constant.heightSpacingListItem);
    } else if (item is SpacingListItemControllerState) {
      return Container(color: item.color ?? Constant.colorSpacingListItem, width: item.width, height: item.height ?? Constant.heightSpacingListItem);
    } else if (item is DividerListItemControllerState) {
      return ModifiedDivider(
        lineColor: item.lineColor,
        lineHeight: item.lineHeight,
        borderRadius: item.borderRadius
      );
    } else if (item is TitleAndDescriptionListItemControllerState) {
      if (item is ShimmerTitleAndDescriptionListItemControllerState) {
        return ShimmerTitleAndDescriptionItem(
          title: item.title,
          description: item.description,
          padding: item.padding,
          verticalSpace: item.verticalSpace,
        );
      } else {
        return TitleAndDescriptionItem(
          title: item.title,
          description: item.description,
          padding: item.padding,
          verticalSpace: item.verticalSpace,
        );
      }
    } else if (item is TitleDescriptionAndContentListItemControllerState) {
      if (item.content is TitleDescriptionAndContentListItemControllerState) {
        throw FlutterError("You cannot set TitleDescriptionAndContentListItemControllerState type in TitleDescriptionAndContentListItemControllerState's content parameter, because it will causing stack overflow.");
      }
      return TitleDescriptionAndContentItem(
        title: item.title,
        description: item.description,
        builder: (context) => item.content != null ? _itemBuilder(context, item.content!, index) : Container(),
        verticalSpace: item.verticalSpace,
      );
    } else if (item is PageKeyedListItemControllerState) {
      if (item.listItemControllerState is PageKeyedListItemControllerState) {
        throw FlutterError("You cannot set PageKeyedListItemControllerState type in PageKeyedListItemControllerState's listItemControllerState parameter, because it will causing stack overflow.");
      }
      return item.listItemControllerState != null ? _itemBuilder(context, item.listItemControllerState!, index) : Container();
    } else if (item is ColorfulChipTabBarListItemControllerState) {
      return ColorfulChipTabBar(
        colorfulChipTabBarDataList: item.colorfulChipTabBarDataList,
        colorfulChipTabBarController: item.colorfulChipTabBarController,
      );
    } else if (item is ShimmerColorfulChipTabBarListItemControllerState) {
      return const ShimmerColorfulChipTabBar();
    } else if (item is TabBarListItemControllerState) {
      return ModifiedTabBar(
        tabs: item.tabDataList.map<Tab>((tabData) => Tab(
          height: tabData.height,
          text: tabData.text,
          icon: tabData.icon != null ? tabData.icon!(context) : null,
          iconMargin: tabData.iconMargin,
          child: tabData.child != null ? tabData.child!(context) : null,
        )).toList(),
        controller: item.tabController
      );
    } else if (item is BaseCustomerDetailHeaderListItemControllerState) {
      if (item is CustomerDetailHeaderListItemControllerState) {
        return CustomerDetailHeader(
          customer: item.customer,
        );
      } else if (item is ShimmerCustomerDetailHeaderListItemControllerState){
        return const ShimmerCustomerDetailHeader();
      } else {
        return Container();
      }
    } else if (item is WidgetSubstitutionListItemControllerState) {
      return item.widgetSubstitution(context, index);
    } else if (item is IconTitleAndDescriptionListItemControllerState) {
      return IconTitleAndDescriptionListItem(
        title: item.title,
        description: item.description,
        titleAndDescriptionItemInterceptor: item.titleAndDescriptionItemInterceptor,
        icon: item.iconListItemControllerState != null ? _itemBuilder(context, item.iconListItemControllerState, index) : null,
        space: item.space,
        verticalSpace: item.verticalSpace,
      );
    } else if (item is PaddingContainerListItemControllerState) {
      return Padding(
        padding: item.padding,
        child: _itemBuilder(context, item.paddingChildListItemControllerState, index)
      );
    } else {
      return Container();
    }
  }

  T? _findDesiredListItemPagingParameterInjection<T extends ListItemPagingParameterInjection>() {
    try {
      return listItemPagingParameterInjectionList.firstWhere((element) => element is T) as T;
    } on StateError catch (e) {
      if (e.message == "No element") {
        return null;
      }
      rethrow;
    }
  }
}