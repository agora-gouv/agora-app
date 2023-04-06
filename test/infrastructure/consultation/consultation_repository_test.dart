import 'dart:io';

import 'package:agora/domain/consultation/details/consultation_details.dart';
import 'package:agora/domain/consultation/questions/consultation_question.dart';
import 'package:agora/domain/consultation/questions/consultation_question_response_choice.dart';
import 'package:agora/domain/consultation/questions/consultation_question_type.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/infrastructure/consultation/consultation_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();

  const consultationId = "consultationId";

  group("Fetch consultation details", () {
    test("when success should return consultation details", () async {
      // Given
      dioAdapter.onGet(
        "/consultations/$consultationId",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "id": consultationId,
            "title": "Développer le covoiturage",
            "cover": "<imageByteEncodéeBase64>",
            "thematique_id": "2",
            "end_date": "2023-03-21",
            "question_count": "5 à 10 questions",
            "estimated_time": "5 minutes",
            "participant_count": 15035,
            "participant_count_goal": 30000,
            "description": "La description avec textes <b>en gras</b>",
            "tips_description": "Qui peut aussi être du texte <i>riche</i>",
          },
        ),
        headers: {"accept": "application/json"},
      );

      // When
      final repository = ConsultationDioRepository(httpClient: httpClient);
      final response = await repository.fetchConsultationDetails(consultationId: consultationId);

      // Then
      expect(
        response,
        GetConsultationDetailsSucceedResponse(
          consultationDetails: ConsultationDetails(
            id: consultationId,
            title: "Développer le covoiturage",
            cover: "<imageByteEncodéeBase64>",
            thematiqueId: "2",
            endDate: DateTime(2023, 3, 21),
            questionCount: "5 à 10 questions",
            estimatedTime: "5 minutes",
            participantCount: 15035,
            participantCountGoal: 30000,
            description: "La description avec textes <b>en gras</b>",
            tipsDescription: "Qui peut aussi être du texte <i>riche</i>",
          ),
        ),
      );
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/consultations/$consultationId",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {"accept": "application/json"},
      );

      // When
      final repository = ConsultationDioRepository(httpClient: httpClient);
      final response = await repository.fetchConsultationDetails(consultationId: consultationId);

      // Then
      expect(response, GetConsultationDetailsFailedResponse());
    });
  });

  group("Fetch consultation questions", () {
    test("when success should return consultation questions", () async {
      // Given
      dioAdapter.onGet(
        "/consultations/$consultationId/questions",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "questions": [
              {
                "id": "questionIdB",
                "label": "Si vous vous lancez dans le co-voiturage, vous pouvez bénéficier d’une prime de 100 euros...",
                "order": 2,
                "type": "unique",
                "possible_choices": [
                  {
                    "id": "choiceAA",
                    "label": "non",
                    "order": 2,
                  },
                  {
                    "id": "choiceBB",
                    "label": "oui",
                    "order": 1,
                  }
                ]
              },
              {
                "id": "questionIdA",
                "label": "Comment vous rendez-vous généralement sur votre lieu de travail ?",
                "order": 1,
                "type": "unique",
                "possible_choices": [
                  {
                    "id": "choiceA",
                    "label": "En vélo ou à pied",
                    "order": 3,
                  },
                  {
                    "id": "choiceB",
                    "label": "En transports en commun",
                    "order": 2,
                  },
                  {
                    "id": "choiceC",
                    "label": "En voiture, seul(e)",
                    "order": 1,
                  }
                ]
              },
            ]
          },
        ),
        headers: {"accept": "application/json"},
      );

      // When
      final repository = ConsultationDioRepository(httpClient: httpClient);
      final response = await repository.fetchConsultationQuestions(consultationId: consultationId);

      // Then
      expect(
        response,
        GetConsultationQuestionsSucceedResponse(
          consultationQuestions: [
            ConsultationQuestion(
              id: "questionIdB",
              label: "Si vous vous lancez dans le co-voiturage, vous pouvez bénéficier d’une prime de 100 euros...",
              order: 2,
              type: ConsultationQuestionType.unique,
              responseChoices: [
                ConsultationQuestionResponseChoice(id: "choiceAA", label: "non", order: 2),
                ConsultationQuestionResponseChoice(id: "choiceBB", label: "oui", order: 1),
              ],
            ),
            ConsultationQuestion(
              id: "questionIdA",
              label: "Comment vous rendez-vous généralement sur votre lieu de travail ?",
              order: 1,
              type: ConsultationQuestionType.unique,
              responseChoices: [
                ConsultationQuestionResponseChoice(id: "choiceA", label: "En vélo ou à pied", order: 3),
                ConsultationQuestionResponseChoice(id: "choiceB", label: "En transports en commun", order: 2),
                ConsultationQuestionResponseChoice(id: "choiceC", label: "En voiture, seul(e)", order: 1),
              ],
            ),
          ],
        ),
      );
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/consultations/$consultationId/questions",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {"accept": "application/json"},
      );

      // When
      final repository = ConsultationDioRepository(httpClient: httpClient);
      final response = await repository.fetchConsultationQuestions(consultationId: consultationId);

      // Then
      expect(response, GetConsultationQuestionsFailedResponse());
    });
  });

  group("Send consultation responses", () {
    test("when success should return consultation questions", () async {
      // Given
      dioAdapter.onPost(
        "/consultations/$consultationId/responses",
        (server) => server.reply(HttpStatus.ok, {}),
        headers: {"accept": "application/json"},
        data: {
          "id_consultation": consultationId,
          "responses": [
            {
              "id_question": "questionId1",
              "id_choice": ["responseId1"],
              "response_text": "",
            },
            {
              "id_question": "questionId2",
              "id_choice": ["responseId2"],
              "response_text": "",
            },
            {
              "id_question": "questionId3",
              "id_choice": ["responseId3"],
              "response_text": "",
            }
          ],
        },
      );

      // When
      final repository = ConsultationDioRepository(httpClient: httpClient);
      final response = await repository.sendConsultationResponses(
        consultationId: consultationId,
        questionsResponses: [
          ConsultationQuestionResponse(questionId: "questionId1", responseId: "responseId1"),
          ConsultationQuestionResponse(questionId: "questionId2", responseId: "responseId2"),
          ConsultationQuestionResponse(questionId: "questionId3", responseId: "responseId3"),
        ],
      );

      // Then
      expect(response, SendConsultationResponsesSucceedResponse());
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onPost(
        "/consultations/$consultationId/responses",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {"accept": "application/json"},
        data: {},
      );

      // When
      final repository = ConsultationDioRepository(httpClient: httpClient);
      final response = await repository.sendConsultationResponses(
        consultationId: consultationId,
        questionsResponses: [
          ConsultationQuestionResponse(questionId: "questionId1", responseId: "questionId1"),
          ConsultationQuestionResponse(questionId: "questionId2", responseId: "questionId2"),
          ConsultationQuestionResponse(questionId: "questionId3", responseId: "questionId3"),
        ],
      );

      // Then
      expect(response, SendConsultationResponsesFailureResponse());
    });
  });
}
