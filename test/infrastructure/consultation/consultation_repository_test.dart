import 'dart:io';

import 'package:agora/domain/consultation/details/consultation_details.dart';
import 'package:agora/domain/consultation/questions/consultation_question.dart';
import 'package:agora/domain/consultation/questions/consultation_question_response_choice.dart';
import 'package:agora/domain/consultation/questions/consultation_question_type.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/domain/consultation/summary/consultation_summary.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_et_ensuite.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_results.dart';
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
            "coverUrl": "<imageByteEncodéeBase64>",
            "thematiqueId": "2",
            "endDate": "2023-03-21",
            "questionCount": "5 à 10 questions",
            "estimatedTime": "5 minutes",
            "participantCount": 15035,
            "participantCountGoal": 30000,
            "description": "La description avec textes <b>en gras</b>",
            "tipsDescription": "Qui peut aussi être du texte <i>riche</i>",
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
                "possibleChoices": [
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
                "possibleChoices": [
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
          "consultationId": consultationId,
          "responses": [
            {
              "questionId": "questionId1",
              "choiceIds": ["responseId1"],
              "responseText": "",
            },
            {
              "questionId": "questionId2",
              "choiceIds": ["responseId2"],
              "responseText": "",
            },
            {
              "questionId": "questionId3",
              "choiceIds": [],
              "responseText": "opened response",
            }
          ],
        },
      );

      // When
      final repository = ConsultationDioRepository(httpClient: httpClient);
      final response = await repository.sendConsultationResponses(
        consultationId: consultationId,
        questionsResponses: [
          ConsultationQuestionResponses(questionId: "questionId1", responseIds: ["responseId1"], responseText: ""),
          ConsultationQuestionResponses(questionId: "questionId2", responseIds: ["responseId2"], responseText: ""),
          ConsultationQuestionResponses(questionId: "questionId3", responseIds: [], responseText: "opened response"),
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
        data: {
          "consultationId": consultationId,
          "responses": [
            {
              "questionId": "questionId1",
              "choiceIds": ["responseId1"],
              "responseText": "",
            },
            {
              "questionId": "questionId2",
              "choiceIds": ["responseId2"],
              "responseText": "",
            },
            {
              "questionId": "questionId3",
              "choiceIds": [],
              "responseText": "opened response",
            }
          ],
        },
      );

      // When
      final repository = ConsultationDioRepository(httpClient: httpClient);
      final response = await repository.sendConsultationResponses(
        consultationId: consultationId,
        questionsResponses: [
          ConsultationQuestionResponses(questionId: "questionId1", responseIds: ["responseId1"], responseText: ""),
          ConsultationQuestionResponses(questionId: "questionId2", responseIds: ["responseId2"], responseText: ""),
          ConsultationQuestionResponses(questionId: "questionId3", responseIds: [], responseText: "opened response"),
        ],
      );

      // Then
      expect(response, SendConsultationResponsesFailureResponse());
    });
  });

  group("Fetch consultation summary", () {
    test("when success should return consultation questions", () async {
      // Given
      dioAdapter.onGet(
        "/consultations/$consultationId/responses",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "title": "Développer le covoiturage au quotidien",
            "participantCount": 15035,
            "results": [
              {
                "questionTitle": "Les déplacements professionnels en covoiturage",
                "responses": [
                  {
                    "label": "En voiture seul",
                    "ratio": 65,
                  },
                  {
                    "label": "Autre",
                    "ratio": 35,
                  },
                ]
              }
            ],
            "etEnsuite": {
              "step": 1, // Autres steps: 2, 3. Le reste on affiche une erreur
              "description":
                  "<body>La description avec textes <b>en gras</b> et potentiellement des <a href=\"https://google.fr\">liens</a><br/><br/><ul><li>example1 <b>en gras</b></li><li>example2</li></ul></body>",
            }
          },
        ),
        headers: {"accept": "application/json"},
      );

      // When
      final repository = ConsultationDioRepository(httpClient: httpClient);
      final response = await repository.fetchConsultationSummary(consultationId: consultationId);

      // Then
      expect(
        response,
        GetConsultationSummarySucceedResponse(
          consultationSummary: ConsultationSummary(
            title: "Développer le covoiturage au quotidien",
            participantCount: 15035,
            results: [
              ConsultationSummaryResults(
                questionTitle: "Les déplacements professionnels en covoiturage",
                responses: [
                  ConsultationSummaryResponse(label: "En voiture seul", ratio: 65),
                  ConsultationSummaryResponse(label: "Autre", ratio: 35),
                ],
              ),
            ],
            etEnsuite: ConsultationSummaryEtEnsuite(
              step: 1,
              description:
                  "<body>La description avec textes <b>en gras</b> et potentiellement des <a href=\"https://google.fr\">liens</a><br/><br/><ul><li>example1 <b>en gras</b></li><li>example2</li></ul></body>",
            ),
          ),
        ),
      );
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/consultations/$consultationId/responses",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {"accept": "application/json"},
      );

      // When
      final repository = ConsultationDioRepository(httpClient: httpClient);
      final response = await repository.fetchConsultationSummary(consultationId: consultationId);

      // Then
      expect(response, GetConsultationSummaryFailedResponse());
    });
  });
}
