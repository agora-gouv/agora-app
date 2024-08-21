import 'package:agora/thematique/bloc/thematique_view_model.dart';
import 'package:equatable/equatable.dart';

class QagDisplayModel extends Equatable {
  final String id;
  final ThematiqueViewModel thematique;
  final String title;
  final String username;
  final String date;
  final int supportCount;
  final bool isSupported;
  final bool isAuthor;

  QagDisplayModel({
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
