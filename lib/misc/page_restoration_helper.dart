import 'package:flutter/material.dart';

import '../presentation/page/crop_picture_page.dart';
import '../presentation/page/customer_page.dart';
import '../presentation/page/getx_page.dart';
import '../presentation/page/login_page.dart';
import '../presentation/page/marketing_add_customer_page.dart';
import '../presentation/page/marketing_customer_detail_page.dart';
import '../presentation/page/marketing_page.dart';
import '../presentation/page/select_house_page.dart';
import 'constant.dart';

class _PageRestorationHelperImpl {
  bool _checkingPageRestorationMixin<T extends GetxPageRestoration>({
    required Widget checkingWidget,
    required void Function(T) onGetxPageRestorationFound,
    required BuildContext context
  }) {
    if (checkingWidget is RestorableGetxPage) {
      RestorableGetxPage widget = checkingWidget;
      GetxPageRestoration restoration = widget.getPageRestoration(context);
      if (restoration is T) {
        onGetxPageRestorationFound(restoration);
        return false;
      }
      return true;
    }
    return true;
  }

  void findPageRestorationMixin<T extends GetxPageRestoration>({
    required void Function(T) onGetxPageRestorationFound,
    required BuildContext context
  }) {
    if (_checkingPageRestorationMixin(checkingWidget: context.widget, onGetxPageRestorationFound: onGetxPageRestorationFound, context: context)) {
      context.visitAncestorElements((element) {
        return _checkingPageRestorationMixin(checkingWidget: element.widget, onGetxPageRestorationFound: onGetxPageRestorationFound, context: context);
      });
    }
  }

  void toMarketingPage(BuildContext context) {
    PageRestorationHelper.findPageRestorationMixin<MarketingPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.marketingPageRestorableRouteFuture.present(Constant.restorableRouteFuturePushAndRemoveUntil);
      },
      context: context
    );
  }

  void toMarketingCustomerDetailPage(BuildContext context, String customerId) {
    PageRestorationHelper.findPageRestorationMixin<MarketingCustomerDetailPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.marketingCustomerDetailPageRestorableRouteFuture.present();
      },
      context: context
    );
  }

  void toMarketingAddCustomerPage(BuildContext context) {
    PageRestorationHelper.findPageRestorationMixin<MarketingAddCustomerPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.marketingAddCustomerPageRestorableRouteFuture.present();
      },
      context: context
    );
  }

  void toCustomerPage(BuildContext context) {
    PageRestorationHelper.findPageRestorationMixin<CustomerPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.customerPageRestorableRouteFuture.present(Constant.restorableRouteFuturePushAndRemoveUntil);
      },
      context: context
    );
  }

  void toCropPicturePage(BuildContext context, String picturePath) {
    PageRestorationHelper.findPageRestorationMixin<CropPicturePageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.cropPicturePageRestorableRouteFuture.present(picturePath);
      },
      context: context
    );
  }

  void toSelectHousePage(BuildContext context, String? selectedHouseJsonString) {
    PageRestorationHelper.findPageRestorationMixin<SelectHousePageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.selectHousePageRestorableRouteFuture.present(selectedHouseJsonString);
      },
      context: context
    );
  }

  void toLoginPage(BuildContext context) {
    PageRestorationHelper.findPageRestorationMixin<LoginPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.loginPageRestorableRouteFuture.present(Constant.restorableRouteFuturePushAndRemoveUntil);
      },
      context: context
    );
  }
}

// ignore: non_constant_identifier_names
final PageRestorationHelper = _PageRestorationHelperImpl();