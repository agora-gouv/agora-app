import 'package:agora/bloc/consultation/question/response/send/consultation_questions_responses_builder.dart';
import 'package:agora/bloc/consultation/question/response/send/consultation_questions_responses_event.dart';
import 'package:agora/bloc/consultation/question/response/send/consultation_questions_responses_state.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationQuestionsResponsesBloc
    extends Bloc<SendConsultationQuestionsResponsesEvent, SendConsultationQuestionsResponsesState> {
  final ConsultationRepository consultationRepository;

  ConsultationQuestionsResponsesBloc({
    required this.consultationRepository,
  }) : super(SendConsultationQuestionsResponsesInitialLoadingState()) {
    on<SendConsultationQuestionsResponsesEvent>(_handleSendConsultationQuestionsResponses);
  }

  Future<void> _handleSendConsultationQuestionsResponses(
    SendConsultationQuestionsResponsesEvent event,
    Emitter<SendConsultationQuestionsResponsesState> emit,
  ) async {
    final questionResponses = ConsultationQuestionsResponsesBuilder.build(
      questionIdStack: event.questionIdStack,
      questionsResponses: event.questionsResponses,
    );

    final response = await consultationRepository.sendConsultationResponses(
      consultationId: event.consultationId,
      questionsResponses: questionResponses,
    );
    if (response is SendConsultationResponsesSucceedResponse) {
      emit(
        SendConsultationQuestionsResponsesSuccessState(
          shouldDisplayDemographicInformation: response.shouldDisplayDemographicInformation,
        ),
      );
    } else {
      emit(SendConsultationQuestionsResponsesFailureState());
    }
  }
}
