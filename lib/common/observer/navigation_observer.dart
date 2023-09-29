import 'package:agora/common/log/log.dart';
import 'package:flutter/material.dart';

/// works for routes automatically
/// works for onGenerateRoute if added RouteSettings(name: settings.name) in PageRoute
class NavigationObserver extends RouteObserver<ModalRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) {
      Log.d("🐣 Push ${route.settings.name}");
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) {
      Log.d("🐣 Pop ${route.settings.name} ➡️ ${previousRoute?.settings.name}");
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) {
      Log.d("🐣 Remove ${route.settings.name}");
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute?.settings.name != null) {
      Log.d("🐣 Replace ${oldRoute?.settings.name} ➡️ ${newRoute?.settings.name}");
    }
  }
}
