import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../presentation/widget/something_counter.dart';

class _MainRouteObserver extends RouteObserver {
  Map<String, RouteWrapper?> _routeMap = {};
  Map<String, RouteWrapper?> get routeMap => _routeMap;

  void applyNewRouteMapFromRouteKeyMap(Map<String, int> newRouteMap) {
    _routeMap = {
      for (var key in newRouteMap.keys) key: RouteWrapper(restorationValue: newRouteMap[key] ?? 1)
    };
  }

  void _updateModifyRouteKeyMapValue(Route route) {
    BuildContext? context = route.navigator?.context;
    if (context != null) {
      RouteKeyMapValue? routeKeyMapValue = SomethingCounter.of(context)?.routeKeyMap.value;
      if (routeKeyMapValue != null) {
        routeKeyMapValue.key = {
          for (var key in _routeMap.keys) key: 0
        };
        SomethingCounter.of(context)?.routeKeyMap.value = routeKeyMapValue.copy();
      }
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _routeMap.remove(route.settings.name);
    _updateModifyRouteKeyMapValue(route);
    //print("Pop Route: $route");
    _showRouteMap();
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _routeMap[route.settings.name ?? ""] = RouteWrapper(route: route, restorationValue: 0);
    _updateModifyRouteKeyMapValue(route);
    //print("Push Route: $route");
    _showRouteMap();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    _routeMap.remove(route.settings.name);
    _updateModifyRouteKeyMapValue(route);
    //print("Remove Route: $route");
    _showRouteMap();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute != null) {
      _routeMap.remove(oldRoute.settings.name);
      _updateModifyRouteKeyMapValue(oldRoute);
    }
    if (newRoute != null) {
      _routeMap[newRoute.settings.name ?? ""] = RouteWrapper(route: newRoute, restorationValue: 0);
      _updateModifyRouteKeyMapValue(newRoute);
    }
    //print("Replace Route: $newRoute");
    _showRouteMap();
  }

  void _showRouteMap() {
    // print("");
    // print("Route Map:");
    // _routeMap.forEach((key, value) {
    //   print("Key: $key, Value: $value");
    // });
    // print("");
  }

  bool checkRouteNameExists(String routeName) {
    return _routeMap.containsKey(routeName);
  }
}

// ignore: non_constant_identifier_names
final _MainRouteObserver MainRouteObserver = _MainRouteObserver();

class RouteWrapper {
  Route? route;
  int restorationValue;

  RouteWrapper({
    this.route,
    required this.restorationValue
  });
}