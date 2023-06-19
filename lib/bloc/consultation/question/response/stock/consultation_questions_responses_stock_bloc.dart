import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_event.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationQuestionsResponsesStockBloc
    extends Bloc<ConsultationQuestionsResponsesStockEvent, ConsultationQuestionsResponsesStockState> {
  ConsultationQuestionsResponsesStockBloc()
      : super(ConsultationQuestionsResponsesStockState(questionsStack: [], questionsResponses: [])) {
    on<AddConsultationQuestionsResponseStockEvent>(_handleAddConsultationQuestionsStockResponse);
    on<AddConsultationChapterStockEvent>(_handleAddConsultationChapterStock);
    on<RemoveConsultationQuestionEvent>(_handleRemovePreviousConsultationQuestionInStack);
  }

  Future<void> _handleAddConsultationQuestionsStockResponse(
    AddConsultationQuestionsResponseStockEvent event,
    Emitter<ConsultationQuestionsResponsesStockState> emit,
  ) async {
    // [...x] clone list x
    final questionsStack = [...state.questionsStack];
    questionsStack.add(event.questionResponse.questionId);

    final questionsResponses = [...state.questionsResponses];
    questionsResponses.removeWhere(
      (questionResponse) => questionResponse.questionId == event.questionResponse.questionId,
    );
    questionsResponses.add(event.questionResponse);

    emit(
      ConsultationQuestionsResponsesStockState(
        questionsStack: questionsStack,
        questionsResponses: questionsResponses,
      ),
    );
  }

  Future<void> _handleAddConsultationChapterStock(
    AddConsultationChapterStockEvent event,
    Emitter<ConsultationQuestionsResponsesStockState> emit,
  ) async {
    final questionsStack = [...state.questionsStack];
    questionsStack.add(event.chapterId);

    emit(
      ConsultationQuestionsResponsesStockState(
        questionsStack: questionsStack,
        questionsResponses: state.questionsResponses,
      ),
    );
  }

  Future<void> _handleRemovePreviousConsultationQuestionInStack(
    RemoveConsultationQuestionEvent event,
    Emitter<ConsultationQuestionsResponsesStockState> emit,
  ) async {
    final questionsStack = [...state.questionsStack];
    questionsStack.removeLast();

    emit(
      ConsultationQuestionsResponsesStockState(
        questionsStack: questionsStack,
        questionsResponses: state.questionsResponses,
      ),
    );
  }
}
