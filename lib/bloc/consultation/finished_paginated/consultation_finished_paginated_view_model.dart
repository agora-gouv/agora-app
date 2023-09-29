import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:equatable/equatable.dart';

class ConsultationFinishedPaginatedViewModel extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final ThematiqueViewModel thematique;
  final int step;

  ConsultationFinishedPaginatedViewModel({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.thematique,
    required this.step,
  });

  @override
  List<Object> get props => [
        id,
        title,
        coverUrl,
        thematique,
        step,
      ];
}
