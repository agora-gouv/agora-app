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

  ConsultationQuestionUniqueViewModel({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
    required this.responseChoicesViewModels,
    required this.nextQuestionId,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        order,
        questionProgress,
        responseChoicesViewModels,
        nextQuestionId,
      ];
}

class ConsultationQuestionMultipleViewModel extends ConsultationQuestionViewModel {
  final String questionProgress;
  final int maxChoices;
  final List<ConsultationQuestionResponseChoiceViewModel> responseChoicesViewModels;
  final String? nextQuestionId;

  ConsultationQuestionMultipleViewModel({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
    required this.maxChoices,
    required this.responseChoicesViewModels,
    required this.nextQuestionId,
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
      ];
}

class ConsultationQuestionOpenedViewModel extends ConsultationQuestionViewModel {
  final String questionProgress;
  final String? nextQuestionId;

  ConsultationQuestionOpenedViewModel({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
    required this.nextQuestionId,
  });

  @override
  List<Object?> get props => [id, title, order, questionProgress, nextQuestionId];
}

class ConsultationQuestionWithConditionViewModel extends ConsultationQuestionViewModel {
  final String questionProgress;
  final List<ConsultationQuestionWithConditionResponseChoiceViewModel> responseChoicesViewModels;

  ConsultationQuestionWithConditionViewModel({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
    required this.responseChoicesViewModels,
  });

  @override
  List<Object> get props => [id, title, order, questionProgress, responseChoicesViewModels];
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
