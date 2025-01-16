import 'package:agora/common/helper/app_version_helper.dart';
import 'package:agora/common/helper/permission_helper.dart';
import 'package:agora/common/log/log.dart';
import 'package:matomo_tracker/matomo_tracker.dart';

/// see https://pub.dev/packages/matomo
class TrackerHelper {
  static const matomoNotificationTrackerDimension = "dimension1";
  static const matomoVersionTrackerDimension = "dimension2";
  static const matomoSearchedKeywordsTrackerDimension = "dimension3";

  static void trackClick({required String widgetName, required String clickName}) {
    Log.debug("AGORA MATOMO TRACK CLICK - $widgetName - $clickName");
    MatomoTracker.instance.trackEvent(
      eventInfo: EventInfo(
        category: widgetName,
        action: "click",
        name: clickName,
      ),
    );
  }

  static void trackDimension() async {
    final permission = PermissionImplHelper();
    final version = AppVersionHelperImpl();
    final dimension = {
      matomoNotificationTrackerDimension: await permission.isDenied() ? "false" : "true",
      matomoVersionTrackerDimension: await version.getVersion(),
    };

    Log.debug("AGORA MATOMO TRACK DIMENSION - $dimension");
    MatomoTracker.instance.trackDimensions(dimensions: dimension);
  }

  static void trackScreen({required String screenName}) {
    Log.debug("AGORA MATOMO TRACK SCREEN - $screenName");
    MatomoTracker.instance.trackPageViewWithName(actionName: screenName);
  }

  static void trackEvent({required String widgetName, required String eventName}) {
    Log.debug("AGORA MATOMO TRACK EVENT - $widgetName - $eventName");
    MatomoTracker.instance.trackEvent(
      eventInfo: EventInfo(
        category: widgetName,
        action: "event",
        name: eventName,
      ),
    );
  }

  static void trackSearch({required String widgetName, required String searchName, required String searchedKeywords}) {
    Log.debug("AGORA MATOMO TRACK EVENT - $widgetName - $searchName");

    MatomoTracker.instance.trackEvent(
      eventInfo: EventInfo(
        category: widgetName,
        action: "search",
        name: searchName,
      ),
      dimensions: {matomoSearchedKeywordsTrackerDimension: searchedKeywords},
    );
  }
}
