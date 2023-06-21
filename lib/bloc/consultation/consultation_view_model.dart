import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:equatable/equatable.dart';

class ConsultationOngoingViewModel extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final ThematiqueViewModel thematique;
  final String endDate;
  final bool hasAnswered;
  final String? highlightLabel;

  ConsultationOngoingViewModel({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.thematique,
    required this.endDate,
    required this.hasAnswered,
    required this.highlightLabel,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        coverUrl,
        thematique,
        endDate,
        hasAnswered,
        highlightLabel,
      ];
}

class ConsultationFinishedViewModel extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final ThematiqueViewModel thematique;
  final int step;

  ConsultationFinishedViewModel({
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

class ConsultationAnsweredViewModel extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final ThematiqueViewModel thematique;
  final int step;

  ConsultationAnsweredViewModel({
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
