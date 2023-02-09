import 'package:flutter/material.dart';
import 'package:daru_estate/misc/aspect_ratio_value.dart';

import '../controller/base_getx_controller.dart';
import 'validation/validation_result.dart';
import 'validation/validator/validator.dart';

typedef OnUnfocusAllWidget = void Function();
typedef DummyInitiator<T> = T Function();
typedef WidgetBuilderWithRx<T> = Widget Function(BuildContext, T);
typedef WidgetBuilderWithError = Widget Function(BuildContext, dynamic);
typedef WidgetBuilderWithValidator<T extends Validator> = Widget Function(BuildContext, T);
typedef WidgetBuilderWithValidatorResult = Widget Function(BuildContext, ValidationResult, Validator?);
typedef WidgetBuilderWithItem<T> = Widget Function(BuildContext, T);
typedef TypeCallback<T> = void Function(T);
typedef AspectRatioWithPreviousValue = AspectRatioValue? Function(AspectRatioValue previousAspectRatio);
typedef DoubleReturned = double Function();
typedef SizeCallback = void Function(Size);
typedef GetControllerFromGetPut = BaseGetxController Function();
typedef VoidCallbackWithBuildContextParameter = void Function(BuildContext);
typedef OnShowProcessCancelTransactionRequestProcessLoadingCallback = Future<void> Function();
typedef OnShowProcessCancelTransactionRequestProcessFailedCallback = Future<void> Function(dynamic e);