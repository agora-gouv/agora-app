import 'package:agora/push_notification/notification_message_type.dart';

extension NotificationMessageExtension on String? {
  NotificationMessageType? toNotificationMessageType() {
    switch (this) {
      case "qagDetails":
        return NotificationMessageType.qagDetails;
      case "consultationDetails":
        return NotificationMessageType.consultationDetails;
      case "qagHome":
        return NotificationMessageType.homeQags;
      default:
        return null;
    }
  }
}
