import '../shimmer_carousel_list_item_generator.dart';
import '../type/shimmer_carousel_list_item_generator_type.dart';

abstract class ShimmerCarouselListItemGeneratorFactory<T, G extends ShimmerCarouselListItemGeneratorType> {
  ShimmerCarouselListItemGenerator<T, G> getShimmerCarouselListItemGeneratorType();
}