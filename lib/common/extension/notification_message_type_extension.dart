import 'package:agora/push_notification/notification_message_type.dart';

extension NotificationMessageExtension on String {
  NotificationMessageType toNotificationMessageType() {
    switch (this) {
      case "qagDetails":
        return NotificationMessageType.qagDetails;
      case "consultationDetails":
        return NotificationMessageType.consultationDetails;
      case "consultationResults":
        return NotificationMessageType.consultationResults;
      default:
        throw Exception("Notification message type doesn't exist: $this}");
    }
  }
}
