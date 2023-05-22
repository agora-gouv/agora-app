import 'package:agora/domain/thematique/thematique.dart';
import 'package:equatable/equatable.dart';

class QagPaginated extends Equatable {
  final String id;
  final Thematique thematique;
  final String title;
  final String username;
  final DateTime date;
  final int supportCount;
  final bool isSupported;

  QagPaginated({
    required this.id,
    required this.thematique,
    required this.title,
    required this.username,
    required this.date,
    required this.supportCount,
    required this.isSupported,
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
      ];
}
