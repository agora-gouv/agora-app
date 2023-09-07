import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_event.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_state.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/pages/consultation/question/consultation_question_storage_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationQuestionsResponsesStockBloc
    extends Bloc<ConsultationQuestionsResponsesStockEvent, ConsultationQuestionsResponsesStockState> {
  final ConsultationQuestionStorageClient storageClient;

  ConsultationQuestionsResponsesStockBloc({required this.storageClient})
      : super(
          ConsultationQuestionsResponsesStockState(questionsStack: [], questionsResponses: []),
        ) {
    on<AddConsultationQuestionsResponseStockEvent>(_handleAddConsultationQuestionsStockResponse);
    on<AddConsultationChapterStockEvent>(_handleAddConsultationChapterStock);
    on<RemoveConsultationQuestionEvent>(_handleRemovePreviousConsultationQuestionInStack);
    on<RestoreSavingConsultationResponseEvent>(_handleRestoreSavingConsultationResponse);
    on<DeleteSavingConsultationResponseEvent>(_handleDeleteSavingConsultationResponse);
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

    storageClient.save(
      consultationId: event.consultationId,
      questionsStack: questionsStack,
      questionsResponses: questionsResponses,
    );

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

    storageClient.save(
      consultationId: event.consultationId,
      questionsStack: questionsStack,
      questionsResponses: state.questionsResponses,
    );

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

  Future<void> _handleRestoreSavingConsultationResponse(
    RestoreSavingConsultationResponseEvent event,
    Emitter<ConsultationQuestionsResponsesStockState> emit,
  ) async {
    final (localStack, localResponses) = await storageClient.get(event.consultationId);
    emit(
      ConsultationQuestionsResponsesStockState(
        questionsStack: localStack,
        questionsResponses: localResponses
            .map(
              (localResponse) => ConsultationQuestionResponses(
                questionId: localResponse.questionId,
                responseIds: localResponse.responseIds,
                responseText: localResponse.responseText,
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> _handleDeleteSavingConsultationResponse(
    DeleteSavingConsultationResponseEvent event,
    Emitter<ConsultationQuestionsResponsesStockState> emit,
  ) async {
    storageClient.clear(event.consultationId);
  }
}
