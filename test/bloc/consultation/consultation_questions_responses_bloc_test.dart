import 'package:agora/bloc/consultation/question/response/send/consultation_questions_responses_bloc.dart';
import 'package:agora/bloc/consultation/question/response/send/consultation_questions_responses_event.dart';
import 'package:agora/bloc/consultation/question/response/send/consultation_questions_responses_state.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/consultation/fakes_consultation_repository.dart';

void main() {
  group("SendConsultationQuestionsResponsesEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => ConsultationQuestionsResponsesBloc(consultationRepository: FakeConsultationSuccessRepository()),
      act: (bloc) => bloc
        ..add(
          SendConsultationQuestionsResponsesEvent(
            consultationId: "consultationId",
            questionsResponses: [
              ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
            ],
          ),
        ),
      expect: () => [
        SendConsultationQuestionsResponsesSuccessState(),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => ConsultationQuestionsResponsesBloc(consultationRepository: FakeConsultationFailureRepository()),
      act: (bloc) => bloc
        ..add(
          SendConsultationQuestionsResponsesEvent(
            consultationId: "consultationId",
            questionsResponses: [
              ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
            ],
          ),
        ),
      expect: () => [
        SendConsultationQuestionsResponsesFailureState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
