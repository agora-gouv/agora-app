import 'package:equatable/equatable.dart';

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
