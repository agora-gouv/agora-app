import 'package:agora/bloc/consultation/question/response/consultation_questions_responses_action.dart';
import 'package:agora/bloc/consultation/question/response/consultation_questions_responses_bloc.dart';
import 'package:agora/bloc/consultation/question/response/consultation_questions_responses_state.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("AddConsultationQuestionsResponseEvent", () {
    blocTest(
      "when add response - should update state with the new response",
      build: () => ConsultationQuestionsResponsesBloc(),
      act: (bloc) => bloc
        ..add(
          AddConsultationQuestionsResponseEvent(
            questionResponse: ConsultationQuestionResponse(questionId: "questionId", responseId: "responseId"),
          ),
        )
        ..add(
          AddConsultationQuestionsResponseEvent(
            questionResponse: ConsultationQuestionResponse(questionId: "questionId2", responseId: "responseId2"),
          ),
        ),
      expect: () => [
        ConsultationQuestionsResponsesState(
          questionsResponses: [
            ConsultationQuestionResponse(questionId: "questionId", responseId: "responseId"),
          ],
        ),
        ConsultationQuestionsResponsesState(
          questionsResponses: [
            ConsultationQuestionResponse(questionId: "questionId", responseId: "responseId"),
            ConsultationQuestionResponse(questionId: "questionId2", responseId: "responseId2"),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when remove response - should remove the last response of the state",
      build: () => ConsultationQuestionsResponsesBloc(),
      act: (bloc) => bloc
        ..add(
          AddConsultationQuestionsResponseEvent(
            questionResponse: ConsultationQuestionResponse(questionId: "questionId", responseId: "responseId"),
          ),
        )
        ..add(
          AddConsultationQuestionsResponseEvent(
            questionResponse: ConsultationQuestionResponse(questionId: "questionId2", responseId: "responseId2"),
          ),
        )
        ..add(RemoveConsultationQuestionsResponseEvent()),
      skip: 1,
      expect: () => [
        ConsultationQuestionsResponsesState(
          questionsResponses: [
            ConsultationQuestionResponse(questionId: "questionId", responseId: "responseId"),
            ConsultationQuestionResponse(questionId: "questionId2", responseId: "responseId2"),
          ],
        ),
        ConsultationQuestionsResponsesState(
          questionsResponses: [
            ConsultationQuestionResponse(questionId: "questionId", responseId: "responseId"),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
