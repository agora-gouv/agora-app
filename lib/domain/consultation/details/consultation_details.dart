import 'package:equatable/equatable.dart';

class ConsultationDetails extends Equatable {
  final String id;
  final String title;
  final String cover;
  final String thematiqueId;
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
    required this.cover,
    required this.thematiqueId,
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
        cover,
        thematiqueId,
        endDate,
        questionCount,
        estimatedTime,
        participantCount,
        participantCountGoal,
        description,
        tipsDescription,
      ];
}
