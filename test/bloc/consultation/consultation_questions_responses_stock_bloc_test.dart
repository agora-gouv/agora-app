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
            questionResponse: ConsultationQuestionResponses(
              questionId: "questionId",
              responseIds: ["responseId"],
              responseText: "",
            ),
          ),
        )
        ..add(
          AddConsultationQuestionsResponseStockEvent(
            questionResponse: ConsultationQuestionResponses(
              questionId: "questionId2",
              responseIds: [],
              responseText: "opened response",
            ),
          ),
        ),
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionsResponses: [
            ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
          ],
        ),
        ConsultationQuestionsResponsesStockState(
          questionsResponses: [
            ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
            ConsultationQuestionResponses(questionId: "questionId2", responseIds: [], responseText: "opened response"),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when add response for a specific questionId and this questionId already exists - should replace the previous one",
      build: () => ConsultationQuestionsResponsesStockBloc(),
      act: (bloc) => bloc
        ..add(
          AddConsultationQuestionsResponseStockEvent(
            questionResponse: ConsultationQuestionResponses(
              questionId: "questionId",
              responseIds: ["responseId1"],
              responseText: "",
            ),
          ),
        )
        ..add(
          AddConsultationQuestionsResponseStockEvent(
            questionResponse: ConsultationQuestionResponses(
              questionId: "questionId2",
              responseIds: [],
              responseText: "opened response",
            ),
          ),
        )
        ..add(
          AddConsultationQuestionsResponseStockEvent(
            questionResponse: ConsultationQuestionResponses(
              questionId: "questionId",
              responseIds: ["responseId2"],
              responseText: "",
            ),
          ),
        ),
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionsResponses: [
            ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId1"], responseText: ""),
          ],
        ),
        ConsultationQuestionsResponsesStockState(
          questionsResponses: [
            ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId1"], responseText: ""),
            ConsultationQuestionResponses(questionId: "questionId2", responseIds: [], responseText: "opened response"),
          ],
        ),
        ConsultationQuestionsResponsesStockState(
          questionsResponses: [
            ConsultationQuestionResponses(questionId: "questionId2", responseIds: [], responseText: "opened response"),
            ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId2"], responseText: ""),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
