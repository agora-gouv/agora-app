import 'package:agora/bloc/consultation/question/response/consultation_questions_responses_event.dart';
import 'package:agora/bloc/consultation/question/response/consultation_questions_responses_state.dart';
import 'package:agora/infrastructure/consultation/consultation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationQuestionsResponsesBloc
    extends Bloc<SendConsultationQuestionsResponsesEvent, SendConsultationQuestionsResponsesState> {
  final ConsultationRepository consultationRepository;

  ConsultationQuestionsResponsesBloc({required this.consultationRepository})
      : super(SendConsultationQuestionsResponsesInitialState()) {
    on<SendConsultationQuestionsResponsesEvent>(_handleSendConsultationQuestionsResponses);
  }

  Future<void> _handleSendConsultationQuestionsResponses(
    SendConsultationQuestionsResponsesEvent event,
    Emitter<SendConsultationQuestionsResponsesState> emit,
  ) async {
    emit(SendConsultationQuestionsResponsesLoadingState());
    final response = await consultationRepository.sendConsultationResponses(
      consultationId: event.consultationId,
      questionsResponses: event.questionsResponses,
    );
    if (response is SendConsultationResponsesSucceedResponse) {
      emit(SendConsultationQuestionsResponsesSuccessState());
    } else {
      emit(SendConsultationQuestionsResponsesFailureState());
    }
  }
}
