import 'package:agora/consultation/question/bloc/consultation_questions_event.dart';
import 'package:agora/consultation/bloc/consultation_questions_state.dart';
import 'package:agora/consultation/repository/consultation_questions_presenter.dart';
import 'package:agora/consultation/repository/consultation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationQuestionsBloc extends Bloc<FetchConsultationQuestionsEvent, ConsultationQuestionsState> {
  final ConsultationRepository consultationRepository;

  ConsultationQuestionsBloc({
    required this.consultationRepository,
  }) : super(ConsultationQuestionsInitialLoadingState()) {
    on<FetchConsultationQuestionsEvent>(_handleConsultationQuestions);
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
      emit(ConsultationQuestionsFetchedState(consultationQuestionsViewModel: consultationQuestionViewModels));
    } else {
      emit(ConsultationQuestionsErrorState());
    }
  }
}
