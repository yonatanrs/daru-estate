import 'package:daru_estate/misc/ext/response_wrapper_ext.dart';

import '../../domain/entity/mybill/bill.dart';
import '../../misc/response_wrapper.dart';

extension CustomerEntityMapping on ResponseWrapper {
  Bill mapFromResponseToBill() {
    return Bill(
      id: response["id"].toString(),
      customerId: response["customerId"],
      terminId: response["terminId"],
      houseType: response["houseType"],
      schemeDate: ResponseWrapper(response["schemeDate"]).mapFromResponseToDateTime()!,
      schemeName: response["schemeName"],
      schemeNominal: response["schemeNominal"],
      status: response["status"],
      paymentId: response["paymentId"],
      paidDate: response["paidDate"],
    );
  }
}