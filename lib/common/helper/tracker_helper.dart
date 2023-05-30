import 'package:agora/common/log/log.dart';
import 'package:matomo_tracker/matomo_tracker.dart';

class TrackerHelper {
  static void trackClick(String clickName, String widgetName) {
    Log.d("AGORA MATOMO TRACK CLICK - $widgetName - $clickName");
    MatomoTracker.instance.trackEvent(
      eventName: clickName,
      action: "click",
      eventCategory: widgetName,
    );
  }
}
