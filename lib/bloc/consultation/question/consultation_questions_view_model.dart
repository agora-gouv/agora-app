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
  List<Object> get props => [id, title, order];
}

class ConsultationQuestionUniqueViewModel extends ConsultationQuestionViewModel {
  final String questionProgress;
  final List<ConsultationQuestionResponseChoiceViewModel> responseChoicesViewModels;

  ConsultationQuestionUniqueViewModel({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
    required this.responseChoicesViewModels,
  });

  @override
  List<Object> get props => [id, title, order, questionProgress, responseChoicesViewModels];
}

class ConsultationQuestionMultipleViewModel extends ConsultationQuestionViewModel {
  final String questionProgress;
  final int maxChoices;
  final List<ConsultationQuestionResponseChoiceViewModel> responseChoicesViewModels;

  ConsultationQuestionMultipleViewModel({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
    required this.maxChoices,
    required this.responseChoicesViewModels,
  });

  @override
  List<Object> get props => [id, title, order, questionProgress, maxChoices, responseChoicesViewModels];
}

class ConsultationQuestionOpenedViewModel extends ConsultationQuestionViewModel {
  final String questionProgress;

  ConsultationQuestionOpenedViewModel({
    required super.id,
    required super.title,
    required super.order,
    required this.questionProgress,
  });

  @override
  List<Object> get props => [id, title, order, questionProgress];
}

class ConsultationQuestionChapterViewModel extends ConsultationQuestionViewModel {
  final String description;

  ConsultationQuestionChapterViewModel({
    required super.id,
    required super.title,
    required super.order,
    required this.description,
  });

  @override
  List<Object> get props => [id, title, order, description];
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
