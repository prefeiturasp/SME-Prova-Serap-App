import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class RouteObserver extends AutoRouterObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    debugPrint('New route pushed: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    debugPrint('Route poped: ${route.settings.name}');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    debugPrint('Route removed: ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    debugPrint('Route replaced: ${oldRoute?.settings.name} by ${newRoute?.settings.name}');
  }

  // only override to observer tab routes
  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    debugPrint('Tab route visited: ${route.name}');
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    debugPrint('Tab route re-visited: ${route.name}');
  }
}
