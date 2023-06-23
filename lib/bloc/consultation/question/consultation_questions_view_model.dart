import 'package:equatable/equatable.dart';

abstract class ConsultationQuestionViewModel extends Equatable {
  final String id;
  final String title;
  final int order;

  ConsultationQuestionViewModel({
    required this.id,
    required this.title,
    required this.order,
  });

  @override
  List<Object?> get props => [id, title, order];
}

class ConsultationQuestionUniqueViewModel extends ConsultationQuestionViewModel {
  final String questionProgress;
  final List<ConsultationQuestionResponseChoiceViewModel> responseChoicesViewModels;
  final String? nextQuestionId;
  final String? popupDescription;

  ConsultationQuestionUniqueViewModel({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
    required this.responseChoicesViewModels,
    required this.nextQuestionId,
    required this.popupDescription,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        order,
        questionProgress,
        responseChoicesViewModels,
        nextQuestionId,
        popupDescription,
      ];
}

class ConsultationQuestionMultipleViewModel extends ConsultationQuestionViewModel {
  final String questionProgress;
  final int maxChoices;
  final List<ConsultationQuestionResponseChoiceViewModel> responseChoicesViewModels;
  final String? nextQuestionId;
  final String? popupDescription;

  ConsultationQuestionMultipleViewModel({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
    required this.maxChoices,
    required this.responseChoicesViewModels,
    required this.nextQuestionId,
    required this.popupDescription,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        order,
        questionProgress,
        maxChoices,
        responseChoicesViewModels,
        nextQuestionId,
        popupDescription,
      ];
}

class ConsultationQuestionOpenedViewModel extends ConsultationQuestionViewModel {
  final String questionProgress;
  final String? nextQuestionId;
  final String? popupDescription;

  ConsultationQuestionOpenedViewModel({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
    required this.nextQuestionId,
    required this.popupDescription,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        order,
        questionProgress,
        nextQuestionId,
        popupDescription,
      ];
}

class ConsultationQuestionWithConditionViewModel extends ConsultationQuestionViewModel {
  final String questionProgress;
  final List<ConsultationQuestionWithConditionResponseChoiceViewModel> responseChoicesViewModels;
  final String? popupDescription;

  ConsultationQuestionWithConditionViewModel({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
    required this.responseChoicesViewModels,
    required this.popupDescription,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        order,
        questionProgress,
        responseChoicesViewModels,
        popupDescription,
      ];
}

class ConsultationQuestionChapterViewModel extends ConsultationQuestionViewModel {
  final String description;
  final String? nextQuestionId;

  ConsultationQuestionChapterViewModel({
    required super.id,
    required super.title,
    required super.order,
    required this.description,
    required this.nextQuestionId,
  });

  @override
  List<Object?> get props => [id, title, order, description, nextQuestionId];
}

class ConsultationQuestionResponseChoiceViewModel extends Equatable {
  final String id;
  final String label;
  final int order;

  ConsultationQuestionResponseChoiceViewModel({
    required this.id,
    required this.label,
    required this.order,
  });

  @override
  List<Object> get props => [
        id,
        label,
        order,
      ];
}

class ConsultationQuestionWithConditionResponseChoiceViewModel extends Equatable {
  final String id;
  final String label;
  final int order;
  final String nextQuestionId;

  ConsultationQuestionWithConditionResponseChoiceViewModel({
    required this.id,
    required this.label,
    required this.order,
    required this.nextQuestionId,
  });

  @override
  List<Object> get props => [
        id,
        label,
        order,
        nextQuestionId,
      ];
}
