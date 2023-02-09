import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../data/datasource/sourcedatasource/default_source_data_source.dart';
import '../data/datasource/sourcedatasource/source_data_source.dart';
import '../data/repository/default_source_repository.dart';
import '../domain/repository/source_repository.dart';
import 'additionalloadingindicatorchecker/customer_detail_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/customer_paging_result_parameter_checker.dart';
import 'defaultloaddataresultwidget/default_load_data_result_widget.dart';
import 'defaultloaddataresultwidget/main_default_load_data_result_widget.dart';
import 'errorprovider/default_error_provider.dart';
import 'errorprovider/error_provider.dart';
import 'http_client.dart';
import 'shimmercarousellistitemgenerator/factory/product_shimmer_carousel_list_item_generator_factory.dart';

class _Injector {
  final GetIt locator = GetIt.instance;

  void init() {
    // Error Provider
    locator.registerLazySingleton<ErrorProvider>(() => DefaultErrorProvider());
    
    // Shimmer Carousel List Item Generator
    locator.registerFactory<CustomerShimmerCarouselListItemGeneratorFactory>(() => CustomerShimmerCarouselListItemGeneratorFactory());

    // Additional Paging Result Parameter
    locator.registerFactory<CustomerPagingResultParameterChecker>(
      () => CustomerPagingResultParameterChecker(
        productShimmerCarouselListItemGeneratorFactory: locator()
      )
    );
    locator.registerFactory<CustomerDetailPagingResultParameterChecker>(
      () => CustomerDetailPagingResultParameterChecker(
        productShimmerCarouselListItemGeneratorFactory: locator()
      )
    );

    // Default Load Data Result Widget
    locator.registerLazySingleton<DefaultLoadDataResultWidget>(() => MainDefaultLoadDataResultWidget());

    // Repository
    locator.registerLazySingleton<SourceRepository>(() => DefaultSourceRepository(sourceDataSource: locator()));

    // Data Sources
    locator.registerLazySingleton<SourceDataSource>(() => DefaultSourceDataSource(dio: locator()));

    // Dio
    locator.registerLazySingleton<Dio>(() => DioHttpClient.of());
  }
}

// ignore: non_constant_identifier_names
final Injector = _Injector();