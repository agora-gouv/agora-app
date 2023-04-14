import 'package:agora/domain/consultation/questions/consultation_question_response_choice.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationQuestion extends Equatable {
  final String id;
  final String title;
  final int order;

  ConsultationQuestion({
    required this.id,
    required this.title,
    required this.order,
  });

  @override
  List<Object> get props => [id, title, order];
}

class ConsultationQuestionUnique extends ConsultationQuestion {
  final String questionProgress;
  final List<ConsultationQuestionResponseChoice> responseChoices;

  ConsultationQuestionUnique({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
    required this.responseChoices,
  });

  @override
  List<Object> get props => [id, title, order, questionProgress, responseChoices];
}

class ConsultationQuestionMultiple extends ConsultationQuestion {
  final String questionProgress;
  final int maxChoices;
  final List<ConsultationQuestionResponseChoice> responseChoices;

  ConsultationQuestionMultiple({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
    required this.maxChoices,
    required this.responseChoices,
  });

  @override
  List<Object> get props => [id, title, order, questionProgress, maxChoices, responseChoices];
}

class ConsultationQuestionOpened extends ConsultationQuestion {
  final String questionProgress;

  ConsultationQuestionOpened({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
  });

  @override
  List<Object> get props => [id, title, order, questionProgress];
}

class ConsultationChapter extends ConsultationQuestion {
  final String description;

  ConsultationChapter({
    required super.id,
    required super.title,
    required super.order,
    required this.description,
  });

  @override
  List<Object> get props => [id, title, order, description];
}
