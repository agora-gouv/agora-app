import 'package:agora/thematique/bloc/thematique_view_model.dart';
import 'package:equatable/equatable.dart';

class QagResponsePaginatedViewModel extends Equatable {
  final String qagId;
  final ThematiqueViewModel thematique;
  final String title;
  final String author;
  final String authorPortraitUrl;
  final String responseDate;

  QagResponsePaginatedViewModel({
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
        authorPortraitUrl,
        responseDate,
      ];
}
