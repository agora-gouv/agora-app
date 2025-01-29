import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/profil/notification/bloc/get/notification_view_model.dart';
import 'package:agora/profil/notification/domain/notification.dart';

class NotificationPresenter {
  static List<NotificationViewModel> presentNotification(
    List<Notification> notifications,
  ) {
    return notifications.map((notification) {
      return NotificationViewModel(
        title: notification.title,
        description: notification.description,
        type: notification.type,
        date: notification.date.formatToDayLongMonth(),
      );
    }).toList();
  }
}
