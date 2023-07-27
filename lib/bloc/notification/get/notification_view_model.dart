import 'package:equatable/equatable.dart';

class NotificationViewModel extends Equatable {
  final String title;
  final String type;
  final String date;

  NotificationViewModel({
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
