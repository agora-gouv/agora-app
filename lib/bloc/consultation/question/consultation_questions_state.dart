import 'package:agora/bloc/consultation/question/consultation_questions_view_model.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationQuestionsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConsultationQuestionsInitialLoadingState extends ConsultationQuestionsState {}

class ConsultationQuestionsFetchedState extends ConsultationQuestionsState {
  final List<ConsultationQuestionViewModel> viewModels;

  ConsultationQuestionsFetchedState({required this.viewModels});

  @override
  List<Object> get props => [viewModels];
}

class ConsultationQuestionsErrorState extends ConsultationQuestionsState {}
