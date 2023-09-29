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

class Notification extends Equatable {
  final String title;
  final String type;
  final DateTime date;

  Notification({
    required this.title,
    required this.type,
    required this.date,
  });

  @override
  List<Object> get props => [
        title,
        type,
        date,
      ];
}
