import 'package:daru_estate/data/entitymapping/source_entity_mapping.dart';
import 'package:daru_estate/misc/ext/future_ext.dart';
import 'package:daru_estate/misc/ext/response_wrapper_ext.dart';
import 'package:dio/dio.dart';

import '../../../misc/processing/dio_http_client_processing.dart';
import 'source_data_source.dart';
import '../../../misc/processing/future_processing.dart';
import '../../../domain/entity/customer/get_customer_based_marketing_id_list_parameter.dart';
import '../../../domain/entity/customer/get_customer_based_marketing_id_list_response.dart';
import '../../../domain/entity/customer/get_customer_list_parameter.dart';
import '../../../domain/entity/customer/get_customer_list_response.dart';
import '../../../domain/entity/customer/new_customer_parameter.dart';
import '../../../domain/entity/customer/new_customer_response.dart';
import '../../../domain/entity/house/get_house_list_parameter.dart';
import '../../../domain/entity/house/get_house_list_response.dart';
import '../../../domain/entity/login/login_parameter.dart';
import '../../../domain/entity/login/login_response.dart';
import '../../../domain/entity/marketing/get_marketing_list_parameter.dart';
import '../../../domain/entity/marketing/get_marketing_list_response.dart';
import '../../../domain/entity/modification/get_modification_list_parameter.dart';
import '../../../domain/entity/modification/get_modification_list_response.dart';
import '../../../domain/entity/mybill/get_my_bill_parameter.dart';
import '../../../domain/entity/mybill/get_my_bill_response.dart';
import '../../../domain/entity/mydata/get_my_data_parameter.dart';
import '../../../domain/entity/mydata/get_my_data_response.dart';
import '../../../domain/entity/payment/get_payment_list_parameter.dart';
import '../../../domain/entity/payment/get_payment_list_response.dart';
import '../../../domain/entity/scheme/get_scheme_list_parameter.dart';
import '../../../domain/entity/scheme/get_scheme_list_response.dart';
import '../../../domain/entity/updatedata/update_data_parameter.dart';
import '../../../domain/entity/updatedata/update_data_response.dart';

class DefaultSourceDataSource implements SourceDataSource {
  final Dio dio;

  const DefaultSourceDataSource({
    required this.dio
  });

  @override
  FutureProcessing<LoginResponse> login(LoginParameter loginParameter) {
    FormData formData = FormData.fromMap(<String, dynamic>{
      "email": loginParameter.email,
      "password": loginParameter.password
    });
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/login", data: formData, cancelToken: cancelToken)
        .map<LoginResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToLoginResponse());
    });
  }

  @override
  FutureProcessing<GetMarketingListResponse> getMarketingList(GetMarketingListParameter getMarketingListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/v1/marketings", cancelToken: cancelToken)
        .map<GetMarketingListResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToGetMarketingListResponse());
    });
  }

  @override
  FutureProcessing<GetCustomerPagingResponse> getCustomerList(GetCustomerListParameter getCustomerListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/v1/customers", cancelToken: cancelToken)
        .map<GetCustomerPagingResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToGetCustomerListResponse());
    });
  }

  @override
  FutureProcessing<GetModificationListResponse> getModificationList(GetModificationListParameter getModificationListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/v1/modifications", cancelToken: cancelToken)
        .map<GetModificationListResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToGetModificationListResponse());
    });
  }

  @override
  FutureProcessing<GetSchemeListResponse> getSchemeList(GetSchemeListParameter getSchemeListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/v1/schemes", cancelToken: cancelToken)
        .map<GetSchemeListResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToGetSchemeListResponse());
    });
  }

  @override
  FutureProcessing<GetPaymentListResponse> getPaymentList(GetPaymentListParameter getPaymentListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/v1/payments", cancelToken: cancelToken)
        .map<GetPaymentListResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToGetPaymentListResponse());
    });
  }

  @override
  FutureProcessing<GetHouseListResponse> getHouseList(GetHouseListParameter getHouseListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/v1/listhouses", cancelToken: cancelToken, queryParameters: <String, dynamic>{"page": getHouseListParameter.page})
        .map<GetHouseListResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToGetHouseListResponse());
    });
  }

  @override
  FutureProcessing<GetMyDataResponse> getMyData(GetMyDataParameter getMyDataParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/v1/mydata/${getMyDataParameter.id}", queryParameters: <String, dynamic>{"includeUser": true}, cancelToken: cancelToken)
        .map<GetMyDataResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToGetMyDataResponse());
    });
  }

  @override
  FutureProcessing<GetMyBillResponse> getMyBill(GetMyBillParameter getMyBillParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/v1/mybills", cancelToken: cancelToken, queryParameters: <String, dynamic>{"customerId[eq]": getMyBillParameter.customerId, "page": getMyBillParameter.page})
        .map<GetMyBillResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToGetMyBillResponse());
    });
  }

  @override
  FutureProcessing<UpdateDataResponse> updateData(UpdateDataParameter updateDataParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.put("/v1/updatedata", cancelToken: cancelToken)
        .map<UpdateDataResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToUpdateDataResponse());
    });
  }

  @override
  FutureProcessing<GetCustomerBasedMarketingIdPagingResponse> getCustomerBasedMarketingIdList(GetCustomerBasedMarketingIdListParameter getCustomerBasedMarketingIdListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/v1/listcustomers", cancelToken: cancelToken, queryParameters: <String, dynamic>{"marketingId[eq]": getCustomerBasedMarketingIdListParameter.marketingId, "page": getCustomerBasedMarketingIdListParameter.page})
        .map<GetCustomerBasedMarketingIdPagingResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToGetCustomerBasedMarketingIdListResponse());
    });
  }

  @override
  FutureProcessing<NewCustomerResponse> newCustomer(NewCustomerParameter newCustomerParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      FormData formData = FormData.fromMap(<String, dynamic>{
        "marketingId": newCustomerParameter.marketingId,
        "houseId": newCustomerParameter.houseId,
        "terminId": "1",
        "name": newCustomerParameter.name,
        "birthdate": newCustomerParameter.birthdate,
        "birthplace": newCustomerParameter.birthplace,
        "nik": newCustomerParameter.nik,
        "email": newCustomerParameter.email,
        "phone": newCustomerParameter.phone,
        "address": newCustomerParameter.address,
        "postalCode": newCustomerParameter.postalCode,
        "province": newCustomerParameter.province,
        "city": newCustomerParameter.city,
        "subDistrict": newCustomerParameter.subDistrict,
        "village": newCustomerParameter.village,
        "bookingFeeDate": newCustomerParameter.bookingFeeDate,
        "bookingFeePic": await MultipartFile.fromFile(newCustomerParameter.bookingFeePicture),
        "status": newCustomerParameter.status
      });
      return dio.post("/v1/newcustomers", data: formData, cancelToken: cancelToken)
        .map<NewCustomerResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToNewCustomerResponse());
    });
  }
}