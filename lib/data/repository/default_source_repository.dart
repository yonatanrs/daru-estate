import '../../domain/entity/customer/get_customer_based_marketing_id_list_parameter.dart';
import '../../domain/entity/customer/get_customer_based_marketing_id_list_response.dart';
import '../../domain/entity/customer/get_customer_list_parameter.dart';
import '../../domain/entity/customer/get_customer_list_response.dart';
import '../../domain/entity/customer/new_customer_parameter.dart';
import '../../domain/entity/customer/new_customer_response.dart';
import '../../domain/entity/house/get_house_list_parameter.dart';
import '../../domain/entity/house/get_house_list_response.dart';
import '../../domain/entity/login/login_parameter.dart';
import '../../domain/entity/login/login_response.dart';
import '../../domain/entity/marketing/get_marketing_list_parameter.dart';
import '../../domain/entity/marketing/get_marketing_list_response.dart';
import '../../domain/entity/modification/get_modification_list_parameter.dart';
import '../../domain/entity/modification/get_modification_list_response.dart';
import '../../domain/entity/mybill/get_my_bill_parameter.dart';
import '../../domain/entity/mybill/get_my_bill_response.dart';
import '../../domain/entity/mydata/get_my_data_parameter.dart';
import '../../domain/entity/mydata/get_my_data_response.dart';
import '../../domain/entity/payment/get_payment_list_parameter.dart';
import '../../domain/entity/payment/get_payment_list_response.dart';
import '../../domain/entity/scheme/get_scheme_list_parameter.dart';
import '../../domain/entity/scheme/get_scheme_list_response.dart';
import '../../domain/entity/updatedata/update_data_parameter.dart';
import '../../domain/entity/updatedata/update_data_response.dart';
import '../../domain/repository/source_repository.dart';
import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../datasource/sourcedatasource/source_data_source.dart';

class DefaultSourceRepository implements SourceRepository {
  final SourceDataSource sourceDataSource;

  const DefaultSourceRepository({
    required this.sourceDataSource
  });

  @override
  FutureProcessing<LoadDataResult<GetCustomerBasedMarketingIdPagingResponse>> getCustomerBasedMarketingIdList(GetCustomerBasedMarketingIdListParameter getCustomerBasedMarketingIdListParameter) {
    return sourceDataSource.getCustomerBasedMarketingIdList(getCustomerBasedMarketingIdListParameter)
      .mapToLoadDataResult<GetCustomerBasedMarketingIdPagingResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<GetCustomerPagingResponse>> getCustomerList(GetCustomerListParameter getCustomerListParameter) {
    return sourceDataSource.getCustomerList(getCustomerListParameter)
      .mapToLoadDataResult<GetCustomerPagingResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<GetHouseListResponse>> getHouseList(GetHouseListParameter getHouseListParameter) {
    return sourceDataSource.getHouseList(getHouseListParameter)
      .mapToLoadDataResult<GetHouseListResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<GetMarketingListResponse>> getMarketingList(GetMarketingListParameter getMarketingListParameter) {
    return sourceDataSource.getMarketingList(getMarketingListParameter)
      .mapToLoadDataResult<GetMarketingListResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<GetModificationListResponse>> getModificationList(GetModificationListParameter getModificationListParameter) {
    return sourceDataSource.getModificationList(getModificationListParameter)
      .mapToLoadDataResult<GetModificationListResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<GetMyBillResponse>> getMyBill(GetMyBillParameter getMyBillParameter) {
    return sourceDataSource.getMyBill(getMyBillParameter)
      .mapToLoadDataResult<GetMyBillResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<GetMyDataResponse>> getMyData(GetMyDataParameter getMyDataParameter) {
    return sourceDataSource.getMyData(getMyDataParameter)
      .mapToLoadDataResult<GetMyDataResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<GetPaymentListResponse>> getPaymentList(GetPaymentListParameter getPaymentListParameter) {
    return sourceDataSource.getPaymentList(getPaymentListParameter)
      .mapToLoadDataResult<GetPaymentListResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<GetSchemeListResponse>> getSchemeList(GetSchemeListParameter getSchemeListParameter) {
    return sourceDataSource.getSchemeList(getSchemeListParameter)
      .mapToLoadDataResult<GetSchemeListResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<LoginResponse>> login(LoginParameter loginParameter) {
    return sourceDataSource.login(loginParameter)
      .mapToLoadDataResult<LoginResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<NewCustomerResponse>> newCustomer(NewCustomerParameter newCustomerParameter) {
    return sourceDataSource.newCustomer(newCustomerParameter)
      .mapToLoadDataResult<NewCustomerResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<UpdateDataResponse>> updateData(UpdateDataParameter updateDataParameter) {
    return sourceDataSource.updateData(updateDataParameter)
      .mapToLoadDataResult<UpdateDataResponse>();
  }
}