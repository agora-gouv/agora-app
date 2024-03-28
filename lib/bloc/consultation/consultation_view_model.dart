import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:equatable/equatable.dart';

class ConsultationOngoingViewModel extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final ThematiqueViewModel thematique;
  final String endDate;
  final String? highlightLabel;

  ConsultationOngoingViewModel({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.thematique,
    required this.endDate,
    required this.highlightLabel,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        coverUrl,
        thematique,
        endDate,
        highlightLabel,
      ];
}

class ConsultationFinishedViewModel extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final ThematiqueViewModel thematique;
  final String? label;

  ConsultationFinishedViewModel({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.thematique,
    required this.label,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        coverUrl,
        thematique,
        label,
      ];
}

class ConsultationAnsweredViewModel extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final ThematiqueViewModel thematique;
  final String? label;

  ConsultationAnsweredViewModel({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.thematique,
    required this.label,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        coverUrl,
        thematique,
        label,
      ];
}
