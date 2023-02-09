import '../../domain/entity/customer/customer.dart';
import '../../domain/entity/installment_status.dart';
import '../../domain/entity/user/customer_user.dart';
import '../controllerstate/listitemcontrollerstate/customerlistitemcontrollerstate/vertical_customer_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../paging/pagingresult/paging_result_with_parameter.dart';
import '../shimmercarousellistitemgenerator/factory/product_shimmer_carousel_list_item_generator_factory.dart';
import 'additional_paging_result_parameter_checker.dart';

class CustomerPagingResultParameterChecker extends AdditionalPagingResultParameterChecker<int, ListItemControllerState> {
  final CustomerShimmerCarouselListItemGeneratorFactory productShimmerCarouselListItemGeneratorFactory;

  CustomerPagingResultParameterChecker({
    required this.productShimmerCarouselListItemGeneratorFactory
  });

  @override
  PagingResultParameter<ListItemControllerState>? getAdditionalPagingResultParameter(
    AdditionalPagingResultCheckerParameter additionalPagingResultCheckerParameter
  ) {
    int page = additionalPagingResultCheckerParameter.page;
    List<ListItemControllerState> shimmerVerticalCustomerListItemControllerState = List<ListItemControllerState>.generate(6, (index) => ShimmerVerticalCustomerListItemControllerState(
      customer: Customer(
        id: "",
        userId: "",
        marketingId: "",
        houseId: "",
        terminId: "",
        name: "",
        birthdate: "",
        birthplace: "",
        nik: "",
        email: "",
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
      )
    ));
    if (page == 1) {
      return PagingResultParameter<ListItemControllerState>(
        additionalItemList: <ListItemControllerState>[
          ...shimmerVerticalCustomerListItemControllerState
        ],
        showOriginalLoaderIndicator: false
      );
    } else {
      return null;
    }
  }
}