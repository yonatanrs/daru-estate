import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:daru_estate/misc/ext/string_ext.dart';
import 'package:daru_estate/misc/getextended/get_extended.dart';
import 'package:daru_estate/presentation/widget/something_counter.dart';

import '../../misc/main_route_observer.dart';
import '../../misc/manager/controller_manager.dart';

typedef OnCreateRestorationCallback<T extends GetxPageRestoration> = T Function();
typedef PageRestorationStringId = String Function();

abstract class GetPageBuilderAssistant {
  GetPageBuilder get pageBuilder;
  GetPageBuilder get pageWithOuterGetxBuilder;
}

class _GetxPageName {
  String pageName;

  _GetxPageName({
    required this.pageName
  });
}

class _GetxPageBuilder {
  Widget buildRestorableGetxPage<T extends GetxPageRestoration>(RestorableGetxPage<T> restorableGetxPage) {
    Widget resultPage = restorableGetxPage;
    if (resultPage is RestorableGetxPage<T>) {
      resultPage = _RestorableGetxOuterPage<T>(
        onDispose: resultPage.dispose,
        pageRestorationId: resultPage.pageRestorationId,
        onCreateRestoration: resultPage.createPageRestoration,
        child: restorableGetxPage,
      );
    }
    return resultPage;
  }

  GetPageBuilderWithPageName buildRestorableGetxPageBuilder<T extends GetxPageRestoration>(GetPageBuilderAssistant restorableGetPageBuilderAssistant) {
    Widget tempRestorableGetxPage = restorableGetPageBuilderAssistant.pageBuilder();
    if (tempRestorableGetxPage is! RestorableGetxPage<T>) {
      throw FlutterError("pageBuilder must return RestorableGetxPage.");
    }
    Widget tempOuterRestorableGetxPage = restorableGetPageBuilderAssistant.pageWithOuterGetxBuilder();
    if (tempOuterRestorableGetxPage is! _RestorableGetxOuterPage) {
      throw FlutterError("pageWithOuterGetxBuilder must return _RestorableGetxOuterPage. To resolve this, use GetxPageBuilder.buildRestorableGetxPage method");
    }
    String newRestorationIdName = _createNewRestorationIdName("/${tempRestorableGetxPage.runtimeType.toString()}");
    String sanitizedNewRestorationIdName = GetExtended.sanitizeNewRestorationIdName(newRestorationIdName);
    String pageName = sanitizedNewRestorationIdName;
    return GetPageBuilderWithPageName(
      builder: restorableGetPageBuilderAssistant.pageWithOuterGetxBuilder,
      pageName: pageName
    );
  }

  Widget buildDefaultGetxPage(DefaultGetxPage defaultGetxPage) {
    Widget resultPage = defaultGetxPage;
    if (resultPage is DefaultGetxPage) {
      resultPage = _GetxOuterPage(
        onDispose: resultPage.dispose,
        child: defaultGetxPage,
      );
    }
    return resultPage;
  }

  GetPageBuilderWithPageName buildDefaultGetxPageBuilder(GetPageBuilderAssistant restorableGetPageBuilderAssistant) {
    Widget tempDefaultGetxPage = restorableGetPageBuilderAssistant.pageBuilder();
    if (tempDefaultGetxPage is! DefaultGetxPage) {
      throw FlutterError("pageBuilder must return DefaultGetxPage.");
    }
    if (restorableGetPageBuilderAssistant.pageWithOuterGetxBuilder() is! _GetxOuterPage) {
      throw FlutterError("pageWithOuterGetxBuilder must return _GetxOuterPage. To resolve this, use GetxPageBuilder.buildDefaultGetxPage method");
    }
    return GetPageBuilderWithPageName(
      builder: restorableGetPageBuilderAssistant.pageWithOuterGetxBuilder,
      pageName: tempDefaultGetxPage.runtimeType.toString()
    );
  }

  String _createNewRestorationIdName(String routeName) {
    String rawRouteName = GetExtended.cleanRouteName(routeName);
    String rawRouteNameDuplicateNumber = "";
    String newRawRouteName = "";
    int step = 1;
    for (int i = rawRouteName.length - 1; i >= 0; i--) {
      String c = rawRouteName[i];
      if (step == 1) {
        if (c == '-') {
          step += 1;
        } else {
          rawRouteNameDuplicateNumber = c + rawRouteNameDuplicateNumber;
        }
      } else if (step == 2) {
        step += 1;
      } else if (step == 3) {
        newRawRouteName = c + newRawRouteName;
      }
    }
    newRawRouteName = newRawRouteName.isEmptyString ? rawRouteName : newRawRouteName;
    String newRouteName = newRawRouteName;
    int i = 1;
    while (true) {
      if (MainRouteObserver.checkRouteNameExists(newRouteName)) {
        if (MainRouteObserver.routeMap[newRouteName] != null) {
          if (MainRouteObserver.routeMap[newRouteName]?.restorationValue == 1) {
            MainRouteObserver.routeMap[newRouteName]?.restorationValue = 0;
          } else {
            newRouteName = "$newRawRouteName-$i";
            i++;
            continue;
          }
        }
      }
      break;
    }
    //print("New ROUTE NAME: $newRouteName");
    return newRouteName;
  }
}

// ignore: non_constant_identifier_names
final GetxPageBuilder = _GetxPageBuilder();

abstract class GetxPage extends StatelessWidget {
  final SystemUiOverlayStyle _systemUiOverlayStyle;
  @protected
  final ControllerManager controllerManager = ControllerManager();

  GetxPage({Key? key, required SystemUiOverlayStyle? systemUiOverlayStyle})
    : _systemUiOverlayStyle = systemUiOverlayStyle ?? SystemUiOverlayStyle.dark, super(key: key);

  void _initControllerMember() {
    onSetController();
    if (controllerManager.addControllerMemberCalledCount == 0) {
      controllerManager.markControllerMemberHasBeenAdded();
    }
  }

  void onSetController();

  @override
  Widget build(BuildContext context) {
    _initControllerMember();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _systemUiOverlayStyle,
      child: _rawBuildPage(context)
    );
  }

  Widget _rawBuildPage(BuildContext context);

  void dispose() {
    controllerManager.dispose();
  }
}

abstract class DefaultGetxPage extends GetxPage {
  DefaultGetxPage({Key? key, SystemUiOverlayStyle? systemUiOverlayStyle}) : super(key: key, systemUiOverlayStyle: systemUiOverlayStyle);

  @override
  Widget _rawBuildPage(BuildContext context) {
    return buildPage(context);
  }

  Widget buildPage(BuildContext context);
}

abstract class RestorableGetxPage<T extends GetxPageRestoration> extends GetxPage {
  final _GetxPageName _getxPageName = _GetxPageName(pageName: "");
  String get pageName => _getxPageName.pageName;

  final PageRestorationStringId? pageRestorationId;

  RestorableGetxPage({
    Key? key,
    this.pageRestorationId,
    SystemUiOverlayStyle? systemUiOverlayStyle
  }) : super(key: key, systemUiOverlayStyle: systemUiOverlayStyle);

  @override
  Widget _rawBuildPage(BuildContext context) {
    return buildPage(context);
  }

  Widget buildPage(BuildContext context);

  T createPageRestoration();

  T getPageRestoration(BuildContext context) {
    _RestorableGetxOuterPageState<T>? state = context.findAncestorStateOfType<_RestorableGetxOuterPageState<T>>();
    if (state == null) {
      throw FlutterError("State (${T.toString()}) cannot be null");
    }
    return state._pageRestoration;
  }

  void _setPageName(pageName) {
    _getxPageName.pageName = pageName;
  }
}

class _GetxOuterPage extends StatefulWidget {
  final Widget child;
  final VoidCallback onDispose;

  const _GetxOuterPage({
    Key? key,
    required this.child,
    required this.onDispose,
  }): super(key: key);

  @override
  State<StatefulWidget> createState() => _GetxOuterPageState<_GetxOuterPage>();
}

class _GetxOuterPageState<T extends _GetxOuterPage> extends State<T> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }
}

// ignore: must_be_immutable
class _RestorableGetxOuterPage<T extends GetxPageRestoration> extends _GetxOuterPage {
  String _pageName;
  String get pageName => _pageName;
  final PageRestorationStringId? pageRestorationId;
  final OnCreateRestorationCallback<T> onCreateRestoration;

  _RestorableGetxOuterPage({
    Key? key,
    required Widget child,
    required VoidCallback onDispose,
    String pageName = "",
    this.pageRestorationId,
    required this.onCreateRestoration,
  }): _pageName = pageName, super(key: key, child: child, onDispose: onDispose);

  @override
  State<StatefulWidget> createState() => _RestorableGetxOuterPageState<T>();

  void _setPageName(pageName) {
    _pageName = pageName;
    if (child is RestorableGetxPage) {
      (child as RestorableGetxPage)._setPageName(pageName);
    }
  }
}

class _RestorableGetxOuterPageState<T extends GetxPageRestoration> extends _GetxOuterPageState<_RestorableGetxOuterPage<T>> with RestorationMixin {
  late final Restorator _restorator;
  late T _pageRestoration;

  _RestorableGetxOuterPageState() {
    _restorator = Restorator(this);
  }

  @override
  void initState() {
    _pageRestoration = widget.onCreateRestoration();
    _pageRestoration._pageName = widget.pageName;
    _pageRestoration.initState();
    super.initState();
  }

  @override
  String? get restorationId {
    String? restorationIdResult = widget.pageRestorationId != null ? widget.pageRestorationId!() : null;
    String result = "${widget.pageName}${restorationIdResult.isEmptyString ? "" : "_${restorationIdResult!}"}";
    //print("Restoration id: $result");
    return result;
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    _pageRestoration.restoreState(_restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    _pageRestoration.dispose();
  }
}

abstract class GetxPageRestoration {
  String _pageName = "";

  String restorationIdWithPageName(String restorationId) {
    //print("${restorationId}_$_pageName");
    return "${restorationId}_$_pageName";
  }

  void initState();
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore);
  void dispose() {}
}

abstract class MixableGetxPageRestoration extends GetxPageRestoration {
  @override
  void initState() {}
  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {}
  @override
  void dispose() {}
}

class Restorator {
  late final RestorationMixin _restorationMixin;

  Restorator(RestorationMixin restorationMixin) {
    _restorationMixin = restorationMixin;
  }

  void registerForRestoration(RestorableProperty<Object?> property, String restorationId) {
    // ignore: invalid_use_of_protected_member
    _restorationMixin.registerForRestoration(property, restorationId);
  }
}

class ExtendedGetPageRoute<T> extends GetPageRoute<T> {
  ExtendedGetPageRoute({
    RouteSettings? settings,
    Duration transitionDuration = const Duration(milliseconds: 300),
    bool opaque = true,
    Map<String, String>? parameter,
    double Function(BuildContext context)? gestureWidth,
    Curve? curve,
    Alignment? alignment,
    Transition? transition,
    bool? popGesture,
    CustomTransition? customTransition,
    bool barrierDismissible = false,
    Color? barrierColor,
    Bindings? binding,
    List<Bindings>? bindings,
    String? routeName,
    GetPageBuilder? page,
    String? title,
    bool showCupertinoParallax = true,
    String? barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false,
    List<GetMiddleware>? middlewares,
  }) : super(
    settings: settings,
    transitionDuration: transitionDuration,
    opaque: opaque,
    parameter: parameter,
    gestureWidth: gestureWidth,
    curve: curve,
    alignment: alignment,
    transition: transition,
    popGesture: popGesture,
    customTransition: customTransition,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    binding: binding,
    bindings: bindings,
    routeName: routeName,
    page: page,
    title: title,
    showCupertinoParallax: showCupertinoParallax,
    barrierLabel: barrierLabel,
    maintainState: maintainState,
    fullscreenDialog: fullscreenDialog,
    middlewares: middlewares,
  );

  @override
  Widget buildContent(BuildContext context) {
    Widget content = super.buildContent(context);
    if (content is _RestorableGetxOuterPage) {
      content._setPageName(GetExtended.sanitizeNewRestorationIdName(routeName ?? ""));
    }
    return content;
  }
}