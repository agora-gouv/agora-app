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
            questionResponse: ConsultationQuestionResponse(
              questionId: "questionId",
              responseIds: ["responseId"],
              responseText: "",
            ),
          ),
        )
        ..add(
          AddConsultationQuestionsResponseStockEvent(
            questionResponse: ConsultationQuestionResponse(
              questionId: "questionId2",
              responseIds: [],
              responseText: "opened response",
            ),
          ),
        ),
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionsResponses: [
            ConsultationQuestionResponse(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
          ],
        ),
        ConsultationQuestionsResponsesStockState(
          questionsResponses: [
            ConsultationQuestionResponse(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
            ConsultationQuestionResponse(questionId: "questionId2", responseIds: [], responseText: "opened response"),
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
            questionResponse: ConsultationQuestionResponse(
              questionId: "questionId",
              responseIds: ["responseId"],
              responseText: "",
            ),
          ),
        )
        ..add(
          AddConsultationQuestionsResponseStockEvent(
            questionResponse: ConsultationQuestionResponse(
              questionId: "questionId2",
              responseIds: [],
              responseText: "opened response",
            ),
          ),
        )
        ..add(RemoveConsultationQuestionsResponseStockEvent()),
      skip: 1,
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionsResponses: [
            ConsultationQuestionResponse(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
            ConsultationQuestionResponse(questionId: "questionId2", responseIds: [], responseText: "opened response"),
          ],
        ),
        ConsultationQuestionsResponsesStockState(
          questionsResponses: [
            ConsultationQuestionResponse(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
