import 'package:agora/thematique/domain/thematique.dart';
import 'package:equatable/equatable.dart';

class Qag extends Equatable {
  final String id;
  final Thematique thematique;
  final String title;
  final String description;
  final String username;
  final DateTime date;
  final int supportCount;
  final bool isSupported;
  final bool isAuthor;

  Qag({
    required this.id,
    required this.thematique,
    required this.title,
    required this.description,
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
        description,
        username,
        date,
        supportCount,
        isSupported,
        isAuthor,
      ];
}
