import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationViewModel extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final ThematiqueViewModel thematique;

  ConsultationViewModel({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.thematique,
  });

  @override
  List<Object> get props => [
        id,
        title,
        coverUrl,
        thematique,
      ];
}

class ConsultationOngoingViewModel extends ConsultationViewModel {
  final String endDate;
  final bool hasAnswered;

  ConsultationOngoingViewModel({
    required super.id,
    required super.title,
    required super.coverUrl,
    required super.thematique,
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
