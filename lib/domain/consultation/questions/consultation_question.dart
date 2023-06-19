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
  List<Object?> get props => [id, title, order];
}

class ConsultationQuestionUnique extends ConsultationQuestion {
  final String questionProgress;
  final List<ConsultationQuestionResponseChoice> responseChoices;
  final String? nextQuestionId;

  ConsultationQuestionUnique({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
    required this.responseChoices,
    required this.nextQuestionId,
  });

  @override
  List<Object?> get props => [id, title, order, questionProgress, responseChoices, nextQuestionId];
}

class ConsultationQuestionMultiple extends ConsultationQuestion {
  final String questionProgress;
  final int maxChoices;
  final List<ConsultationQuestionResponseChoice> responseChoices;
  final String? nextQuestionId;

  ConsultationQuestionMultiple({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
    required this.maxChoices,
    required this.responseChoices,
    required this.nextQuestionId,
  });

  @override
  List<Object?> get props => [id, title, order, questionProgress, maxChoices, responseChoices, nextQuestionId];
}

class ConsultationQuestionOpened extends ConsultationQuestion {
  final String questionProgress;
  final String? nextQuestionId;

  ConsultationQuestionOpened({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
    required this.nextQuestionId,
  });

  @override
  List<Object?> get props => [id, title, order, questionProgress, nextQuestionId];
}

class ConsultationQuestionChapter extends ConsultationQuestion {
  final String description;
  final String? nextQuestionId;

  ConsultationQuestionChapter({
    required super.id,
    required super.title,
    required super.order,
    required this.description,
    required this.nextQuestionId,
  });

  @override
  List<Object?> get props => [id, title, order, description, nextQuestionId];
}

class ConsultationQuestionWithCondition extends ConsultationQuestion {
  final String questionProgress;
  final List<ConsultationQuestionResponseWithConditionChoice> responseChoices;

  ConsultationQuestionWithCondition({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
    required this.responseChoices,
  });

  @override
  List<Object> get props => [id, title, order, questionProgress, responseChoices];
}
