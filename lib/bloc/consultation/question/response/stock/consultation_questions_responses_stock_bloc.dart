import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_event.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_state.dart';
import 'package:agora/pages/consultation/question/consultation_question_storage_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationQuestionsResponsesStockBloc
    extends Bloc<ConsultationQuestionsResponsesStockEvent, ConsultationQuestionsResponsesStockState> {
  final ConsultationQuestionStorageClient storageClient;

  ConsultationQuestionsResponsesStockBloc({required this.storageClient})
      : super(
          ConsultationQuestionsResponsesStockState(
            questionIdStack: [],
            questionsResponses: [],
            currentQuestionId: null,
          ),
        ) {
    on<AddConsultationQuestionsResponseStockEvent>(_handleAddConsultationQuestionsStockResponse);
    on<AddConsultationChapterStockEvent>(_handleAddConsultationChapterStock);
    on<RemoveConsultationQuestionEvent>(_handleRemoveConsultationQuestion);
    on<RestoreSavingConsultationResponseEvent>(_handleRestoreSavingConsultationResponse);
    on<DeleteSavingConsultationResponseEvent>(_handleDeleteSavingConsultationResponse);
    on<ResetToLastQuestionEvent>(_handleResetToLastQuestion);
  }

  Future<void> _handleAddConsultationQuestionsStockResponse(
    AddConsultationQuestionsResponseStockEvent event,
    Emitter<ConsultationQuestionsResponsesStockState> emit,
  ) async {
    // [...x] clone list x
    final questionIdStack = [...state.questionIdStack];
    questionIdStack.add(event.questionResponse.questionId);

    final questionsResponses = [...state.questionsResponses];
    questionsResponses.removeWhere(
      (questionResponse) => questionResponse.questionId == event.questionResponse.questionId,
    );
    questionsResponses.add(event.questionResponse);

    storageClient.save(
      consultationId: event.consultationId,
      questionIdStack: questionIdStack,
      questionsResponses: questionsResponses,
      restoreQuestionId: event.nextQuestionId,
    );

    emit(
      ConsultationQuestionsResponsesStockState(
        questionIdStack: questionIdStack,
        questionsResponses: questionsResponses,
        currentQuestionId: event.nextQuestionId,
      ),
    );
  }

  Future<void> _handleAddConsultationChapterStock(
    AddConsultationChapterStockEvent event,
    Emitter<ConsultationQuestionsResponsesStockState> emit,
  ) async {
    final questionIdStack = [...state.questionIdStack];
    questionIdStack.add(event.chapterId);

    storageClient.save(
      consultationId: event.consultationId,
      questionIdStack: questionIdStack,
      questionsResponses: state.questionsResponses,
      restoreQuestionId: event.nextQuestionId,
    );

    emit(
      ConsultationQuestionsResponsesStockState(
        questionIdStack: questionIdStack,
        questionsResponses: state.questionsResponses,
        currentQuestionId: event.nextQuestionId,
      ),
    );
  }

  Future<void> _handleRemoveConsultationQuestion(
    RemoveConsultationQuestionEvent event,
    Emitter<ConsultationQuestionsResponsesStockState> emit,
  ) async {
    final questionIdStack = [...state.questionIdStack];
    if (questionIdStack.isNotEmpty) {
      final lastQuestionIdInStack = questionIdStack.removeLast();
      emit(
        ConsultationQuestionsResponsesStockState(
          questionIdStack: questionIdStack,
          questionsResponses: state.questionsResponses,
          currentQuestionId: lastQuestionIdInStack,
        ),
      );
    } else {
      emit(
        ConsultationQuestionsResponsesStockState(
          questionIdStack: [],
          questionsResponses: [],
          currentQuestionId: null,
          shouldPop: true,
        ),
      );
    }
  }

  Future<void> _handleRestoreSavingConsultationResponse(
    RestoreSavingConsultationResponseEvent event,
    Emitter<ConsultationQuestionsResponsesStockState> emit,
  ) async {
    final (localQuestionIdStack, localQuestionsResponses, restoreQuestionId) =
        await storageClient.get(event.consultationId);
    emit(
      ConsultationQuestionsResponsesStockState(
        questionIdStack: localQuestionIdStack,
        questionsResponses: localQuestionsResponses,
        currentQuestionId: restoreQuestionId,
      ),
    );
  }

  Future<void> _handleDeleteSavingConsultationResponse(
    DeleteSavingConsultationResponseEvent event,
    Emitter<ConsultationQuestionsResponsesStockState> emit,
  ) async {
    //storageClient.clear(event.consultationId);
    emit(
      ConsultationQuestionsResponsesStockState(
        questionIdStack: [],
        questionsResponses: [],
        currentQuestionId: null,
      ),
    );
  }

  Future<void> _handleResetToLastQuestion(
    ResetToLastQuestionEvent event,
    Emitter<ConsultationQuestionsResponsesStockState> emit,
  ) async {
    final questionIdStack = [...state.questionIdStack];
    final lastQuestionId = questionIdStack.removeLast();

    storageClient.save(
      consultationId: event.consultationId,
      questionIdStack: questionIdStack,
      questionsResponses: state.questionsResponses,
      restoreQuestionId: lastQuestionId,
    );

    emit(
      ConsultationQuestionsResponsesStockState(
        questionIdStack: questionIdStack,
        questionsResponses: state.questionsResponses,
        currentQuestionId: lastQuestionId,
      ),
    );
  }
}
