import 'package:agora/bloc/notification/get/notification_view_model.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/domain/notification/notification.dart';

class NotificationPresenter {
  static List<NotificationViewModel> presentNotification(
    List<Notification> notifications,
  ) {
    return notifications.map((notification) {
      return NotificationViewModel(
        title: notification.title,
        type: notification.type,
        date: notification.date.formatToDayLongMonth(),
      );
    }).toList();
  }
}
