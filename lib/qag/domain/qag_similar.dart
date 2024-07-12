import 'package:agora/domain/thematique/thematique.dart';
import 'package:equatable/equatable.dart';

class QagSimilar extends Equatable {
  final String id;
  final Thematique thematique;
  final String title;
  final String description;
  final String username;
  final DateTime date;
  final int supportCount;
  final bool isSupported;

  QagSimilar({
    required this.id,
    required this.thematique,
    required this.title,
    required this.description,
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
        description,
        username,
        date,
        supportCount,
        isSupported,
      ];
}
