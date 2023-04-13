import 'package:equatable/equatable.dart';

class QagDetails extends Equatable {
  final String id;
  final String thematiqueId;
  final String title;
  final String description;
  final DateTime date;
  final String username;
  final int supportCount;

  QagDetails({
    required this.id,
    required this.thematiqueId,
    required this.title,
    required this.description,
    required this.date,
    required this.username,
    required this.supportCount,
  });

  @override
  List<Object> get props => [
        id,
        thematiqueId,
        title,
        description,
        date,
        username,
        supportCount,
      ];
}
