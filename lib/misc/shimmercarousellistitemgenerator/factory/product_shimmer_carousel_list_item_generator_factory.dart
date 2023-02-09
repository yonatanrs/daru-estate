import '../../../domain/entity/customer/customer.dart';
import '../default_shimmer_carousel_list_item_generator.dart';
import '../shimmer_carousel_list_item_generator.dart';
import '../type/product_shimmer_carousel_list_item_generator_type.dart';
import 'shimmer_carousel_list_item_generator_factory.dart';

class CustomerShimmerCarouselListItemGeneratorFactory extends ShimmerCarouselListItemGeneratorFactory<Customer, CustomerShimmerCarouselListItemGeneratorType> {
  @override
  ShimmerCarouselListItemGenerator<Customer, CustomerShimmerCarouselListItemGeneratorType> getShimmerCarouselListItemGeneratorType() {
    return DefaultShimmerCarouselListItemGenerator<Customer, CustomerShimmerCarouselListItemGeneratorType>(
      shimmerCarouselListItemGeneratorType: CustomerShimmerCarouselListItemGeneratorType()
    );
  }
}