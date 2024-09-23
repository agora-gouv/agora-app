import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  final String title;
  final String description;
  final String type;
  final DateTime date;

  Notification({
    required this.title,
    required this.description,
    required this.type,
    required this.date,
  });

  @override
  List<Object> get props => [
        title,
        description,
        type,
        date,
      ];
}
