import 'package:agora/common/log/log.dart';
import 'package:matomo_tracker/matomo_tracker.dart';

class TrackerHelper {
  static void trackClick({required String widgetName, required String clickName}) {
    Log.d("AGORA MATOMO TRACK CLICK - $widgetName - $clickName");
    MatomoTracker.instance.trackEvent(
      eventCategory: widgetName,
      action: "click",
      eventName: clickName,
    );
  }

  static void trackEvent({required String widgetName, required String eventName}) {
    Log.d("AGORA MATOMO TRACK EVENT - $widgetName - $eventName");
    MatomoTracker.instance.trackEvent(
      eventCategory: widgetName,
      action: "event",
      eventName: eventName,
    );
  }
}
