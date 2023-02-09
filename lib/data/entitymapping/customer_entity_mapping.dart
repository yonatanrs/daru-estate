import 'package:daru_estate/data/entitymapping/installment_status_entity_mapping.dart';
import 'package:daru_estate/data/entitymapping/user_entity_mapping.dart';
import 'package:daru_estate/misc/ext/response_wrapper_ext.dart';
import 'package:daru_estate/misc/ext/string_ext.dart';

import '../../domain/entity/customer/customer.dart';
import '../../misc/response_wrapper.dart';

extension CustomerEntityMapping on ResponseWrapper {
  Customer mapFromResponseToCustomer() {
    if (response.containsKey("user")) {
      return CustomerWithLoggedUser(
        id: response["id"].toString(),
        userId: response["userId"],
        loggedUser: ResponseWrapper(response["user"]).mapFromResponseToUser(),
        marketingId: response["marketingId"],
        houseId: response["houseId"],
        terminId: response["terminId"],
        name: response["name"],
        birthdate: response["birthdate"],
        birthplace: response["birthplace"],
        nik: response["nik"],
        email: response["email"],
        phone: response["phone"],
        address: response["address"],
        postalCode: response["postalCode"],
        province: response["province"],
        city: response["city"],
        subDistrict: response["subDistrict"],
        village: response["village"],
        bookingFeeDate: ResponseWrapper(response["bookingFeeDate"]).mapFromResponseToDateTime()!,
        bookingFeePicture: response["bookingFeePicture"].toString().toEmptyStringNonNull,
        status: ResponseWrapper(response["status"]).mapFromResponseToInstallmentStatus()
      );
    } else {
      return Customer(
        id: response["id"].toString(),
        userId: response["userId"],
        marketingId: response["marketingId"],
        houseId: response["houseId"],
        terminId: response["terminId"],
        name: response["name"],
        birthdate: response["birthdate"],
        birthplace: response["birthplace"],
        nik: response["nik"],
        email: response["email"],
        phone: response["phone"],
        address: response["address"],
        postalCode: response["postalCode"],
        province: response["province"],
        city: response["city"],
        subDistrict: response["subDistrict"],
        village: response["village"],
        bookingFeeDate: ResponseWrapper(response["bookingFeeDate"]).mapFromResponseToDateTime()!,
        bookingFeePicture: response["bookingFeePicture"].toString().toEmptyStringNonNull,
        status: ResponseWrapper(response["status"]).mapFromResponseToInstallmentStatus()
      );
    }
  }
}