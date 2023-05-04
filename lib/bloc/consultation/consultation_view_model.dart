import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:equatable/equatable.dart';

class ConsultationOngoingViewModel extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final ThematiqueViewModel thematique;
  final String endDate;
  final bool hasAnswered;

  ConsultationOngoingViewModel({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.thematique,
    required this.endDate,
    required this.hasAnswered,
  });

  @override
  List<Object> get props => [
        id,
        title,
        coverUrl,
        thematique,
        endDate,
        hasAnswered,
      ];
}
