import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_bloc.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_event.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_state.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("AddConsultationQuestionsResponseStockEvent", () {
    blocTest(
      "when add response - should update state with the new response",
      build: () => ConsultationQuestionsResponsesStockBloc(),
      act: (bloc) => bloc
        ..add(
          AddConsultationQuestionsResponseStockEvent(
            questionResponse: ConsultationQuestionResponse(questionId: "questionId", responseId: "responseId"),
          ),
        )
        ..add(
          AddConsultationQuestionsResponseStockEvent(
            questionResponse: ConsultationQuestionResponse(questionId: "questionId2", responseId: "responseId2"),
          ),
        ),
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionsResponses: [
            ConsultationQuestionResponse(questionId: "questionId", responseId: "responseId"),
          ],
        ),
        ConsultationQuestionsResponsesStockState(
          questionsResponses: [
            ConsultationQuestionResponse(questionId: "questionId", responseId: "responseId"),
            ConsultationQuestionResponse(questionId: "questionId2", responseId: "responseId2"),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("RemoveConsultationQuestionsResponseStockEvent", () {
    blocTest(
      "when remove response - should remove the last response of the state",
      build: () => ConsultationQuestionsResponsesStockBloc(),
      act: (bloc) => bloc
        ..add(
          AddConsultationQuestionsResponseStockEvent(
            questionResponse: ConsultationQuestionResponse(questionId: "questionId", responseId: "responseId"),
          ),
        )
        ..add(
          AddConsultationQuestionsResponseStockEvent(
            questionResponse: ConsultationQuestionResponse(questionId: "questionId2", responseId: "responseId2"),
          ),
        )
        ..add(RemoveConsultationQuestionsResponseStockEvent()),
      skip: 1,
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionsResponses: [
            ConsultationQuestionResponse(questionId: "questionId", responseId: "responseId"),
            ConsultationQuestionResponse(questionId: "questionId2", responseId: "responseId2"),
          ],
        ),
        ConsultationQuestionsResponsesStockState(
          questionsResponses: [
            ConsultationQuestionResponse(questionId: "questionId", responseId: "responseId"),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
