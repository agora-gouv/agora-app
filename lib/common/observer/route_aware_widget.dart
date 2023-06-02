import 'package:agora/agora_app.dart';
import 'package:agora/common/log/log.dart';
import 'package:flutter/material.dart';

/// Create specific widget for onGenerateRoute
class RouteAwareWidget extends StatefulWidget {
  final String name;
  final Widget child;

  RouteAwareWidget({required this.name, required this.child});

  @override
  State<RouteAwareWidget> createState() => RouteAwareWidgetState();
}

class RouteAwareWidgetState extends State<RouteAwareWidget> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      AgoraApp.navigationObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    AgoraApp.navigationObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    super.didPush();
    Log.d("🐣 Push ${widget.name}");
  }

  @override
  void didPopNext() {
    super.didPopNext();
    Log.d("🐣 ${widget.name}");
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
