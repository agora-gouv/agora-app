import 'package:agora/push_notification/notification_message_type.dart';

extension NotificationMessageExtension on String? {
  NotificationMessageType? toNotificationMessageType() {
    return switch (this) {
      "ALL_REPONSES_QAGS" => NotificationMessageType.qagReponses,
      "HOME_QAGS" => NotificationMessageType.homeQags,
      "DETAILS_QAG" => NotificationMessageType.qagDetails,
      "HOME_CONSULTATIONS" => NotificationMessageType.homeConsultations,
      "DETAILS_CONSULTATION" => NotificationMessageType.consultationDetails,
      "REPONSE_SUPPORT" => NotificationMessageType.reponseSupport,
      _ => null,
    };
  }
}
