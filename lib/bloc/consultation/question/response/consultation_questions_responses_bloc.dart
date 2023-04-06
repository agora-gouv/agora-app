import 'package:agora/bloc/consultation/question/response/consultation_questions_responses_action.dart';
import 'package:agora/bloc/consultation/question/response/consultation_questions_responses_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationQuestionsResponsesBloc
    extends Bloc<ConsultationQuestionsResponsesEvent, ConsultationQuestionsResponsesState> {
  ConsultationQuestionsResponsesBloc() : super(ConsultationQuestionsResponsesState(questionsResponses: [])) {
    on<AddConsultationQuestionsResponseEvent>(_handleAddConsultationQuestionsResponse);
    on<RemoveConsultationQuestionsResponseEvent>(_handleRemoveConsultationQuestionsResponse);
  }

  Future<void> _handleAddConsultationQuestionsResponse(
    AddConsultationQuestionsResponseEvent event,
    Emitter<ConsultationQuestionsResponsesState> emit,
  ) async {
    // [...x] clone list x
    final questionsResponses = [...state.questionsResponses];
    questionsResponses.add(event.questionResponse);
    emit(ConsultationQuestionsResponsesState(questionsResponses: questionsResponses));
  }

  Future<void> _handleRemoveConsultationQuestionsResponse(
    RemoveConsultationQuestionsResponseEvent event,
    Emitter<ConsultationQuestionsResponsesState> emit,
  ) async {
    final questionsResponses = [...state.questionsResponses];
    questionsResponses.removeLast();
    emit(ConsultationQuestionsResponsesState(questionsResponses: questionsResponses));
  }
}
