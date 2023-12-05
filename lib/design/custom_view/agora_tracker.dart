import 'package:agora/agora_app.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:flutter/material.dart';

class AgoraTracker extends StatefulWidget {
  final String widgetName;
  final Widget child;

  const AgoraTracker({super.key, required this.widgetName, required this.child});

  @override
  State<AgoraTracker> createState() => _AgoraTrackerState();
}

class _AgoraTrackerState extends State<AgoraTracker> with RouteAware {
  @override
  void initState() {
    _track();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      AgoraApp.matomoRouteObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    AgoraApp.matomoRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didPopNext() {
    _track();
  }

  void _track() {
    TrackerHelper.trackScreen(screenName: widget.widgetName);
  }
}
