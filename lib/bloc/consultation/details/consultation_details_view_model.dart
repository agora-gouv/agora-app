import 'package:equatable/equatable.dart';

class ConsultationDetailsViewModel extends Equatable {
  final String id;
  final String title;
  final String cover;
  final String thematiqueId;
  final String endDate;
  final String questionCount;
  final String estimatedTime;
  final int participantCount;
  final int participantCountGoal;
  final String participantCountText;
  final String participantCountGoalText;
  final String description;
  final String tipsDescription;

  ConsultationDetailsViewModel({
    required this.id,
    required this.title,
    required this.cover,
    required this.thematiqueId,
    required this.endDate,
    required this.questionCount,
    required this.estimatedTime,
    required this.participantCount,
    required this.participantCountGoal,
    required this.participantCountText,
    required this.participantCountGoalText,
    required this.description,
    required this.tipsDescription,
  });

  @override
  List<Object> get props => [
        id,
        title,
        cover,
        thematiqueId,
        endDate,
        questionCount,
        estimatedTime,
        participantCount,
        participantCountGoal,
        participantCountText,
        participantCountGoalText,
        description,
        tipsDescription,
      ];
}
