import 'dart:io';

import 'package:agora/domain/consultation/consultation.dart';
import 'package:agora/domain/consultation/details/consultation_details.dart';
import 'package:agora/domain/consultation/questions/consultation_question.dart';
import 'package:agora/domain/consultation/questions/consultation_question_response_choice.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/domain/consultation/summary/consultation_summary.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_et_ensuite.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_results.dart';
import 'package:agora/domain/thematique/thematique.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();

  const consultationId = "consultationId";
  const deviceId = "deviceId";

  group("Fetch consultations", () {
    test("when success should return consultations", () async {
      // Given
      dioAdapter.onGet(
        "/consultations",
        (server) => server.reply(HttpStatus.ok, {
          "ongoing": [
            {
              "id": "consultationId1",
              "title": "Développer le covoiturage",
              "coverUrl": "coverUrl1",
              "thematique": {"label": "Transports", "picto": "🚊"},
              "endDate": "2023-03-21",
              "hasAnswered": false,
            }
          ],
          "finished": [
            {
              "id": "consultationId2",
              "title": "Quelles solutions pour les déserts médicaux ?",
              "coverUrl": "coverUrl2",
              "thematique": {"label": "Santé", "picto": "🩺"},
              "step": 2
            },
          ],
          "answered": [
            {
              "id": "consultationId3",
              "title": "Quand commencer ?",
              "coverUrl": "coverUrl3",
              "thematique": {"label": "Santé", "picto": "🩺"},
              "step": 3
            },
          ]
        }),
        headers: {
          "accept": "application/json",
          "deviceId": deviceId,
        },
      );

      // When
      final repository = ConsultationDioRepository(httpClient: httpClient);
      final response = await repository.fetchConsultations(deviceId: deviceId);

      // Then
      expect(
        response,
        GetConsultationsSucceedResponse(
          ongoingConsultations: [
            ConsultationOngoing(
              id: "consultationId1",
              title: "Développer le covoiturage",
              coverUrl: "coverUrl1",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              endDate: DateTime(2023, 3, 21),
              hasAnswered: false,
            ),
          ],
          finishedConsultations: [
            ConsultationFinished(
              id: "consultationId2",
              title: "Quelles solutions pour les déserts médicaux ?",
              coverUrl: "coverUrl2",
              thematique: Thematique(picto: "🩺", label: "Santé"),
              step: 2,
            ),
          ],
          answeredConsultations: [
            ConsultationAnswered(
              id: "consultationId3",
              title: "Quand commencer ?",
              coverUrl: "coverUrl3",
              thematique: Thematique(picto: "🩺", label: "Santé"),
              step: 3,
            ),
          ],
        ),
      );
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/consultations",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "deviceId": deviceId,
        },
      );

      // When
      final repository = ConsultationDioRepository(httpClient: httpClient);
      final response = await repository.fetchConsultations(deviceId: deviceId);

      // Then
      expect(response, GetConsultationsFailedResponse());
    });
  });

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
            "coverUrl": "coverUrl",
            "thematique": {"label": "Transports", "picto": "🚊"},
            "endDate": "2023-03-21",
            "questionCount": "5 à 10 questions",
            "estimatedTime": "5 minutes",
            "participantCount": 15035,
            "participantCountGoal": 30000,
            "description": "La description avec textes <b>en gras</b>",
            "tipsDescription": "Qui peut aussi être du texte <i>riche</i>",
          },
        ),
        headers: {
          "accept": "application/json",
          "deviceId": deviceId,
        },
      );

      // When
      final repository = ConsultationDioRepository(httpClient: httpClient);
      final response = await repository.fetchConsultationDetails(
        consultationId: consultationId,
        deviceId: deviceId,
      );

      // Then
      expect(
        response,
        GetConsultationDetailsSucceedResponse(
          consultationDetails: ConsultationDetails(
            id: consultationId,
            title: "Développer le covoiturage",
            coverUrl: "coverUrl",
            thematique: Thematique(picto: "🚊", label: "Transports"),
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
        headers: {
          "accept": "application/json",
          "deviceId": deviceId,
        },
      );

      // When
      final repository = ConsultationDioRepository(httpClient: httpClient);
      final response = await repository.fetchConsultationDetails(
        consultationId: consultationId,
        deviceId: deviceId,
      );

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
            "questionsUniqueChoice": [
              {
                "id": "question1",
                "title": "quel est la fréquence d'utilisation de transport...",
                "order": 4,
                "questionProgress": "Question 3/3",
                "possibleChoices": [
                  {
                    "id": "choice1",
                    "label": "une à deux fois par semaine",
                    "order": 1,
                  }
                ],
              },
            ],
            "questionsOpened": [
              {
                "id": "question2",
                "title": "Donnez un feedback",
                "order": 3,
                "questionProgress": "Question 2/3",
              },
            ],
            "questionsMultipleChoices": [
              {
                "id": "question3",
                "title": "Quel types de transports utilisez-vous le plus ?",
                "order": 1,
                "questionProgress": "Question 1/3",
                "maxChoices": 2,
                "possibleChoices": [
                  {
                    "id": "choice1",
                    "label": "Train",
                    "order": 1,
                  },
                  {
                    "id": "choice2",
                    "label": "Tram",
                    "order": 2,
                  },
                  {
                    "id": "choice3",
                    "label": "Voiture",
                    "order": 3,
                  },
                ],
              },
            ],
            "chapters": [
              {
                "id": "chapitre1",
                "title": "titre du chapitre",
                "order": 2,
                "description": "texte riche",
              },
            ],
          },
        ),
        headers: {
          "accept": "application/json",
          "deviceId": deviceId,
        },
      );

      // When
      final repository = ConsultationDioRepository(httpClient: httpClient);
      final response = await repository.fetchConsultationQuestions(
        consultationId: consultationId,
        deviceId: deviceId,
      );

      // Then
      expect(
        response,
        GetConsultationQuestionsSucceedResponse(
          consultationQuestions: [
            ConsultationQuestionUnique(
              id: "question1",
              title: "quel est la fréquence d'utilisation de transport...",
              order: 4,
              questionProgress: "Question 3/3",
              responseChoices: [
                ConsultationQuestionResponseChoice(id: "choice1", label: "une à deux fois par semaine", order: 1),
              ],
            ),
            ConsultationQuestionOpened(
              id: "question2",
              title: "Donnez un feedback",
              order: 3,
              questionProgress: "Question 2/3",
            ),
            ConsultationQuestionMultiple(
              id: "question3",
              title: "Quel types de transports utilisez-vous le plus ?",
              order: 1,
              questionProgress: "Question 1/3",
              maxChoices: 2,
              responseChoices: [
                ConsultationQuestionResponseChoice(id: "choice1", label: "Train", order: 1),
                ConsultationQuestionResponseChoice(id: "choice2", label: "Tram", order: 2),
                ConsultationQuestionResponseChoice(id: "choice3", label: "Voiture", order: 3),
              ],
            ),
            ConsultationQuestionChapter(
              id: "chapitre1",
              title: "titre du chapitre",
              order: 2,
              description: "texte riche",
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
        headers: {
          "accept": "application/json",
          "deviceId": deviceId,
        },
      );

      // When
      final repository = ConsultationDioRepository(httpClient: httpClient);
      final response = await repository.fetchConsultationQuestions(
        consultationId: consultationId,
        deviceId: deviceId,
      );

      // Then
      expect(response, GetConsultationQuestionsFailedResponse());
    });
  });

  group("Send consultation responses", () {
    test("when success should return display demographic information", () async {
      // Given
      dioAdapter.onPost(
        "/consultations/$consultationId/responses",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "askDemographicInfo": true,
          },
        ),
        headers: {
          "accept": "application/json",
          "deviceId": deviceId,
        },
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
        deviceId: deviceId,
        questionsResponses: [
          ConsultationQuestionResponses(questionId: "questionId1", responseIds: ["responseId1"], responseText: ""),
          ConsultationQuestionResponses(questionId: "questionId2", responseIds: ["responseId2"], responseText: ""),
          ConsultationQuestionResponses(questionId: "questionId3", responseIds: [], responseText: "opened response"),
        ],
      );

      // Then
      expect(response, SendConsultationResponsesSucceedResponse(shouldDisplayDemographicInformation: true));
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onPost(
        "/consultations/$consultationId/responses",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "deviceId": deviceId,
        },
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
        deviceId: deviceId,
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
    test("when success should return consultation results", () async {
      // Given
      dioAdapter.onGet(
        "/consultations/$consultationId/responses",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "title": "Développer le covoiturage au quotidien",
            "participantCount": 15035,
            "resultsUniqueChoice": [
              {
                "questionTitle": "Les déplacements professionnels en covoiturage",
                "order": 1,
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
            "resultsMultipleChoice": [
              {
                "questionTitle": "Question B",
                "order": 2,
                "responses": [
                  {
                    "label": "Réponse A",
                    "ratio": 30,
                  },
                  {
                    "label": "Réponse B",
                    "ratio": 80,
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
        headers: {
          "accept": "application/json",
          "deviceId": deviceId,
        },
      );

      // When
      final repository = ConsultationDioRepository(httpClient: httpClient);
      final response = await repository.fetchConsultationSummary(
        consultationId: consultationId,
        deviceId: deviceId,
      );

      // Then
      expect(
        response,
        GetConsultationSummarySucceedResponse(
          consultationSummary: ConsultationSummary(
            title: "Développer le covoiturage au quotidien",
            participantCount: 15035,
            results: [
              ConsultationSummaryUniqueChoiceResults(
                questionTitle: "Les déplacements professionnels en covoiturage",
                order: 1,
                responses: [
                  ConsultationSummaryResponse(label: "En voiture seul", ratio: 65),
                  ConsultationSummaryResponse(label: "Autre", ratio: 35),
                ],
              ),
              ConsultationSummaryMultipleChoicesResults(
                questionTitle: "Question B",
                order: 2,
                responses: [
                  ConsultationSummaryResponse(label: "Réponse A", ratio: 30),
                  ConsultationSummaryResponse(label: "Réponse B", ratio: 80),
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
        headers: {
          "accept": "application/json",
          "deviceId": deviceId,
        },
      );

      // When
      final repository = ConsultationDioRepository(httpClient: httpClient);
      final response = await repository.fetchConsultationSummary(
        consultationId: consultationId,
        deviceId: deviceId,
      );

      // Then
      expect(response, GetConsultationSummaryFailedResponse());
    });
  });
}
