import 'dart:convert';

import 'package:daru_estate/misc/ext/future_ext.dart';
import 'package:daru_estate/misc/ext/string_ext.dart';

import 'constant.dart';
import 'load_data_result.dart';
import 'processing/default_processing.dart';
import 'processing/future_processing.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class _LoginHelperImpl {
  FutureProcessing<LoadDataResult<void>> saveToken(String tokenWithoutBearer);
  DefaultProcessing<String> getTokenWithBearer();
  FutureProcessing<LoadDataResult<void>> deleteToken();
}

class _DefaultLoginHelperImpl implements _LoginHelperImpl {
  final String _keyword = 'Bearer';

  Map<String, dynamic>? _getTokenDataMap() {
    var box = Hive.box(Constant.settingHiveTable);
    String? parameter = box.get(Constant.settingHiveTableKey);
    if (!parameter.isEmptyString) {
      dynamic encodedParameter = json.decode(parameter!);
      return encodedParameter;
    }
    return null;
  }

  @override
  FutureProcessing<LoadDataResult<void>> saveToken(String tokenWithoutBearer, {Map<String, dynamic> otherParameter = const {}}) {
    return FutureProcessing(({parameter}) {
      Map<String, dynamic> parameter = <String, dynamic>{
        "token": '$_keyword $tokenWithoutBearer',
        if (otherParameter.isNotEmpty) "other_parameter": otherParameter
      };
      var box = Hive.box(Constant.settingHiveTable);
      print(parameter);
      return box.put(Constant.settingHiveTableKey, json.encode(parameter)).getLoadDataResult();
    });
  }

  @override
  DefaultProcessing<String> getTokenWithBearer() {
    try {
      Map<String, dynamic>? result = _getTokenDataMap();
      if (result != null) {
        if (result.containsKey("token")) {
          return DefaultProcessing(result["token"]);
        }
      }
      return DefaultProcessing('');
    } catch (e) {
      return DefaultProcessing('');
    }
  }

  @override
  FutureProcessing<LoadDataResult<void>> deleteToken() {
    return FutureProcessing(({parameter}) {
      var box = Hive.box(Constant.settingHiveTable);
      return box.delete(Constant.settingHiveTableKey).getLoadDataResult();
    });
  }
}

// ignore: non_constant_identifier_names
final LoginHelper = _DefaultLoginHelperImpl();

// ignore: library_private_types_in_public_api
extension DefaultLoginHelperImplExt on _DefaultLoginHelperImpl {
  DefaultProcessing<String> getCustomerId() {
    try {
      Map<String, dynamic>? result = _getTokenDataMap();
      if (result != null) {
        if (result.containsKey("other_parameter")) {
          if (result["other_parameter"].containsKey("customer_id")) {
            return DefaultProcessing(result["other_parameter"]["customer_id"]);
          }
        }
      }
      return DefaultProcessing('');
    } catch (e) {
      return DefaultProcessing('');
    }
  }

  DefaultProcessing<String> getMarketingId() {
    try {
      Map<String, dynamic>? result = _getTokenDataMap();
      if (result != null) {
        if (result.containsKey("other_parameter")) {
          if (result["other_parameter"].containsKey("marketing_id")) {
            return DefaultProcessing(result["other_parameter"]["marketing_id"]);
          }
        }
      }
      return DefaultProcessing('');
    } catch (e) {
      return DefaultProcessing('');
    }
  }
}