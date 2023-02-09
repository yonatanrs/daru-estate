import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../misc/itemtypelistinterceptor/item_type_list_interceptor.dart';
import 'modified_custom_paged_sliver_list.dart';

class ModifiedCustomPagedListView<PageKeyType, ItemType> extends PagedListView<PageKeyType, ItemType> {
  final bool _shrinkWrapFirstPageIndicators;
  final IndexedWidgetBuilder? _separatorBuilder;
  final List<ItemTypeListInterceptor<ItemType>> itemTypeListInterceptorList;

  const ModifiedCustomPagedListView({
    required PagingController<PageKeyType, ItemType> pagingController,
    required PagedChildBuilderDelegate<ItemType> builderDelegate,
    ScrollController? scrollController,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    double? itemExtent,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    required this.itemTypeListInterceptorList,
    Key? key,
  }) : _separatorBuilder = null,
      _shrinkWrapFirstPageIndicators = shrinkWrap,
      super(
        pagingController: pagingController,
        builderDelegate: builderDelegate,
        scrollController: scrollController,
        scrollDirection: scrollDirection,
        reverse: reverse,
        primary: primary,
        physics: physics,
        shrinkWrap: shrinkWrap,
        padding: padding,
        itemExtent: itemExtent,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        cacheExtent: cacheExtent,
        dragStartBehavior: dragStartBehavior,
        keyboardDismissBehavior: keyboardDismissBehavior,
        restorationId: restorationId,
        clipBehavior: clipBehavior,
        key: key,
      );

  const ModifiedCustomPagedListView.separated({
    required PagingController<PageKeyType, ItemType> pagingController,
    required PagedChildBuilderDelegate<ItemType> builderDelegate,
    required IndexedWidgetBuilder separatorBuilder,
    ScrollController? scrollController,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    double? itemExtent,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    required this.itemTypeListInterceptorList,
    Key? key,
  }) : _shrinkWrapFirstPageIndicators = shrinkWrap,
      _separatorBuilder = separatorBuilder,
      super.separated(
        pagingController: pagingController,
        builderDelegate: builderDelegate,
        separatorBuilder: separatorBuilder,
        scrollController: scrollController,
        scrollDirection: scrollDirection,
        reverse: reverse,
        primary: primary,
        physics: physics,
        shrinkWrap: shrinkWrap,
        padding: padding,
        itemExtent: itemExtent,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        cacheExtent: cacheExtent,
        dragStartBehavior: dragStartBehavior,
        keyboardDismissBehavior: keyboardDismissBehavior,
        restorationId: restorationId,
        clipBehavior: clipBehavior,
        key: key,
      );

  @override
  Widget buildChildLayout(BuildContext context) {
    final separatorBuilder = _separatorBuilder;
    return separatorBuilder != null ? ModifiedCustomPagedSliverList<PageKeyType, ItemType>.separated(
      builderDelegate: builderDelegate,
      pagingController: pagingController,
      separatorBuilder: separatorBuilder,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      itemExtent: itemExtent,
      shrinkWrapFirstPageIndicators: _shrinkWrapFirstPageIndicators,
      itemTypeListInterceptorList: itemTypeListInterceptorList,
    ) : ModifiedCustomPagedSliverList<PageKeyType, ItemType>(
      builderDelegate: builderDelegate,
      pagingController: pagingController,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      itemExtent: itemExtent,
      shrinkWrapFirstPageIndicators: _shrinkWrapFirstPageIndicators,
      itemTypeListInterceptorList: itemTypeListInterceptorList,
    );
  }
}
