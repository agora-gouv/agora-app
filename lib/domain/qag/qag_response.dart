import 'package:agora/domain/thematique/thematique.dart';
import 'package:equatable/equatable.dart';

class QagResponse extends Equatable {
  final String qagId;
  final Thematique thematique;
  final String title;
  final String author;
  final String authorPortraitUrl;
  final DateTime responseDate;

  QagResponse({
    required this.qagId,
    required this.thematique,
    required this.title,
    required this.author,
    required this.authorPortraitUrl,
    required this.responseDate,
  });

  @override
  List<Object> get props => [
        qagId,
        thematique,
        title,
        author,
        responseDate,
      ];
}
