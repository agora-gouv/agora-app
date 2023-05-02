import 'package:agora/domain/thematique/thematique.dart';
import 'package:equatable/equatable.dart';

abstract class Consultation extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final Thematique thematique;

  Consultation({
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

class ConsultationOngoing extends Consultation {
  final bool hasAnswered;
  final DateTime endDate;

  ConsultationOngoing({
    required super.id,
    required super.title,
    required super.coverUrl,
    required super.thematique,
    required this.endDate,
    required this.hasAnswered,
  });
}
