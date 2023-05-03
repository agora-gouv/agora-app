import 'package:agora/domain/thematique/thematique.dart';
import 'package:equatable/equatable.dart';

class ConsultationDetails extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final Thematique thematique;
  final DateTime endDate;
  final String questionCount;
  final String estimatedTime;
  final int participantCount;
  final int participantCountGoal;
  final String description;
  final String tipsDescription;

  ConsultationDetails({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.thematique,
    required this.endDate,
    required this.questionCount,
    required this.estimatedTime,
    required this.participantCount,
    required this.participantCountGoal,
    required this.description,
    required this.tipsDescription,
  });

  @override
  List<Object> get props => [
        id,
        title,
        coverUrl,
        thematique,
        endDate,
        questionCount,
        estimatedTime,
        participantCount,
        participantCountGoal,
        description,
        tipsDescription,
      ];
}
