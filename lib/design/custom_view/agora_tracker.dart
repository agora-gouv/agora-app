import 'package:agora/agora_app.dart';
import 'package:agora/common/log/log.dart';
import 'package:flutter/material.dart';
import 'package:matomo_tracker/matomo_tracker.dart';

class AgoraTracker extends StatefulWidget {
  final String widgetName;
  final Widget child;
  final String? id;

  const AgoraTracker({Key? key, required this.widgetName, required this.child, this.id}) : super(key: key);

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
    final eventName = widget.id != null ? "CreatedPage_${widget.id}" : "CreatedPage";
    Log.d("AGORA MATOMO TRACK SCREEN - ${widget.widgetName} - $eventName");
    MatomoTracker.instance.trackScreenWithName(
      widgetName: widget.widgetName,
      eventName: eventName,
    );
  }
}
