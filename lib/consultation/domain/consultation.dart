import 'package:agora/thematique/domain/thematique.dart';
import 'package:equatable/equatable.dart';

class Consultation extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final Thematique thematique;
  final String? label;
  final DateTime? updateDate;
  final DateTime? endDate;

  Consultation({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.thematique,
    this.label,
    this.updateDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        coverUrl,
        thematique,
        label,
        updateDate,
        endDate,
      ];
}

class ConsultationOngoing extends Consultation {
  ConsultationOngoing({
    required super.id,
    required super.title,
    required super.coverUrl,
    required super.thematique,
    super.label,
    super.endDate,
  });

  @override
  List<Object?> get props => [...super.props];
}

class ConsultationFinished extends Consultation {
  ConsultationFinished({
    required super.id,
    required super.title,
    required super.coverUrl,
    required super.thematique,
    super.label,
    super.updateDate,
  });

  @override
  List<Object?> get props => [...super.props];
}

class Concertation extends Consultation {
  final String externalLink;

  Concertation({
    required super.id,
    required super.title,
    required super.coverUrl,
    required super.thematique,
    super.label,
    super.updateDate,
    required this.externalLink,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        externalLink,
      ];
}

class ConsultationAnswered extends Consultation {
  ConsultationAnswered({
    required super.id,
    required super.title,
    required super.coverUrl,
    required super.thematique,
    super.label,
  });

  @override
  List<Object?> get props => [...super.props];
}
