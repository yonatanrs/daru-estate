import 'package:daru_estate/presentation/page/customer_page.dart';
import 'package:daru_estate/presentation/page/marketing_page.dart';
import 'package:flutter/material.dart';

import '../../controller/splash_screen_controller.dart';
import '../../misc/constant.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/page_restoration_helper.dart';
import '../widget/app_logo.dart';
import 'getx_page.dart';
import 'login_page.dart';

class SplashScreenPage extends RestorableGetxPage<_SplashScreenPageRestoration> {
  late final ControllerMember<SplashScreenController> _splashScreenController = ControllerMember<SplashScreenController>().addToControllerManager(controllerManager);

  SplashScreenPage({Key? key}) : super(key: key, pageRestorationId: () => "login-page");

  @override
  void onSetController() {
    _splashScreenController.controller = GetExtended.put<SplashScreenController>(
      SplashScreenController(
        controllerManager,
      ),
      tag: pageName
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    _splashScreenController.controller.startIntroductionPage(
      onStartHomePage: () => PageRestorationHelper.toLoginPage(context),
      onStartCustomerPage: () => PageRestorationHelper.toCustomerPage(context),
      onStartMarketingPage: () => PageRestorationHelper.toMarketingPage(context),
    );
    return Scaffold(
      appBar: null,
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [AppLogo()]
            )
          )
        )
      )
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenPageRestoration createPageRestoration() => _SplashScreenPageRestoration();
}

class _SplashScreenPageRestoration extends MixableGetxPageRestoration with LoginPageRestorationMixin, MarketingPageRestorationMixin, CustomerPageRestorationMixin {

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