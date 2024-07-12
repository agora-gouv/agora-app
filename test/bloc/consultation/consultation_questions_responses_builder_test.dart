import 'package:agora/consultation/question/bloc/response/send/consultation_questions_responses_builder.dart';
import 'package:agora/consultation/question/domain/consultation_question_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("ConsultationQuestionsResponsesBuilder", () {
    test("when stack contains questionId of question response should do nothing", () async {
      // When
      final results = ConsultationQuestionsResponsesBuilder.build(
        questionIdStack: ["questionId", "questionId2"],
        questionsResponses: [
          ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
          ConsultationQuestionResponses(questionId: "questionId2", responseIds: ["responseId2"], responseText: ""),
        ],
      );

      // Then
      expect(
        results,
        [
          ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
          ConsultationQuestionResponses(questionId: "questionId2", responseIds: ["responseId2"], responseText: ""),
        ],
      );
    });

    test("when stack not contains questionId of question response should filter it", () async {
      // When
      final results = ConsultationQuestionsResponsesBuilder.build(
        questionIdStack: ["questionId"],
        questionsResponses: [
          ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
          ConsultationQuestionResponses(questionId: "questionId2", responseIds: ["responseId2"], responseText: ""),
        ],
      );

      // Then
      expect(
        results,
        [
          ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
        ],
      );
    });
  });
}
