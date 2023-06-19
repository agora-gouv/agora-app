import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_bloc.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_event.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_state.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("AddConsultationQuestionsResponseStockEvent", () {
    blocTest<ConsultationQuestionsResponsesStockBloc, ConsultationQuestionsResponsesStockState>(
      "when add response - should update state with the new response",
      build: () => ConsultationQuestionsResponsesStockBloc(),
      seed: () => ConsultationQuestionsResponsesStockState(
        questionsStack: ["questionId"],
        questionsResponses: [
          ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
        ],
      ),
      act: (bloc) => bloc.add(
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
          questionsStack: ["questionId", "questionId2"],
          questionsResponses: [
            ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
            ConsultationQuestionResponses(questionId: "questionId2", responseIds: [], responseText: "opened response"),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<ConsultationQuestionsResponsesStockBloc, ConsultationQuestionsResponsesStockState>(
      "when add response for a specific questionId and this questionId already exists - should replace the previous one",
      build: () => ConsultationQuestionsResponsesStockBloc(),
      seed: () => ConsultationQuestionsResponsesStockState(
        questionsStack: ["questionId"],
        questionsResponses: [
          ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
          ConsultationQuestionResponses(questionId: "questionId2", responseIds: [], responseText: "opened response"),
        ],
      ),
      act: (bloc) => bloc.add(
        AddConsultationQuestionsResponseStockEvent(
          questionResponse: ConsultationQuestionResponses(
            questionId: "questionId2",
            responseIds: [],
            responseText: "opened response new",
          ),
        ),
      ),
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionsStack: ["questionId", "questionId2"],
          questionsResponses: [
            ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
            ConsultationQuestionResponses(
              questionId: "questionId2",
              responseIds: [],
              responseText: "opened response new",
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("AddConsultationChapterStockEvent", () {
    blocTest<ConsultationQuestionsResponsesStockBloc, ConsultationQuestionsResponsesStockState>(
      "when add chapter in stack - should update state with the new chapter",
      build: () => ConsultationQuestionsResponsesStockBloc(),
      seed: () => ConsultationQuestionsResponsesStockState(
        questionsStack: ["questionId"],
        questionsResponses: [
          ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
        ],
      ),
      act: (bloc) => bloc.add(AddConsultationChapterStockEvent(chapterId: "chapterId")),
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionsStack: ["questionId", "chapterId"],
          questionsResponses: [
            ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("RemoveConsultationQuestionEvent", () {
    blocTest<ConsultationQuestionsResponsesStockBloc, ConsultationQuestionsResponsesStockState>(
      "when remove chapter or question in stack - should update state with the new chapter",
      build: () => ConsultationQuestionsResponsesStockBloc(),
      seed: () => ConsultationQuestionsResponsesStockState(
        questionsStack: ["questionId", "chapterId"],
        questionsResponses: [
          ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
        ],
      ),
      act: (bloc) => bloc.add(RemoveConsultationQuestionEvent()),
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionsStack: ["questionId"],
          questionsResponses: [
            ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
