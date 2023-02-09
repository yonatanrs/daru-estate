import 'package:daru_estate/misc/ext/response_wrapper_ext.dart';

import '../../domain/entity/house/house.dart';
import '../../misc/response_wrapper.dart';

extension HouseEntityMapping on ResponseWrapper {
  House mapFromResponseToHouse() {
    return House(
      id: response['id'].toString(),
      typeName: response['typeName'],
      housePic: response['housePic'],
      cashPrice: double.parse(response['cashPrice']),
      landArea: double.parse(response['landArea']),
      buildingArea: double.parse(response['buildingArea']),
      storeyNumber: int.parse(response['storeyNumber']),
      stock: int.parse(response['stock']),
      lastStockUpdate: ResponseWrapper(response['lastStockUpdate']).mapFromResponseToDateTime()!
    );
  }
}