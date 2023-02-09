import 'type/shimmer_carousel_list_item_generator_type.dart';

abstract class ShimmerCarouselListItemGenerator<T, G extends ShimmerCarouselListItemGeneratorType> {
  G get shimmerCarouselListItemGeneratorType;
  T onGenerateListItemValue();
}