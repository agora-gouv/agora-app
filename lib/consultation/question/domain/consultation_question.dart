import 'package:agora/consultation/question/domain/consultation_question_response_choice.dart';
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
  final List<ConsultationQuestionResponseChoice> responseChoices;
  final String? nextQuestionId;
  final String? popupDescription;

  ConsultationQuestionUnique({
    required super.id,
    required super.title,
    required super.order,
    required this.responseChoices,
    required this.nextQuestionId,
    required this.popupDescription,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        order,
        responseChoices,
        nextQuestionId,
        popupDescription,
      ];
}

class ConsultationQuestionMultiple extends ConsultationQuestion {
  final int maxChoices;
  final List<ConsultationQuestionResponseChoice> responseChoices;
  final String? nextQuestionId;
  final String? popupDescription;

  ConsultationQuestionMultiple({
    required super.id,
    required super.title,
    required super.order,
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
        maxChoices,
        responseChoices,
        nextQuestionId,
        popupDescription,
      ];
}

class ConsultationQuestionOpened extends ConsultationQuestion {
  final String? nextQuestionId;
  final String? popupDescription;

  ConsultationQuestionOpened({
    required super.id,
    required super.title,
    required super.order,
    required this.nextQuestionId,
    required this.popupDescription,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        order,
        nextQuestionId,
        popupDescription,
      ];
}

class ConsultationQuestionChapter extends ConsultationQuestion {
  final String description;
  final String? nextQuestionId;
  final String? imageUrl;

  ConsultationQuestionChapter({
    required super.id,
    required super.title,
    required super.order,
    required this.description,
    required this.nextQuestionId,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, title, order, description, nextQuestionId, imageUrl];
}

class ConsultationQuestionWithCondition extends ConsultationQuestion {
  final List<ConsultationQuestionResponseWithConditionChoice> responseChoices;
  final String? popupDescription;

  ConsultationQuestionWithCondition({
    required super.id,
    required super.title,
    required super.order,
    required this.responseChoices,
    required this.popupDescription,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        order,
        responseChoices,
        popupDescription,
      ];
}
