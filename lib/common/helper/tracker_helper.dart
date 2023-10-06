import 'package:agora/common/helper/app_version_helper.dart';
import 'package:agora/common/helper/permission_helper.dart';
import 'package:agora/common/log/log.dart';
import 'package:matomo_tracker/matomo_tracker.dart';

/// see https://pub.dev/packages/matomo
class TrackerHelper {
  static const matomoNotificationTrackerDimension = "1";
  static const matomoVersionTrackerDimension = "2";

  static void trackClick({required String widgetName, required String clickName}) {
    Log.d("AGORA MATOMO TRACK CLICK - $widgetName - $clickName");
    MatomoTracker.instance.trackEvent(
      eventCategory: widgetName,
      action: "click",
      eventName: clickName,
    );
  }

  static void trackDimension() async {
    final permission = PermissionImplHelper();
    final version = AppVersionHelperImpl();
    final dimension = {
      matomoNotificationTrackerDimension: await permission.isDenied() ? "false" : "true",
      matomoVersionTrackerDimension: await version.getVersion(),
    };

    Log.d("AGORA MATOMO TRACK DIMENSION - $dimension");
    MatomoTracker.instance.trackDimensions(dimension);
  }

  static void trackScreen({required String screenName}) {
    Log.d("AGORA MATOMO TRACK SCREEN - $screenName");
    MatomoTracker.instance.trackScreenWithName(
      widgetName: screenName,
      eventName: "CreatedPage",
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
