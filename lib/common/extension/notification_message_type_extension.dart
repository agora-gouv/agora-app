import 'package:agora/push_notification/notification_message_type.dart';

extension NotificationMessageExtension on String? {
  NotificationMessageType? toNotificationMessageType() {
    return switch (this) {
      "qagDetails" => NotificationMessageType.qagDetails,
      "consultationDetails" => NotificationMessageType.consultationDetails,
      "qagHome" => NotificationMessageType.homeQags,
      "consultationHome" => NotificationMessageType.homeConsultations,
      "reponseSupport" => NotificationMessageType.reponseSupport,
      _ => null,
    };
  }
}
