import 'package:agora/domain/thematique/thematique.dart';
import 'package:equatable/equatable.dart';

class ConsultationOngoing extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final Thematique thematique;
  final bool hasAnswered;
  final DateTime endDate;

  ConsultationOngoing({
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
