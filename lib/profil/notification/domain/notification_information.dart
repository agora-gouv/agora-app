import 'package:agora/profil/notification/domain/notification.dart';
import 'package:equatable/equatable.dart';

class NotificationInformation extends Equatable {
  final bool hasMoreNotifications;
  final List<Notification> notifications;

  NotificationInformation({
    required this.hasMoreNotifications,
    required this.notifications,
  });

  @override
  List<Object> get props => [
        hasMoreNotifications,
        notifications,
      ];
}
