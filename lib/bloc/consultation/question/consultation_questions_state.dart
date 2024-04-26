import 'package:agora/bloc/consultation/question/consultation_questions_view_model.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationQuestionsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConsultationQuestionsInitialLoadingState extends ConsultationQuestionsState {}

class ConsultationQuestionsFetchedState extends ConsultationQuestionsState {
  final ConsultationQuestionsViewModel consultationQuestionsViewModel;

  ConsultationQuestionsFetchedState({required this.consultationQuestionsViewModel});

  @override
  List<Object> get props => [consultationQuestionsViewModel];
}

class ConsultationQuestionsErrorState extends ConsultationQuestionsState {}
