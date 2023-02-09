import 'package:flutter/material.dart' hide Banner;
import 'package:daru_estate/misc/ext/string_ext.dart';
import 'package:sizer/sizer.dart';

import '../../misc/constant.dart';
import '../../misc/shimmercarousellistitemgenerator/shimmer_carousel_list_item_generator.dart';
import '../../misc/shimmercarousellistitemgenerator/type/shimmer_carousel_list_item_generator_type.dart';
import '../../misc/typedef.dart';
import 'modified_shimmer.dart';
import 'titleanddescriptionitem/title_and_description_item.dart';

class CarouselListItem<T> extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final double? betweenTitleDescriptionAndCarouselItemVerticalSpace;
  final String title;
  final String description;
  final List<T> itemList;
  final WidgetBuilderWithItem<T> builderWithItem;

  const CarouselListItem({
    Key? key,
    this.padding,
    this.betweenTitleDescriptionAndCarouselItemVerticalSpace,
    this.title = "",
    this.description = "",
    required this.itemList,
    required this.builderWithItem
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _InnerCarouselListItem<T>(
      padding: padding,
      betweenTitleDescriptionAndCarouselItemVerticalSpace: betweenTitleDescriptionAndCarouselItemVerticalSpace,
      title: title,
      description: description,
      itemList: itemList,
      builderWithItem: builderWithItem
    );
  }
}

class ShimmerCarouselListItem<T, G extends ShimmerCarouselListItemGeneratorType> extends StatelessWidget {
  final WidgetBuilderWithItem<T> builderWithItem;
  final EdgeInsetsGeometry? padding;
  final double? betweenTitleDescriptionAndCarouselItemVerticalSpace;
  final bool showTitleShimmer;
  final bool showDescriptionShimmer;
  final bool showItemShimmer;
  final ShimmerCarouselListItemGenerator<T, G> shimmerCarouselListItemGenerator;

  const ShimmerCarouselListItem({
    Key? key,
    required this.builderWithItem,
    this.padding,
    this.betweenTitleDescriptionAndCarouselItemVerticalSpace,
    required this.showTitleShimmer,
    required this.showDescriptionShimmer,
    required this.showItemShimmer,
    required this.shimmerCarouselListItemGenerator
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ModifiedShimmer.fromColors(
        child: _InnerCarouselListItem<T>(
          padding: padding,
          betweenTitleDescriptionAndCarouselItemVerticalSpace: betweenTitleDescriptionAndCarouselItemVerticalSpace,
          title: showTitleShimmer ? "Dummy Title" : "",
          description: showDescriptionShimmer ? "Dummy Description" : "",
          itemList: List<T>.generate(10, (index) {
            return shimmerCarouselListItemGenerator.onGenerateListItemValue();
          }),
          builderWithItem: builderWithItem
        )
      )
    );
  }
}

class _InnerCarouselListItem<T> extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final double? betweenTitleDescriptionAndCarouselItemVerticalSpace;
  final String title;
  final String description;
  final List<T> itemList;
  final WidgetBuilderWithItem<T> builderWithItem;

  const _InnerCarouselListItem({
    Key? key,
    this.padding,
    this.betweenTitleDescriptionAndCarouselItemVerticalSpace,
    required this.title,
    required this.description,
    required this.itemList,
    required this.builderWithItem
  }) : super(key: key);

  @override
  State<_InnerCarouselListItem<T>> createState() => _InnerCarouselListItemState<T>();
}

class _InnerCarouselListItemState<T> extends State<_InnerCarouselListItem<T>> with AutomaticKeepAliveClientMixin<_InnerCarouselListItem<T>> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    double? verticalSpace = widget.betweenTitleDescriptionAndCarouselItemVerticalSpace;
    double? left;
    double? top;
    double? right;
    double? bottom;
    if (widget.padding is EdgeInsets) {
      EdgeInsets edgeInsets = widget.padding as EdgeInsets;
      left = edgeInsets.left;
      top = edgeInsets.top;
      right = edgeInsets.right;
      bottom = edgeInsets.bottom;
    } else if (widget.padding is EdgeInsetsDirectional) {
      EdgeInsetsDirectional edgeInsetsDirectional = widget.padding as EdgeInsetsDirectional;
      left = edgeInsetsDirectional.start;
      top = edgeInsetsDirectional.top;
      right = edgeInsetsDirectional.end;
      bottom = edgeInsetsDirectional.bottom;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndDescriptionItem(
          padding: EdgeInsets.only(
            left: left ?? Constant.paddingListItem,
            top: top ?? Constant.paddingListItem,
            right: right ?? Constant.paddingListItem,
          ),
          title: widget.title,
          description: widget.description,
          verticalSpace: 0.3.h,
        ),
        if (!widget.title.isEmptyString || !widget.description.isEmptyString)
          SizedBox(height: verticalSpace ?? Constant.paddingListItem),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(
            left: left ?? Constant.paddingListItem,
            right: right ?? Constant.paddingListItem,
          ),
          child: Builder(
            builder: (context) {
              List<Widget> itemMap = [];
              int i = 0;
              while (i < widget.itemList.length) {
                if (i > 0) {
                  itemMap.add(SizedBox(width: 3.w));
                }
                itemMap.add(widget.builderWithItem(context, widget.itemList[i]));
                i++;
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: itemMap,
              );
            },
          )
        ),
        SizedBox(height: bottom ?? Constant.paddingListItem)
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ShimmerCarouselItemValue {}