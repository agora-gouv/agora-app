import 'package:equatable/equatable.dart';

class QagDetailsViewModel extends Equatable {
  final String id;
  final String thematiqueId;
  final String title;
  final String description;
  final String username;
  final String date;
  final int supportCount;

  QagDetailsViewModel({
    required this.id,
    required this.thematiqueId,
    required this.title,
    required this.description,
    required this.username,
    required this.date,
    required this.supportCount,
  });

  @override
  List<Object> get props => [
        id,
        thematiqueId,
        title,
        description,
        username,
        date,
        supportCount,
      ];
}
