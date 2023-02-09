import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../presentation/widget/material_ignore_pointer.dart';
import '../getextended/extended_get_modal_bottom_sheet_route.dart';

extension ModifiedExtensionBottomSheet on GetInterface {
  Future<T?> bottomSheetOriginalMethod<T>(
    BuildContext context,
    Widget bottomsheet, {
      Color? backgroundColor,
      double? elevation,
      bool persistent = true,
      ShapeBorder? shape,
      Clip? clipBehavior,
      Color? barrierColor,
      bool? ignoreSafeArea,
      bool isScrollControlled = false,
      bool useRootNavigator = false,
      bool isDismissible = true,
      bool enableDrag = true,
      RouteSettings? settings,
      Duration? enterBottomSheetDuration,
      Duration? exitBottomSheetDuration,
  }) {
    Completer<T?> pushResultCompleter = Completer();
    MaterialIgnorePointer.of(context)?.ignoring = true;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      GetModalBottomSheetRoute<T> getModalBottomSheetRoute = ExtendedGetModalBottomSheetRoute<T>(
        builder: (_) => bottomsheet,
        isPersistent: persistent,
        theme: Theme.of(key.currentContext!),
        isScrollControlled: isScrollControlled,
        barrierLabel: MaterialLocalizations.of(key.currentContext!).modalBarrierDismissLabel,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        removeTop: ignoreSafeArea ?? true,
        clipBehavior: clipBehavior,
        isDismissible: isDismissible,
        modalBarrierColor: barrierColor,
        settings: settings,
        enableDrag: enableDrag,
        enterBottomSheetDuration: enterBottomSheetDuration ?? const Duration(milliseconds: 250),
        exitBottomSheetDuration: exitBottomSheetDuration ?? const Duration(milliseconds: 200),
      );
      Future<T?> pushResult = Navigator.of(overlayContext!, rootNavigator: useRootNavigator).push(getModalBottomSheetRoute);
      pushResultCompleter.complete(pushResult);
    });
    return pushResultCompleter.future;
  }
}