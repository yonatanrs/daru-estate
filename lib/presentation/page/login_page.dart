import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daru_estate/misc/ext/validation_result_ext.dart';
import 'package:sizer/sizer.dart';

import '../../controller/login_controller.dart';
import '../../domain/entity/user/customer_user.dart';
import '../../domain/entity/user/marketing_user.dart';
import '../../domain/entity/user/user.dart';
import '../../domain/repository/source_repository.dart';
import '../../misc/constant.dart';
import '../../misc/controllerstate/obscure_password_text_field_controller_state.dart';
import '../../misc/controllerstate/text_field_controller_state.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/inputdecoration/default_input_decoration.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/page_restoration_helper.dart';
import '../widget/app_logo.dart';
import '../widget/field.dart';
import '../widget/modified_text_field.dart';
import '../widget/password_obscurer.dart';
import '../widget/rx_consumer.dart';
import 'customer_page.dart';
import 'getx_page.dart';
import 'marketing_page.dart';

class LoginPage extends RestorableGetxPage<_LoginPageRestoration> {
  late final ControllerMember<LoginController> _loginController = ControllerMember<LoginController>().addToControllerManager(controllerManager);

  LoginPage({Key? key}) : super(key: key, pageRestorationId: () => "login-page");

  @override
  void onSetController() {
    _loginController.controller = GetExtended.put<LoginController>(
      LoginController(controllerManager, Injector.locator<SourceRepository>()),
      tag: pageName
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageRestoration createPageRestoration() => _LoginPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    // ignore: prefer_function_declarations_over_variables
    VoidCallback beginLogin = () => _loginController.controller.login(
      onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
      onShowLoginRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
      onLoginRequestProcessSuccessCallback: (loginResponse) async {
        User user = loginResponse.user;
        if (user is MarketingUser) {
          PageRestorationHelper.toMarketingPage(context);
        } else if (user is CustomerUser) {
          PageRestorationHelper.toCustomerPage(context);
        }
      },
      onShowLoginRequestProcessFailedCallback: (e) => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
        context: context,
        errorProvider: Injector.locator<ErrorProvider>(),
        e: e
      )
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLogo(),
                SizedBox(height: 3.h),
                RxConsumer<TextFieldControllerState>(
                  rxValue: _loginController.controller.emailTextFieldControllerStateRx,
                  onConsumeValue: (context, value) => Field(
                    child: (context, validationResult, validator) => ModifiedTextField(
                      isError: validationResult.isFailed,
                      controller: value.textEditingController,
                      decoration: DefaultInputDecoration(hintText: "Email".tr),
                      onChanged: (value) => validator?.validate(),
                      textInputAction: TextInputAction.next,
                    ),
                    validator: value.validator,
                  ),
                ),
                SizedBox(height: 3.h),
                RxConsumer<ObscurePasswordTextFieldControllerState>(
                  rxValue: _loginController.controller.passwordTextFieldControllerStateRx,
                  onConsumeValue: (context, value) => Field(
                    child: (context, validationResult, validator) => ModifiedTextField(
                      isError: validationResult.isFailed,
                      controller: value.textEditingController,
                      decoration: DefaultInputDecoration(
                        hintText: "Password".tr,
                        suffixIcon: PasswordObscurer(
                          obscurePassword: value.obscurePassword,
                          onObscurePassword: () => _loginController.controller.obscurePassword(),
                        )
                      ),
                      obscureText: value.obscurePassword,
                      onChanged: (value) => validator?.validate(),
                      textInputAction: TextInputAction.done,
                      onEditingComplete: beginLogin
                    ),
                    validator: value.validator,
                  )
                ),
                SizedBox(height: 3.h),
                SizedBox(
                  width: double.infinity,
                  height: 5.h,
                  child: TextButton(
                    onPressed: beginLogin,
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text("Login".tr),
                  )
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}

class _LoginPageRestoration extends MixableGetxPageRestoration with MarketingPageRestorationMixin, CustomerPageRestorationMixin {
  @override
  // ignore: unnecessary_overrides
  void initState() {
    super.initState();
  }

  @override
  // ignore: unnecessary_overrides
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  // ignore: unnecessary_overrides
  void dispose() {
    super.dispose();
  }
}

class LoginPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => LoginPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(LoginPage()));
}

mixin LoginPageRestorationMixin on MixableGetxPageRestoration {
  late LoginPageRestorableRouteFuture loginPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    loginPageRestorableRouteFuture = LoginPageRestorableRouteFuture(restorationId: restorationIdWithPageName('login-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    loginPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    loginPageRestorableRouteFuture.dispose();
  }
}

class LoginPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  LoginPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        if (arguments is String) {
          if (arguments == Constant.restorableRouteFuturePushAndRemoveUntil) {
            return navigator.restorablePushAndRemoveUntil(_pageRouteBuilder, (route) => false, arguments: arguments);
          } else {
            return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
          }
        } else {
          return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
        }
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<void>(GetxPageBuilder.buildRestorableGetxPageBuilder(LoginPageGetPageBuilderAssistant()));
  }

  static Route<void> _pageRouteBuilder(BuildContext context, Object? arguments) {
    return _getRoute(arguments)!;
  }

  @override
  bool checkBeforePresent([Object? arguments]) => _getRoute(arguments) != null;

  @override
  void presentIfCheckIsPassed([Object? arguments]) => _pageRoute.present(arguments);

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    restorator.registerForRestoration(_pageRoute, restorationId);
  }

  @override
  void dispose() {
    _pageRoute.dispose();
  }
}