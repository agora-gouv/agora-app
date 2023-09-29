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
  final String questionProgressSemanticLabel;
  final List<ConsultationQuestionResponseChoice> responseChoices;
  final String? nextQuestionId;
  final String? popupDescription;

  ConsultationQuestionUnique({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
    required this.questionProgressSemanticLabel,
    required this.responseChoices,
    required this.nextQuestionId,
    required this.popupDescription,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        order,
        questionProgress,
        questionProgressSemanticLabel,
        responseChoices,
        nextQuestionId,
        popupDescription,
      ];
}

class ConsultationQuestionMultiple extends ConsultationQuestion {
  final String questionProgress;
  final String questionProgressSemanticLabel;
  final int maxChoices;
  final List<ConsultationQuestionResponseChoice> responseChoices;
  final String? nextQuestionId;
  final String? popupDescription;

  ConsultationQuestionMultiple({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
    required this.questionProgressSemanticLabel,
    required this.maxChoices,
    required this.responseChoices,
    required this.nextQuestionId,
    required this.popupDescription,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        order,
        questionProgress,
        questionProgressSemanticLabel,
        maxChoices,
        responseChoices,
        nextQuestionId,
        popupDescription,
      ];
}

class ConsultationQuestionOpened extends ConsultationQuestion {
  final String questionProgress;
  final String questionProgressSemanticLabel;
  final String? nextQuestionId;
  final String? popupDescription;

  ConsultationQuestionOpened({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
    required this.questionProgressSemanticLabel,
    required this.nextQuestionId,
    required this.popupDescription,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        order,
        questionProgress,
        questionProgressSemanticLabel,
        nextQuestionId,
        popupDescription,
      ];
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
  final String questionProgressSemanticLabel;
  final List<ConsultationQuestionResponseWithConditionChoice> responseChoices;
  final String? popupDescription;

  ConsultationQuestionWithCondition({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
    required this.questionProgressSemanticLabel,
    required this.responseChoices,
    required this.popupDescription,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        order,
        questionProgress,
        questionProgressSemanticLabel,
        responseChoices,
        popupDescription,
      ];
}
