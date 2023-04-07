import 'package:agora/domain/consultation/questions/consultation_question_type.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationQuestionsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConsultationQuestionsInitialLoadingState extends ConsultationQuestionsState {}

class ConsultationQuestionsFetchedState extends ConsultationQuestionsState {
  final int currentQuestionIndex;
  final int totalQuestion;
  final List<ConsultationQuestionViewModel> viewModels;

  ConsultationQuestionsFetchedState({
    required this.currentQuestionIndex,
    required this.totalQuestion,
    required this.viewModels,
  });

  @override
  List<Object> get props => [currentQuestionIndex, totalQuestion, viewModels];
}

class ConsultationQuestionsErrorState extends ConsultationQuestionsState {}

class ConsultationQuestionsFinishState extends ConsultationQuestionsState {}

class ConsultationQuestionViewModel extends Equatable {
  final String id;
  final String label;
  final int order;
  final ConsultationQuestionType type;
  final List<ConsultationQuestionResponseChoiceViewModel> responseChoicesViewModels;

  ConsultationQuestionViewModel({
    required this.id,
    required this.label,
    required this.order,
    required this.type,
    required this.responseChoicesViewModels,
  });

  @override
  List<Object> get props => [
        id,
        label,
        order,
        type,
        responseChoicesViewModels,
      ];
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
