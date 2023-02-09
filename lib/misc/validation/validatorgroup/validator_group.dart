import 'package:daru_estate/misc/ext/validation_result_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../validation_result.dart';
import '../validator/validator.dart';

abstract class ValidatorGroup {
  @protected
  List<Validator> validatorList = <Validator>[];

  bool validate() {
    int failedCount = 0;
    for (var validator in validatorList) {
      if (validator.validate() is FailedValidationResult) {
        failedCount += 1;
        if (kDebugMode) {
          print(validator.validationResult.resultIfFailed);
        }
      }
    }
    return failedCount == 0;
  }

  void dispose() {
    validatorList.clear();
  }
}