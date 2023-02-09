import 'package:daru_estate/data/entitymapping/authorization_entity_mapping.dart';
import 'package:daru_estate/data/entitymapping/bill_entity_mapping.dart';
import 'package:daru_estate/data/entitymapping/customer_entity_mapping.dart';
import 'package:daru_estate/data/entitymapping/house_entity_mapping.dart';
import 'package:daru_estate/data/entitymapping/user_entity_mapping.dart';
import 'package:daru_estate/misc/ext/response_wrapper_ext.dart';

import '../../domain/entity/customer/customer.dart';
import '../../domain/entity/customer/get_customer_based_marketing_id_list_response.dart';
import '../../domain/entity/customer/get_customer_list_response.dart';
import '../../domain/entity/customer/new_customer_response.dart';
import '../../domain/entity/house/get_house_list_response.dart';
import '../../domain/entity/house/house.dart';
import '../../domain/entity/login/login_response.dart';
import '../../domain/entity/marketing/get_marketing_list_response.dart';
import '../../domain/entity/modification/get_modification_list_response.dart';
import '../../domain/entity/mybill/bill.dart';
import '../../domain/entity/mybill/get_my_bill_response.dart';
import '../../domain/entity/mydata/get_my_data_response.dart';
import '../../domain/entity/payment/get_payment_list_response.dart';
import '../../domain/entity/scheme/get_scheme_list_response.dart';
import '../../domain/entity/updatedata/update_data_response.dart';
import '../../misc/response_wrapper.dart';

extension SourceEntityMapping on ResponseWrapper {
  LoginResponse mapFromResponseToLoginResponse() {
    return LoginResponse(
      user: ResponseWrapper(response["user"]).mapFromResponseToUser(),
      authorization: ResponseWrapper(response["authorisation"]).mapFromResponseToAuthorization()
    );
  }

  GetMarketingListResponse mapFromResponseToGetMarketingListResponse() {
    return GetMarketingListResponse();
  }

  GetCustomerPagingResponse mapFromResponseToGetCustomerListResponse() {
    return GetCustomerPagingResponse(
      customerPagingDataResult: ResponseWrapper(response).mapFromResponseToPagingDataResult<Customer>(
        (dataResponse) => dataResponse.map<Customer>(
          (articleResponse) => ResponseWrapper(articleResponse).mapFromResponseToCustomer()
        ).toList()
      )
    );
  }

  GetModificationListResponse mapFromResponseToGetModificationListResponse() {
    return GetModificationListResponse();
  }

  GetSchemeListResponse mapFromResponseToGetSchemeListResponse() {
    return GetSchemeListResponse();
  }

  GetPaymentListResponse mapFromResponseToGetPaymentListResponse() {
    return GetPaymentListResponse();
  }

  GetHouseListResponse mapFromResponseToGetHouseListResponse() {
    return GetHouseListResponse(
      housePagingDataResult: ResponseWrapper(response).mapFromResponseToPagingDataResult<House>(
        (dataResponse) => dataResponse.map<House>(
          (articleResponse) => ResponseWrapper(articleResponse).mapFromResponseToHouse()
        ).toList()
      )
    );
  }

  GetMyDataResponse mapFromResponseToGetMyDataResponse() {
    return GetMyDataResponse(
      customer: ResponseWrapper(response["data"]).mapFromResponseToCustomer()
    );
  }

  GetMyBillResponse mapFromResponseToGetMyBillResponse() {
    return GetMyBillResponse(
      billPagingDataResult: ResponseWrapper(response).mapFromResponseToPagingDataResult<Bill>(
        (dataResponse) => dataResponse.map<Bill>(
          (articleResponse) => ResponseWrapper(articleResponse).mapFromResponseToBill()
        ).toList()
      )
    );
  }

  UpdateDataResponse mapFromResponseToUpdateDataResponse() {
    return UpdateDataResponse();
  }

  GetCustomerBasedMarketingIdPagingResponse mapFromResponseToGetCustomerBasedMarketingIdListResponse() {
    return GetCustomerBasedMarketingIdPagingResponse(
      customerPagingDataResult: ResponseWrapper(response).mapFromResponseToPagingDataResult<Customer>(
        (dataResponse) => dataResponse.map<Customer>(
          (articleResponse) => ResponseWrapper(articleResponse).mapFromResponseToCustomer()
        ).toList()
      )
    );
  }

  NewCustomerResponse mapFromResponseToNewCustomerResponse() {
    return NewCustomerResponse();
  }
}