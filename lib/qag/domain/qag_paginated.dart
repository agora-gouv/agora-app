import 'package:agora/thematique/domain/thematique.dart';
import 'package:equatable/equatable.dart';

class QagPaginated extends Equatable {
  final String id;
  final Thematique thematique;
  final String title;
  final String username;
  final DateTime date;
  final int supportCount;
  final bool isSupported;
  final bool isAuthor;

  QagPaginated({
    required this.id,
    required this.thematique,
    required this.title,
    required this.username,
    required this.date,
    required this.supportCount,
    required this.isSupported,
    required this.isAuthor,
  });

  @override
  List<Object> get props => [
        id,
        thematique,
        title,
        username,
        date,
        supportCount,
        isSupported,
        isAuthor,
      ];
}
