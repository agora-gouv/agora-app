import 'package:agora/bloc/consultation/question/consultation_questions_event.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_state.dart';
import 'package:agora/infrastructure/consultation/presenter/consultation_questions_presenter.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationQuestionsBloc extends Bloc<ConsultationQuestionsEvent, ConsultationQuestionsState> {
  final ConsultationRepository consultationRepository;

  ConsultationQuestionsBloc({
    required this.consultationRepository,
  }) : super(ConsultationQuestionsInitialLoadingState()) {
    on<FetchConsultationQuestionsEvent>(_handleConsultationQuestions);
    on<ConsultationNextQuestionEvent>(_handleConsultationNextQuestion);
    on<ConsultationPreviousQuestionEvent>(_handleConsultationPreviousQuestion);
  }

  Future<void> _handleConsultationQuestions(
    FetchConsultationQuestionsEvent event,
    Emitter<ConsultationQuestionsState> emit,
  ) async {
    final response = await consultationRepository.fetchConsultationQuestions(
      consultationId: event.consultationId,
    );
    if (response is GetConsultationQuestionsSucceedResponse) {
      final consultationQuestionViewModels = ConsultationQuestionsPresenter.present(response.consultationQuestions);
      emit(
        ConsultationQuestionsFetchedState(
          currentQuestionIndex: 0,
          totalQuestion: consultationQuestionViewModels.length,
          viewModels: consultationQuestionViewModels,
        ),
      );
    } else {
      emit(ConsultationQuestionsErrorState());
    }
  }

  Future<void> _handleConsultationNextQuestion(
    ConsultationNextQuestionEvent event,
    Emitter<ConsultationQuestionsState> emit,
  ) async {
    if (state is ConsultationQuestionsFetchedState) {
      final currentState = state as ConsultationQuestionsFetchedState;
      final nextQuestion = currentState.currentQuestionIndex + 1;

      if (nextQuestion == currentState.totalQuestion) {
        emit(ConsultationQuestionsFinishState());
      } else {
        emit(
          ConsultationQuestionsFetchedState(
            currentQuestionIndex: nextQuestion,
            totalQuestion: currentState.totalQuestion,
            viewModels: currentState.viewModels,
          ),
        );
      }
    }
  }

  Future<void> _handleConsultationPreviousQuestion(
    ConsultationPreviousQuestionEvent event,
    Emitter<ConsultationQuestionsState> emit,
  ) async {
    if (state is ConsultationQuestionsFetchedState) {
      final currentState = state as ConsultationQuestionsFetchedState;
      emit(
        ConsultationQuestionsFetchedState(
          currentQuestionIndex: currentState.currentQuestionIndex - 1,
          totalQuestion: currentState.totalQuestion,
          viewModels: currentState.viewModels,
        ),
      );
    }
  }
}
