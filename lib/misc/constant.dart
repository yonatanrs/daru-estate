import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'color_helper.dart';

class _ConstantImpl {
  String get restorableRouteFuturePush => "restorable-route-future-push";
  String get restorableRouteFuturePushAndRemoveUntil => "restorable-route-future-and-remove-until";

  String get imageDaruEstate => "assets/images/logo_daru_estate.png";
  String get imageSuccess => "assets/images/success.png";
  String get imageFailed => "assets/images/failed.png";
  String get imageNoInternet => imageFailed;
  String get forgotPassword => "assets/images/forget_password.png";

  Color get colorYellow => const Color.fromRGBO(244, 184, 43, 1);
  Color get colorRed => const Color.fromRGBO(255, 86, 76, 1);
  Color get colorRedDanger => const Color.fromRGBO(203, 58, 49, 1);
  Color get colorGrey => const Color.fromRGBO(174, 174, 174, 1);
  Color get colorGrey2 => const Color.fromRGBO(213, 213, 213, 1);
  Color get colorSurfaceGrey => const Color.fromRGBO(247, 247, 247, 1);
  Color get colorDarkGrey => const Color.fromRGBO(105, 105, 105, 1);
  Color get colorBrown => const Color.fromRGBO(191, 105, 25, 1);
  Color get colorSuccessGreen => const Color.fromRGBO(67, 147, 108, 1);
  Color get colorDarkBlack => const Color.fromRGBO(57, 57, 57, 1);
  Color get colorSurfaceBlue => const Color.fromRGBO(209, 233, 238, 1);

  Color get colorMain => ColorHelper.fromHex("1E90FF");
  Color get colorDarkMain => colorMain;
  Color get colorNonActiveDotIndicator => colorSurfaceBlue;
  Color get colorDivider => colorGrey2;
  Color get colorBottomNavigationBarIconAndLabel => colorGrey2;
  Color get colorSpacingListItem => const Color.fromRGBO(245, 245, 245, 1);
  Color get colorTitleUserDetail => const Color.fromRGBO(142, 142, 142, 1);
  Color get colorProductItemDiscountOrNormal => const Color.fromRGBO(142, 142, 142, 1);
  Color get colorProductItemBorder => const Color.fromRGBO(201, 201, 201, 1);
  Color get colorProductItemSold => colorGrey;
  Color get colorProductItemReview => colorGrey;
  Color colorTrainingPreEmploymentChip(BuildContext context) => Theme.of(context).colorScheme.primary;
  Color get colorDefaultChip => const Color.fromRGBO(201, 201, 201, 1);
  Color get colorTitle => colorDarkBlack;
  Color get colorHyperlink => const Color.fromRGBO(50, 103, 227, 1);
  Color get colorTextFieldBorder => const Color.fromRGBO(220, 220, 220, 1);
  Color get colorPasswordObscurer => const Color.fromRGBO(41, 45, 50, 1);
  Color get colorPlaceholder => const Color.fromRGBO(201, 201, 201, 1);
  Color get colorBaseShimmer => const Color.fromRGBO(201, 201, 201, 1);
  Color get colorHighlightShimmer => const Color.fromRGBO(142, 142, 142, 1);
  Color get colorTabUnselected => colorGrey;
  Color get colorBarBackground => const Color.fromRGBO(244, 244, 244, 1);
  Color get colorFeedbackDateText => colorGrey;
  Color get colorLike => colorRed;
  Color get colorDiscount => colorBrown;
  Color get colorSelectedFilterButton => colorSurfaceBlue;

  double get heightSpacingListItem => (1.5).h;
  double get paddingListItem => 4.w;
  double get spacingListItem => 2.w;
  double get iconSpacing => 7.w;
  BorderRadius get inputBorderRadius => BorderRadius.circular(16.0);
  double get inputBorderWidth => 1.5;
  int get dummyLoadingTimeInSeconds => 1;
  double get bannerMarginTopHeight => 130.0;
  double get bannerIndicatorAreaHeight => 40.0;

  String get settingHiveTable => 'setting_hive_table';
  String get settingHiveTableKey => 'setting_hive_table_key';
  String get textIdKey => 'id';
  String get textTypeKey => 'type';
  String get textUrlKey => 'url';
  String get textEncodedUrlKey => 'encoded-url';
  String get textEmpty => "(${"Empty".tr})";
  String get textLoading => "Loading".tr;
  String get textEnUsLanguageKey => "en_US";
  String get textInIdLanguageKey => "in_ID";
}

// ignore: non_constant_identifier_names
final Constant = _ConstantImpl();