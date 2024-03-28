import 'package:agora/domain/thematique/thematique.dart';
import 'package:equatable/equatable.dart';

class ConsultationOngoing extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final Thematique thematique;
  final DateTime endDate;
  final String? highlightLabel;

  ConsultationOngoing({
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

class ConsultationFinished extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final Thematique thematique;
  final String? label;

  ConsultationFinished({
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

class ConsultationAnswered extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final Thematique thematique;
  final String? label;

  ConsultationAnswered({
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
