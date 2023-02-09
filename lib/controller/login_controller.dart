import 'dart:ui';

import 'package:daru_estate/misc/ext/load_data_result_ext.dart';
import 'package:daru_estate/misc/ext/rx_ext.dart';
import 'package:daru_estate/misc/ext/string_ext.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../domain/entity/login/login_parameter.dart';
import '../domain/entity/login/login_response.dart';
import '../domain/entity/user/customer_user.dart';
import '../domain/entity/user/marketing_user.dart';
import '../domain/entity/user/user.dart';
import '../domain/repository/source_repository.dart';
import '../misc/controllerstate/obscure_password_text_field_controller_state.dart';
import '../misc/controllerstate/text_field_controller_state.dart';
import '../misc/error/validation_error.dart';
import '../misc/load_data_result.dart';
import '../misc/login_helper.dart';
import '../misc/manager/controller_manager.dart';
import '../misc/typedef.dart';
import '../misc/validation/validation_result.dart';
import '../misc/validation/validator/email_validator.dart';
import '../misc/validation/validator/validator.dart';
import '../misc/validation/validatorgroup/login_validator_group.dart';
import 'base_getx_controller.dart';

typedef _OnShowLoginRequestProcessLoadingCallback = Future<void> Function();
typedef _OnLoginRequestProcessSuccessCallback = Future<void> Function(LoginResponse loginResponse);
typedef _OnShowLoginRequestProcessFailedCallback = Future<void> Function(dynamic e);

class LoginController extends BaseGetxController {
  final SourceRepository sourceRepository;

  final TextEditingController _emailTextEditingController = TextEditingController();
  late Rx<TextFieldControllerState> emailTextFieldControllerStateRx;
  final TextEditingController _passwordTextEditingController = TextEditingController();
  late Rx<ObscurePasswordTextFieldControllerState> passwordTextFieldControllerStateRx;
  final TapGestureRecognizer _forgotPasswordTapGestureRecognizer = TapGestureRecognizer();
  late Rx<TapGestureRecognizer> forgotPasswordTapGestureRecognizerRx;
  final TapGestureRecognizer _signUpTapGestureRecognizer = TapGestureRecognizer();
  late Rx<TapGestureRecognizer> signUpTapGestureRecognizerRx;
  late final LoginValidatorGroup loginValidatorGroup;

  LoginController(ControllerManager? controllerManager, this.sourceRepository) : super(controllerManager) {
    loginValidatorGroup = LoginValidatorGroup(
      emailValidator: EmailValidator(
        email: () => _emailTextEditingController.text
      ),
      passwordValidator: Validator(
        onValidate: () => !_passwordTextEditingController.text.isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Password is required".tr}."))
      )
    );
    emailTextFieldControllerStateRx = TextFieldControllerState(
      textEditingController: _emailTextEditingController,
      validator: loginValidatorGroup.emailValidator
    ).obs;
    passwordTextFieldControllerStateRx = ObscurePasswordTextFieldControllerState(
      textEditingController: _passwordTextEditingController,
      validator: loginValidatorGroup.passwordValidator,
      obscurePassword: true
    ).obs;
    forgotPasswordTapGestureRecognizerRx = _forgotPasswordTapGestureRecognizer.obs;
    signUpTapGestureRecognizerRx = _signUpTapGestureRecognizer.obs;
  }

  void obscurePassword() {
    passwordTextFieldControllerStateRx.valueFromLast((value) => value.copy(obscurePassword: !value.obscurePassword));
    update();
  }

  void login({
    required OnUnfocusAllWidget onUnfocusAllWidget,
    // ignore: library_private_types_in_public_api
    required _OnShowLoginRequestProcessLoadingCallback onShowLoginRequestProcessLoadingCallback,
    // ignore: library_private_types_in_public_api
    required _OnLoginRequestProcessSuccessCallback onLoginRequestProcessSuccessCallback,
    // ignore: library_private_types_in_public_api
    required _OnShowLoginRequestProcessFailedCallback onShowLoginRequestProcessFailedCallback
  }) async {
    onUnfocusAllWidget();
    if (loginValidatorGroup.validate()) {
      onShowLoginRequestProcessLoadingCallback();
      LoadDataResult<LoginResponse> loginLoadDataResult = await sourceRepository.login(
        LoginParameter(
          email: _emailTextEditingController.text,
          password: _passwordTextEditingController.text
        )
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('login').value
      );
      Get.back();
      if (loginLoadDataResult.isSuccess) {
        User user = loginLoadDataResult.resultIfSuccess!.user;
        await LoginHelper.saveToken(
          loginLoadDataResult.resultIfSuccess!.authorization.token,
          otherParameter: <String, dynamic>{
            "customer_id": user is CustomerUser ? user.customerId : "0",
            "marketing_id": user is MarketingUser ? user.marketingId : "0",
          }
        ).future();
        onLoginRequestProcessSuccessCallback(loginLoadDataResult.resultIfSuccess!);
      } else {
        onShowLoginRequestProcessFailedCallback(loginLoadDataResult.resultIfFailed);
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _forgotPasswordTapGestureRecognizer.dispose();
    _signUpTapGestureRecognizer.dispose();
  }
}