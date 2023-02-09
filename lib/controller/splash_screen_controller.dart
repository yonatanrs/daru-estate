import 'package:flutter/material.dart';

import '../misc/login_helper.dart';
import '../misc/manager/controller_manager.dart';
import '../misc/page_restoration_helper.dart';
import 'base_getx_controller.dart';

class SplashScreenController extends BaseGetxController {
  bool _isStartNextPage = false;

  SplashScreenController(ControllerManager? controllerManager) : super(controllerManager);

  void startIntroductionPage({
    required VoidCallback onStartHomePage,
    required VoidCallback onStartCustomerPage,
    required VoidCallback onStartMarketingPage
  }) async {
    if (_isStartNextPage) {
      return;
    }
    _isStartNextPage = true;
    await Future.delayed(const Duration(seconds: 3));
    if (LoginHelper.getTokenWithBearer().result.isEmpty) {
      onStartHomePage();
    } else {
      if (LoginHelper.getCustomerId().result != "0") {
        onStartCustomerPage();
      } else if (LoginHelper.getMarketingId().result != "0") {
        onStartMarketingPage();
      }
    }
  }
}