import '../../domain/entity/customer/customer.dart';
import '../../domain/entity/installment_status.dart';
import '../../domain/entity/user/customer_user.dart';
import '../../presentation/widget/carousel_list_item.dart';
import 'shimmer_carousel_list_item_generator.dart';
import 'type/shimmer_carousel_list_item_generator_type.dart';
import 'type/product_shimmer_carousel_list_item_generator_type.dart';

class DefaultShimmerCarouselListItemGenerator<T, G extends ShimmerCarouselListItemGeneratorType> extends ShimmerCarouselListItemGenerator<T, G> {
  final G _shimmerCarouselListItemGeneratorType;

  @override
  G get shimmerCarouselListItemGeneratorType => _shimmerCarouselListItemGeneratorType;

  DefaultShimmerCarouselListItemGenerator({
    required G shimmerCarouselListItemGeneratorType
  }) : _shimmerCarouselListItemGeneratorType = shimmerCarouselListItemGeneratorType;

  @override
  T onGenerateListItemValue() {
    if (_shimmerCarouselListItemGeneratorType is CustomerShimmerCarouselListItemGeneratorType) {
      return Customer(
        id: "",
        userId: "",
        marketingId: "",
        houseId: "",
        terminId: "",
        name: "Dummy Name",
        birthdate: "",
        birthplace: "",
        nik: "",
        email: "dummyemail@gmail.com",
        phone: "",
        address: "",
        postalCode: "",
        province: "",
        city: "",
        subDistrict: "",
        village: "",
        bookingFeeDate: DateTime.now(),
        bookingFeePicture: "",
        status: InstallmentStatus.unknown
      ) as T;
    } else if (_shimmerCarouselListItemGeneratorType is DefaultShimmerCarouselListItemGenerator) {
      return ShimmerCarouselItemValue() as T;
    } else {
      throw Exception("No item desired in generating shimmer carousel list item.");
    }
  }
}