import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_event.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationQuestionsResponsesStockBloc
    extends Bloc<ConsultationQuestionsResponsesStockEvent, ConsultationQuestionsResponsesStockState> {
  ConsultationQuestionsResponsesStockBloc() : super(ConsultationQuestionsResponsesStockState(questionsResponses: [])) {
    on<AddConsultationQuestionsResponseStockEvent>(_handleAddConsultationQuestionsStockResponse);
  }

  Future<void> _handleAddConsultationQuestionsStockResponse(
    AddConsultationQuestionsResponseStockEvent event,
    Emitter<ConsultationQuestionsResponsesStockState> emit,
  ) async {
    // [...x] clone list x
    final questionsResponses = [...state.questionsResponses];
    questionsResponses.removeWhere(
      (questionResponse) => questionResponse.questionId == event.questionResponse.questionId,
    );
    questionsResponses.add(event.questionResponse);
    emit(ConsultationQuestionsResponsesStockState(questionsResponses: questionsResponses));
  }
}
