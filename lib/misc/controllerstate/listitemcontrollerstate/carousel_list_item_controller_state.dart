import 'package:flutter/material.dart';

import '../../shimmercarousellistitemgenerator/shimmer_carousel_list_item_generator.dart';
import '../../shimmercarousellistitemgenerator/type/shimmer_carousel_list_item_generator_type.dart';
import 'list_item_controller_state.dart';

class CarouselListItemControllerState<T> extends ListItemControllerState {
  EdgeInsetsGeometry? padding;
  double? betweenTitleDescriptionAndCarouselItemVerticalSpace;
  List<T> item;
  String title;
  String description;

  CarouselListItemControllerState({
    this.padding,
    this.betweenTitleDescriptionAndCarouselItemVerticalSpace,
    this.item = const [],
    this.title = "",
    this.description = "",
  });
}

class ShimmerCarouselListItemControllerState<T, G extends ShimmerCarouselListItemGeneratorType> extends ListItemControllerState {
  EdgeInsetsGeometry? padding;
  double? betweenTitleDescriptionAndCarouselItemVerticalSpace;
  bool showTitleShimmer;
  bool showDescriptionShimmer;
  bool showItemShimmer;
  ShimmerCarouselListItemGenerator<T, G> shimmerCarouselListItemGenerator;

  ShimmerCarouselListItemControllerState({
    this.padding,
    this.betweenTitleDescriptionAndCarouselItemVerticalSpace,
    this.showTitleShimmer = true,
    this.showDescriptionShimmer = true,
    this.showItemShimmer = true,
    required this.shimmerCarouselListItemGenerator
  });
}