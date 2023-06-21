import 'package:agora/domain/thematique/thematique.dart';
import 'package:equatable/equatable.dart';

class ConsultationOngoing extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final Thematique thematique;
  final bool hasAnswered;
  final DateTime endDate;
  final String? highlightLabel;

  ConsultationOngoing({
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

class ConsultationFinished extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final Thematique thematique;
  final int step;

  ConsultationFinished({
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

class ConsultationAnswered extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final Thematique thematique;
  final int step;

  ConsultationAnswered({
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
