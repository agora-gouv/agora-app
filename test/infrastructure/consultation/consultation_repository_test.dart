import 'dart:io';

import 'package:agora/domain/consultation/consultation.dart';
import 'package:agora/domain/consultation/consultation_finished_paginated.dart';
import 'package:agora/domain/consultation/consultations_error_type.dart';
import 'package:agora/domain/consultation/dynamic/dynamic_consultation.dart';
import 'package:agora/domain/consultation/dynamic/dynamic_consultation_section.dart';
import 'package:agora/domain/consultation/questions/consultation_question.dart';
import 'package:agora/domain/consultation/questions/consultation_question_response_choice.dart';
import 'package:agora/domain/consultation/questions/consultation_questions.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/domain/consultation/summary/consultation_summary.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_et_ensuite.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_presentation.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_results.dart';
import 'package:agora/domain/thematique/thematique.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';
import 'package:agora/pages/consultation/question/consultation_question_storage_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();

  const consultationId = "consultationId";

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
              "highlightLabel": "Plus que 3 jours",
            }
          ],
          "finished": [
            {
              "id": "consultationId2",
              "title": "Quelles solutions pour les déserts médicaux ?",
              "coverUrl": "coverUrl2",
              "thematique": {"label": "Santé", "picto": "🩺"},
              "step": 2,
              "updateLabel": "label",
            },
          ],
          "answered": [
            {
              "id": "consultationId3",
              "title": "Quand commencer ?",
              "coverUrl": "coverUrl3",
              "thematique": {"label": "Santé", "picto": "🩺"},
              "step": 3,
              "updateLabel": "label",
            },
          ],
        }),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = ConsultationDioRepository(
        minimalSendingTime: Duration(milliseconds: 5),
        httpClient: httpClient,
        storageClient: MockConsultationQuestionHiveStorageClient([]),
      );
      final response = await repository.fetchConsultations();

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
              highlightLabel: "Plus que 3 jours",
            ),
          ],
          finishedConsultations: [
            ConsultationFinished(
              id: "consultationId2",
              title: "Quelles solutions pour les déserts médicaux ?",
              coverUrl: "coverUrl2",
              thematique: Thematique(picto: "🩺", label: "Santé"),
              label: 'label',
            ),
          ],
          answeredConsultations: [
            ConsultationAnswered(
              id: "consultationId3",
              title: "Quand commencer ?",
              coverUrl: "coverUrl3",
              thematique: Thematique(picto: "🩺", label: "Santé"),
              label: 'label',
            ),
          ],
        ),
      );
    });

    test("when success and highlightLabel is null should return consultations", () async {
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
              "highlightLabel": null,
            }
          ],
          "finished": [],
          "answered": [],
        }),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = ConsultationDioRepository(
        minimalSendingTime: Duration(milliseconds: 5),
        httpClient: httpClient,
        storageClient: MockConsultationQuestionHiveStorageClient([]),
      );
      final response = await repository.fetchConsultations();

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
              highlightLabel: null,
            ),
          ],
          finishedConsultations: [],
          answeredConsultations: [],
        ),
      );
    });

    test("when failure with connection timeout should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/consultations",
        (server) {
          server.throws(
            404,
            DioException.connectionTimeout(
              timeout: Duration(seconds: 60),
              requestOptions: RequestOptions(),
            ),
          );
        },
      );

      // When
      final repository = ConsultationDioRepository(
        minimalSendingTime: Duration(milliseconds: 5),
        httpClient: httpClient,
        storageClient: MockConsultationQuestionHiveStorageClient([]),
      );
      final response = await repository.fetchConsultations();

      // Then
      expect(response, GetConsultationsFailedResponse(errorType: ConsultationsErrorType.timeout));
    });

    test("when failure with receive timeout should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/consultations",
        (server) {
          server.throws(
            404,
            DioException.receiveTimeout(
              timeout: Duration(seconds: 60),
              requestOptions: RequestOptions(),
            ),
          );
        },
      );

      // When
      final repository = ConsultationDioRepository(
        minimalSendingTime: Duration(milliseconds: 5),
        httpClient: httpClient,
        storageClient: MockConsultationQuestionHiveStorageClient([]),
      );
      final response = await repository.fetchConsultations();

      // Then
      expect(response, GetConsultationsFailedResponse(errorType: ConsultationsErrorType.timeout));
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/consultations",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = ConsultationDioRepository(
        minimalSendingTime: Duration(milliseconds: 5),
        httpClient: httpClient,
        storageClient: MockConsultationQuestionHiveStorageClient([]),
      );
      final response = await repository.fetchConsultations();

      // Then
      expect(response, GetConsultationsFailedResponse());
    });
  });

  group("Fetch consultations finished paginated", () {
    const pageNumber = 1;

    test("when success should return consultations", () async {
      // Given
      dioAdapter.onGet(
        "/consultations/finished/$pageNumber",
        (server) => server.reply(HttpStatus.ok, {
          "maxPageNumber": 3,
          "consultations": [
            {
              "id": "consultationId",
              "title": "Quelles solutions pour les déserts médicaux ?",
              "coverUrl": "coverUrl",
              "thematique": {"label": "Santé", "picto": "🩺"},
              "step": 2,
              "updateLabel": "label",
            },
          ],
        }),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = ConsultationDioRepository(
        minimalSendingTime: Duration(milliseconds: 5),
        httpClient: httpClient,
        storageClient: MockConsultationQuestionHiveStorageClient([]),
      );
      final response = await repository.fetchConsultationsFinishedPaginated(pageNumber: pageNumber);

      // Then
      expect(
        response,
        GetConsultationsPaginatedSucceedResponse(
          maxPage: 3,
          consultationsPaginated: [
            ConsultationFinishedPaginated(
              id: "consultationId",
              title: "Quelles solutions pour les déserts médicaux ?",
              coverUrl: "coverUrl",
              thematique: Thematique(picto: "🩺", label: "Santé"),
              label: 'label',
            ),
          ],
        ),
      );
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/consultations/finished/$pageNumber",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = ConsultationDioRepository(
        minimalSendingTime: Duration(milliseconds: 5),
        httpClient: httpClient,
        storageClient: MockConsultationQuestionHiveStorageClient([]),
      );
      final response = await repository.fetchConsultationsFinishedPaginated(pageNumber: pageNumber);

      // Then
      expect(response, GetConsultationsFinishedPaginatedFailedResponse());
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
            "questionCount": 10,
            "questionsUniqueChoice": [
              {
                "id": "question1",
                "title": "quel est la fréquence d'utilisation de transport...",
                "order": 5,
                "questionProgress": "Question 4/4",
                "questionProgressA11y": "Question 4 sur 4",
                "possibleChoices": [
                  {
                    "id": "choice1",
                    "label": "une à deux fois par semaine",
                    "order": 1,
                    "hasOpenTextField": false,
                  },
                  {
                    "id": "choice2",
                    "label": "Autre (précisez)",
                    "order": 2,
                    "hasOpenTextField": true,
                  },
                ],
                "nextQuestionId": null,
                "popupDescription": "<body>La description avec textes <b>en gras</b></body>",
              },
            ],
            "questionsOpened": [
              {
                "id": "question2",
                "title": "Donnez un feedback",
                "order": 4,
                "questionProgress": "Question 3/4",
                "questionProgressA11y": "Question 3 sur 4",
                "nextQuestionId": "question1",
                "popupDescription": null,
              },
            ],
            "questionsMultipleChoices": [
              {
                "id": "question3",
                "title": "Quel types de transports utilisez-vous le plus ?",
                "order": 1,
                "questionProgress": "Question 1/4",
                "questionProgressA11y": "Question 1 sur 4",
                "nextQuestionId": "question6",
                "maxChoices": 2,
                "possibleChoices": [
                  {
                    "id": "choice1",
                    "label": "Train",
                    "order": 1,
                    "hasOpenTextField": false,
                  },
                  {
                    "id": "choice2",
                    "label": "Tram",
                    "order": 2,
                    "hasOpenTextField": false,
                  },
                  {
                    "id": "choice3",
                    "label": "Autre (précisez)",
                    "order": 3,
                    "hasOpenTextField": true,
                  },
                ],
                "popupDescription": "<body>La description avec textes <b>en gras</b></body>",
              },
            ],
            "questionsWithCondition": [
              {
                "id": "question6",
                "title": "Avez vous déjà fait du covoiturage ?",
                "order": 2,
                "questionProgress": "Question 2/4",
                "questionProgressA11y": "Question 2 sur 4",
                "possibleChoices": [
                  {
                    "id": "choice1",
                    "label": "Oui",
                    "order": 1,
                    "nextQuestionId": "chapitre1",
                    "hasOpenTextField": false,
                  },
                  {
                    "id": "choice2",
                    "label": "Autre (précisez)",
                    "order": 2,
                    "nextQuestionId": "chapitre1",
                    "hasOpenTextField": true,
                  },
                ],
                "popupDescription": null,
              }
            ],
            "chapters": [
              {
                "id": "chapitre1",
                "title": "titre du chapitre",
                "order": 3,
                "description": "texte riche",
                "nextQuestionId": "question2",
              },
            ],
          },
        ),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = ConsultationDioRepository(
        minimalSendingTime: Duration(milliseconds: 5),
        httpClient: httpClient,
        storageClient: MockConsultationQuestionHiveStorageClient([]),
      );
      final response = await repository.fetchConsultationQuestions(consultationId: consultationId);

      // Then
      expect(
        response,
        GetConsultationQuestionsSucceedResponse(
          consultationQuestions: ConsultationQuestions(
            questionCount: 10,
            questions: [
              ConsultationQuestionUnique(
                id: "question1",
                title: "quel est la fréquence d'utilisation de transport...",
                order: 5,
                responseChoices: [
                  ConsultationQuestionResponseChoice(
                    id: "choice1",
                    label: "une à deux fois par semaine",
                    order: 1,
                    hasOpenTextField: false,
                  ),
                  ConsultationQuestionResponseChoice(
                    id: "choice2",
                    label: "Autre (précisez)",
                    order: 2,
                    hasOpenTextField: true,
                  ),
                ],
                nextQuestionId: null,
                popupDescription: "<body>La description avec textes <b>en gras</b></body>",
              ),
              ConsultationQuestionOpened(
                id: "question2",
                title: "Donnez un feedback",
                order: 4,
                nextQuestionId: "question1",
                popupDescription: null,
              ),
              ConsultationQuestionMultiple(
                id: "question3",
                title: "Quel types de transports utilisez-vous le plus ?",
                order: 1,
                nextQuestionId: "question6",
                maxChoices: 2,
                responseChoices: [
                  ConsultationQuestionResponseChoice(id: "choice1", label: "Train", order: 1, hasOpenTextField: false),
                  ConsultationQuestionResponseChoice(id: "choice2", label: "Tram", order: 2, hasOpenTextField: false),
                  ConsultationQuestionResponseChoice(
                    id: "choice3",
                    label: "Autre (précisez)",
                    order: 3,
                    hasOpenTextField: true,
                  ),
                ],
                popupDescription: "<body>La description avec textes <b>en gras</b></body>",
              ),
              ConsultationQuestionWithCondition(
                id: "question6",
                title: "Avez vous déjà fait du covoiturage ?",
                order: 2,
                responseChoices: [
                  ConsultationQuestionResponseWithConditionChoice(
                    id: "choice1",
                    label: "Oui",
                    order: 1,
                    nextQuestionId: "chapitre1",
                    hasOpenTextField: false,
                  ),
                  ConsultationQuestionResponseWithConditionChoice(
                    id: "choice2",
                    label: "Autre (précisez)",
                    order: 2,
                    nextQuestionId: "chapitre1",
                    hasOpenTextField: true,
                  ),
                ],
                popupDescription: null,
              ),
              ConsultationQuestionChapter(
                id: "chapitre1",
                title: "titre du chapitre",
                order: 3,
                description: "texte riche",
                nextQuestionId: "question2",
              ),
            ],
          ),
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
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = ConsultationDioRepository(
        minimalSendingTime: Duration(milliseconds: 5),
        httpClient: httpClient,
        storageClient: MockConsultationQuestionHiveStorageClient([]),
      );
      final response = await repository.fetchConsultationQuestions(consultationId: consultationId);

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
          "Authorization": "Bearer jwtToken",
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
      final repository = ConsultationDioRepository(
        minimalSendingTime: Duration(milliseconds: 5),
        httpClient: httpClient,
        storageClient: MockConsultationQuestionHiveStorageClient([]),
      );
      final response = await repository.sendConsultationResponses(
        consultationId: consultationId,
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
          "Authorization": "Bearer jwtToken",
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
      final repository = ConsultationDioRepository(
        minimalSendingTime: Duration(milliseconds: 5),
        httpClient: httpClient,
        storageClient: MockConsultationQuestionHiveStorageClient([]),
      );
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
                "questionId": "question repondue",
                "order": 1,
                "responses": [
                  {
                    "choiceId": "choix utilisateur",
                    "label": "En voiture seul",
                    "ratio": 65,
                  },
                  {
                    "choiceId": "pas le choix utilisateur",
                    "label": "Autre",
                    "ratio": 35,
                  },
                ],
              }
            ],
            "resultsMultipleChoice": [
              {
                "questionTitle": "Question B",
                "questionId": "question pas repondue",
                "order": 2,
                "responses": [
                  {
                    "choiceId": "pas le choix utilisateur",
                    "label": "Réponse A",
                    "ratio": 30,
                  },
                  {
                    "choiceId": "pas le choix utilisateur",
                    "label": "Réponse B",
                    "ratio": 80,
                  },
                ],
              }
            ],
            "resultsOpen": [
              {
                "questionTitle": "Vos idées pour inciter à covoiturer ?",
                "order": 3,
              }
            ],
            "etEnsuite": {
              "step": 1, // Autres steps: 2, 3. Le reste on affiche une erreur
              "description":
                  "<body>La description avec textes <b>en gras</b> et potentiellement des <a href=\"https://google.fr\">liens</a><br/><br/><ul><li>example1 <b>en gras</b></li><li>example2</li></ul></body>",
              "explanationsTitle": "explanations title",
              "explanations": [
                {
                  "isTogglable": false,
                  "title": "toogle text title",
                  "intro": "<body>image introduction</body>",
                  "image": {
                    "url": "<imageURL>",
                    "description": "<imageDescription>",
                  },
                  "description": "<body>image description</body>",
                }
              ],
              "video": {
                "title": "video title",
                "intro": "<body>video intro</body>",
                "videoUrl": "<videoUrl>",
                "videoWidth": 1080,
                "videoHeight": 1920,
                "transcription": "transcription video",
              },
              "conclusion": {
                "title": "conclusion title",
                "description": "<body>conclusion description</body>",
              },
            },
            "presentation": {
              "startDate": "2023-08-01",
              "endDate": "2023-08-31",
              "description": "description",
              "tipsDescription": "tip description",
            },
          },
        ),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = ConsultationDioRepository(
        minimalSendingTime: Duration(milliseconds: 5),
        httpClient: httpClient,
        storageClient: MockConsultationQuestionHiveStorageClient([
          ConsultationQuestionResponses(
            questionId: "question repondue",
            responseIds: ["choix utilisateur"],
            responseText: '',
          ),
        ]),
      );
      final response = await repository.fetchConsultationSummary(consultationId: consultationId);

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
                  ConsultationSummaryResponse(label: "En voiture seul", ratio: 65, isUserResponse: true),
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
              ConsultationSummaryOpenResults(
                questionTitle: "Vos idées pour inciter à covoiturer ?",
                order: 3,
              ),
            ],
            etEnsuite: ConsultationSummaryEtEnsuite(
              step: 1,
              description:
                  "<body>La description avec textes <b>en gras</b> et potentiellement des <a href=\"https://google.fr\">liens</a><br/><br/><ul><li>example1 <b>en gras</b></li><li>example2</li></ul></body>",
              explanationsTitle: "explanations title",
              explanations: [
                ConsultationSummaryEtEnsuiteExplanation(
                  isTogglable: false,
                  title: "toogle text title",
                  intro: "<body>image introduction</body>",
                  imageUrl: "<imageURL>",
                  imageDescription: "<imageDescription>",
                  description: "<body>image description</body>",
                ),
              ],
              video: ConsultationSummaryEtEnsuiteVideo(
                title: "video title",
                intro: "<body>video intro</body>",
                videoUrl: "<videoUrl>",
                videoWidth: 1080,
                videoHeight: 1920,
                transcription: "transcription video",
              ),
              conclusion: ConsultationSummaryEtEnsuiteConclusion(
                title: "conclusion title",
                description: "<body>conclusion description</body>",
              ),
            ),
            presentation: ConsultationSummaryPresentation(
              startDate: DateTime(2023, 8, 1),
              endDate: DateTime(2023, 8, 31),
              description: "description",
              tipDescription: "tip description",
            ),
          ),
        ),
      );
    });

    test("when success with explanations title null and video null should return consultation results", () async {
      // Given
      dioAdapter.onGet(
        "/consultations/$consultationId/responses",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "title": "Développer le covoiturage au quotidien",
            "participantCount": 15035,
            "resultsUniqueChoice": [],
            "resultsMultipleChoice": [],
            "resultsOpen": [],
            "etEnsuite": {
              "step": 1, // Autres steps: 2, 3. Le reste on affiche une erreur
              "description":
                  "<body>La description avec textes <b>en gras</b> et potentiellement des <a href=\"https://google.fr\">liens</a><br/><br/><ul><li>example1 <b>en gras</b></li><li>example2</li></ul></body>",
              "explanationsTitle": null,
              "explanations": [
                {
                  "isTogglable": true,
                  "title": "toogle text title",
                  "intro": "<body>image introduction</body>",
                  "imageUrl": "<imageURL>",
                  "image": {
                    "url": "<imageURL>",
                    "description": null,
                  },
                  "description": "<body>image description</body>",
                }
              ],
              "video": null,
              "conclusion": null,
            },
            "presentation": {
              "startDate": "2023-08-01",
              "endDate": "2023-08-31",
              "description": "description",
              "tipsDescription": "tip description",
            },
          },
        ),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = ConsultationDioRepository(
        minimalSendingTime: Duration(milliseconds: 5),
        httpClient: httpClient,
        storageClient: MockConsultationQuestionHiveStorageClient([]),
      );
      final response = await repository.fetchConsultationSummary(consultationId: consultationId);

      // Then
      expect(
        response,
        GetConsultationSummarySucceedResponse(
          consultationSummary: ConsultationSummary(
            title: "Développer le covoiturage au quotidien",
            participantCount: 15035,
            results: [],
            etEnsuite: ConsultationSummaryEtEnsuite(
              step: 1,
              description:
                  "<body>La description avec textes <b>en gras</b> et potentiellement des <a href=\"https://google.fr\">liens</a><br/><br/><ul><li>example1 <b>en gras</b></li><li>example2</li></ul></body>",
              explanationsTitle: null,
              explanations: [
                ConsultationSummaryEtEnsuiteExplanation(
                  isTogglable: true,
                  title: "toogle text title",
                  intro: "<body>image introduction</body>",
                  imageUrl: "<imageURL>",
                  imageDescription: null,
                  description: "<body>image description</body>",
                ),
              ],
              video: null,
              conclusion: null,
            ),
            presentation: ConsultationSummaryPresentation(
              startDate: DateTime(2023, 8, 1),
              endDate: DateTime(2023, 8, 31),
              description: "description",
              tipDescription: "tip description",
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
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = ConsultationDioRepository(
        minimalSendingTime: Duration(milliseconds: 5),
        httpClient: httpClient,
        storageClient: MockConsultationQuestionHiveStorageClient([]),
      );
      final response = await repository.fetchConsultationSummary(consultationId: consultationId);

      // Then
      expect(response, GetConsultationSummaryFailedResponse());
    });
  });

  group("Fetch dynamic consultation", () {
    test("when success should return consultation", () async {
      // Given
      dioAdapter.onGet(
        "/v2/consultations/consultationId",
        (server) => server.reply(HttpStatus.ok, {
          "title": "Développer le covoiturage au quotidien",
          "coverUrl": "<coverUrl>",
          "thematique": {"label": "Transports", "picto": "🚊"},
          "shareText": "A définir ¯\\_(ツ)_/¯",
          "questionsInfo": {
            "endDate": "2023-12-30",
            "questionCount": "5 à 10 questions",
            "estimatedTime": "5 minutes",
            "participantCount": 15035,
            "participantCountGoal": 30000,
          },
          "consultationDates": {
            "startDate": "2023-12-30",
            "endDate": "2023-12-30",
          },
          "responsesInfo": {
            "picto": "🙌",
            "description": "<body>Texte riche</body>",
            "actionText": 'Label du bouton',
          },
          "infoHeader": {"picto": "📘", "description": "<body>Texte riche</body>"},
          "body": {
            "sectionsPreview": [
              {"type": "title", "title": "Le titre de la section"},
            ],
            "headerSections": [
              {
                "type": "focusNumber",
                "title": "30%",
                "description": "<body>Texte riche</body>",
              },
            ],
            "sections": [
              {"type": "title", "title": "Le titre de la section"},
              {"type": "richText", "description": "<body>Texte riche</body>"},
              {
                "type": "image",
                "url": "<imageUrl>",
                "contentDescription": "Description textuelle de l'image",
              },
              {
                "type": "video",
                "url": "<videoUrl>",
                "videoWidth": 1080,
                "videoHeight": 1920,
                "authorInfo": {
                  "name": "Olivier Véran",
                  "message": "Ministre de ...",
                  "date": "2023-12-30",
                },
                "transcription": "Transcription video",
              },
              {
                "type": "focusNumber",
                "title": "30%",
                "description": "<body>Texte riche</body>",
              },
              {
                "type": "accordion",
                "title": "Les économies financières",
                "sections": [
                  {
                    "type": "focusNumber",
                    "title": "30%",
                    "description": "<body>Texte riche</body>",
                  },
                ],
              },
              {
                "type": "quote",
                "description": "<body>Lorem ipsum... version riche</body>",
              },
            ],
          },
          "participationInfo": {
            "participantCount": 15035,
            "participantCountGoal": 30000,
          },
          "downloadAnalysisUrl": "<url>",
          "feedbackQuestion": {
            "updateId": "<updateId>",
            "title": "Donner votre avis",
            "picto": "💬",
            "description": "<body>Texte riche</body>",
          },
          "feedbackResults": {
            "updateId": "<updateId>",
            "title": "Donner votre avis",
            "picto": "💬",
            "description": "<body>Texte riche</body>",
            "userResponse": true,
            "positiveRatio": 68,
            "negativeRatio": 32,
            "responseCount": 14034,
          },
          "footer": {
            "title": "Envie d'aller plus loin ?",
            "description": "<body>Texte riche</body>",
          },
          "history": [
            {
              "updateId": "<updateId>",
              "type": "update",
              "status": "done",
              "title": "Lancement",
              "date": "2023-12-30",
              "actionText": "Voir les objectifs",
            }
          ],
          "goals": [
            {
              "picto": "picto",
              "description": "description",
            }
          ],
        }),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = ConsultationDioRepository(
        minimalSendingTime: Duration(milliseconds: 5),
        httpClient: httpClient,
        storageClient: MockConsultationQuestionHiveStorageClient([]),
      );
      final response = await repository.getDynamicConsultation('consultationId');

      // Then
      expect(
        response,
        DynamicConsultationSuccessResponse(
          DynamicConsultation(
            id: 'consultationId',
            title: 'Développer le covoiturage au quotidien',
            coverUrl: '<coverUrl>',
            shareText: 'A définir ¯\\_(ツ)_/¯',
            thematicLogo: '🚊',
            thematicLabel: 'Transports',
            questionsInfos: ConsultationQuestionsInfos(
              endDate: DateTime(2023, 12, 30),
              questionCount: '5 à 10 questions',
              estimatedTime: '5 minutes',
              participantCount: 15035,
              participantCountGoal: 30000,
            ),
            responseInfos: ConsultationResponseInfos(
              id: 'consultationId',
              picto: '🙌',
              description: '<body>Texte riche</body>',
              buttonLabel: 'Label du bouton',
            ),
            infoHeader: ConsultationInfoHeader(
              logo: "📘",
              description: "<body>Texte riche</body>",
            ),
            collapsedSections: [
              DynamicConsultationSectionTitle('Le titre de la section'),
            ],
            expandedSections: [
              DynamicConsultationSectionTitle('Le titre de la section'),
              DynamicConsultationSectionRichText("<body>Texte riche</body>"),
              DynamicConsultationSectionImage(
                desctiption: "Description textuelle de l'image",
                url: "<imageUrl>",
              ),
              DynamicConsultationSectionVideo(
                url: "<videoUrl>",
                transcription: 'Transcription video',
                width: 1080,
                height: 1920,
                authorName: 'Olivier Véran',
                authorDescription: 'Ministre de ...',
                date: DateTime(2023, 12, 30),
              ),
              DynamicConsultationSectionFocusNumber(
                title: '30%',
                desctiption: '<body>Texte riche</body>',
              ),
              DynamicConsultationAccordionSection('Les économies financières', [
                DynamicConsultationSectionFocusNumber(
                  title: '30%',
                  desctiption: '<body>Texte riche</body>',
                ),
              ]),
              DynamicConsultationSectionQuote('<body>Lorem ipsum... version riche</body>'),
            ],
            downloadInfo: ConsultationDownloadInfo(
              url: '<url>',
            ),
            participationInfo: ConsultationParticipationInfo(
              participantCountGoal: 30000,
              participantCount: 15035,
              shareText: 'A définir ¯\\_(ツ)_/¯',
            ),
            feedbackQuestion: ConsultationFeedbackQuestion(
              id: '<updateId>',
              title: 'Donner votre avis',
              picto: '💬',
              description: '<body>Texte riche</body>',
              userResponse: null,
            ),
            feedbackResult: ConsultationFeedbackResults(
              id: '<updateId>',
              title: 'Donner votre avis',
              picto: '💬',
              description: '<body>Texte riche</body>',
              userResponseIsPositive: true,
              positiveRatio: 68,
              negativeRatio: 32,
              responseCount: 14034,
            ),
            history: [
              ConsultationHistoryStep(
                updateId: "<updateId>",
                type: ConsultationHistoryStepType.update,
                status: ConsultationHistoryStepStatus.done,
                title: "Lancement",
                date: DateTime(2023, 12, 30),
                actionText: "Voir les objectifs",
              ),
            ],
            footer: ConsultationFooter(
              title: "Envie d'aller plus loin ?",
              description: "<body>Texte riche</body>",
            ),
            headerSections: [
              DynamicConsultationSectionFocusNumber(
                title: '30%',
                desctiption: '<body>Texte riche</body>',
              ),
            ],
            goals: [ConsultationGoal(picto: 'picto', description: 'description')],
          ),
        ),
      );
    });

    test("when failure with connection timeout should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/v2/consultations/consultationId",
        (server) {
          server.throws(
            404,
            DioException.connectionTimeout(
              timeout: Duration(seconds: 60),
              requestOptions: RequestOptions(),
            ),
          );
        },
      );

      // When
      final repository = ConsultationDioRepository(
        minimalSendingTime: Duration(milliseconds: 5),
        httpClient: httpClient,
        storageClient: MockConsultationQuestionHiveStorageClient([]),
      );
      final response = await repository.getDynamicConsultation('consultationId');

      // Then
      expect(response, DynamicConsultationErrorResponse());
    });
  });

  group("Fetch dynamic consultation response", () {
    test("when success should return consultation results", () async {
      // Given
      dioAdapter.onGet(
        "/v2/consultations/$consultationId/responses",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "title": "Développer le covoiturage au quotidien",
            "coverUrl": "coverUrl",
            "participantCount": 15035,
            "resultsUniqueChoice": [
              {
                "questionTitle": "Les déplacements professionnels en covoiturage",
                "questionId": "question repondue",
                "order": 1,
                "responses": [
                  {
                    "choiceId": "choix utilisateur",
                    "label": "En voiture seul",
                    "ratio": 65,
                  },
                  {
                    "choiceId": "pas le choix utilisateur",
                    "label": "Autre",
                    "ratio": 35,
                  },
                ],
              }
            ],
            "resultsMultipleChoice": [
              {
                "questionTitle": "Question B",
                "questionId": "question pas repondue",
                "order": 2,
                "responses": [
                  {
                    "choiceId": "pas le choix utilisateur",
                    "label": "Réponse A",
                    "ratio": 30,
                  },
                  {
                    "choiceId": "pas le choix utilisateur",
                    "label": "Réponse B",
                    "ratio": 80,
                  },
                ],
              }
            ],
            "resultsOpen": [
              {
                "questionTitle": "Vos idées pour inciter à covoiturer ?",
                "order": 3,
              }
            ],
          },
        ),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = ConsultationDioRepository(
        minimalSendingTime: Duration(milliseconds: 5),
        httpClient: httpClient,
        storageClient: MockConsultationQuestionHiveStorageClient([
          ConsultationQuestionResponses(
            questionId: "question repondue",
            responseIds: ["choix utilisateur"],
            responseText: '',
          ),
        ]),
      );
      final response = await repository.fetchDynamicConsultationResults(consultationId: consultationId);

      // Then
      expect(
        response,
        DynamicConsultationsResultsSuccessResponse(
          title: "Développer le covoiturage au quotidien",
          coverUrl: "coverUrl",
          participantCount: 15035,
          results: [
            ConsultationSummaryUniqueChoiceResults(
              questionTitle: "Les déplacements professionnels en covoiturage",
              order: 1,
              responses: [
                ConsultationSummaryResponse(label: "En voiture seul", ratio: 65, isUserResponse: true),
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
            ConsultationSummaryOpenResults(
              questionTitle: "Vos idées pour inciter à covoiturer ?",
              order: 3,
            ),
          ],
        ),
      );
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/v2/consultations/$consultationId/responses",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = ConsultationDioRepository(
        minimalSendingTime: Duration(milliseconds: 5),
        httpClient: httpClient,
        storageClient: MockConsultationQuestionHiveStorageClient([]),
      );
      final response = await repository.fetchDynamicConsultationResults(consultationId: consultationId);

      // Then
      expect(response, DynamicConsultationsResultsErrorResponse());
    });
  });

  group("Fetch dynamic consultation update", () {
    test("when success should return consultation update", () async {
      // Given
      dioAdapter.onGet(
        "/v2/consultations/consultationId/updates/updateId",
        (server) => server.reply(HttpStatus.ok, {
          "title": 'title',
          "coverUrl": 'cover',
          "thematique": {"label": "label", "picto": "logo"},
          "shareText": "A définir ¯\\_(ツ)_/¯",
          "consultationDates": {
            "startDate": "2023-12-28",
            "endDate": "2023-12-30",
          },
          "responsesInfo": {
            "picto": "🙌",
            "description": "<body>Texte riche</body>",
            "actionText": 'label',
          },
          "infoHeader": {"picto": "📘", "description": "<body>Texte riche</body>"},
          "body": {
            "sectionsPreview": [
              {"type": "title", "title": "Le titre de la section"},
            ],
            "sections": [
              {"type": "title", "title": "Le titre de la section"},
              {"type": "richText", "description": "<body>Texte riche</body>"},
              {
                "type": "image",
                "url": "<imageUrl>",
                "contentDescription": "Description textuelle de l'image",
              },
              {
                "type": "video",
                "url": "<videoUrl>",
                "videoWidth": 1080,
                "videoHeight": 1920,
                "authorInfo": {
                  "name": "Olivier Véran",
                  "message": "Ministre de ...",
                  "date": "2023-12-30",
                },
                "transcription": "Transcription video",
              },
              {
                "type": "focusNumber",
                "title": "30%",
                "description": "<body>Texte riche</body>",
              },
              {
                "type": "quote",
                "description": "<body>Lorem ipsum... version riche</body>",
              },
            ],
          },
          "participationInfo": {
            "participantCount": 15035,
            "participantCountGoal": 30000,
          },
          "downloadAnalysisUrl": "<url>",
          "feedbackQuestion": {
            "updateId": "<updateId>",
            "title": "Donner votre avis",
            "picto": "💬",
            "description": "<body>Texte riche</body>",
          },
          "feedbackResults": {
            "updateId": "<updateId>",
            "title": "Donner votre avis",
            "picto": "💬",
            "description": "<body>Texte riche</body>",
            "userResponse": true,
            "positiveRatio": 68,
            "negativeRatio": 32,
            "responseCount": 14034,
          },
          "footer": {
            "title": "Envie d'aller plus loin ?",
            "description": "<body>Texte riche</body>",
          },
          "history": [
            {
              "updateId": "<updateId>",
              "type": "update",
              "status": "done",
              "title": "Lancement",
              "date": "2023-12-30",
              "actionText": "Voir les objectifs",
            }
          ],
        }),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = ConsultationDioRepository(
        minimalSendingTime: Duration(milliseconds: 5),
        httpClient: httpClient,
        storageClient: MockConsultationQuestionHiveStorageClient([]),
      );
      final response = await repository.fetchDynamicConsultationUpdate(
        consultationId: 'consultationId',
        updateId: 'updateId',
      );

      // Then
      expect(
        response,
        DynamicConsultationUpdateSuccessResponse(
          DynamicConsultationUpdate(
            id: 'consultationId',
            shareText: 'A définir ¯\\_(ツ)_/¯',
            consultationDatesInfos: ConsultationDatesInfos(
              endDate: DateTime(2023, 12, 30),
              startDate: DateTime(2023, 12, 28),
            ),
            responseInfos: ConsultationResponseInfos(
              id: 'consultationId',
              picto: '🙌',
              description: '<body>Texte riche</body>',
              buttonLabel: 'label',
            ),
            infoHeader: ConsultationInfoHeader(
              logo: "📘",
              description: "<body>Texte riche</body>",
            ),
            previewSections: [
              DynamicConsultationSectionTitle('Le titre de la section'),
            ],
            expandedSections: [
              DynamicConsultationSectionTitle('Le titre de la section'),
              DynamicConsultationSectionRichText("<body>Texte riche</body>"),
              DynamicConsultationSectionImage(
                desctiption: "Description textuelle de l'image",
                url: "<imageUrl>",
              ),
              DynamicConsultationSectionVideo(
                url: "<videoUrl>",
                transcription: 'Transcription video',
                width: 1080,
                height: 1920,
                authorName: 'Olivier Véran',
                authorDescription: 'Ministre de ...',
                date: DateTime(2023, 12, 30),
              ),
              DynamicConsultationSectionFocusNumber(
                title: '30%',
                desctiption: '<body>Texte riche</body>',
              ),
              DynamicConsultationSectionQuote('<body>Lorem ipsum... version riche</body>'),
            ],
            downloadInfo: ConsultationDownloadInfo(
              url: '<url>',
            ),
            participationInfo: ConsultationParticipationInfo(
              participantCountGoal: 30000,
              participantCount: 15035,
              shareText: 'A définir ¯\\_(ツ)_/¯',
            ),
            feedbackQuestion: ConsultationFeedbackQuestion(
              id: '<updateId>',
              title: 'Donner votre avis',
              picto: '💬',
              description: '<body>Texte riche</body>',
              userResponse: null,
            ),
            feedbackResult: ConsultationFeedbackResults(
              id: '<updateId>',
              title: 'Donner votre avis',
              picto: '💬',
              description: '<body>Texte riche</body>',
              userResponseIsPositive: true,
              positiveRatio: 68,
              negativeRatio: 32,
              responseCount: 14034,
            ),
            footer: ConsultationFooter(
              title: "Envie d'aller plus loin ?",
              description: "<body>Texte riche</body>",
            ),
            title: 'title',
            coverUrl: 'cover',
            thematicLogo: 'logo',
            thematicLabel: 'label',
            headerSections: [],
            goals: null,
          ),
        ),
      );
    });

    test("when failure with connection timeout should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/v2/consultations/consultationId/updates/updateId",
        (server) {
          server.throws(
            404,
            DioException.connectionTimeout(
              timeout: Duration(seconds: 60),
              requestOptions: RequestOptions(),
            ),
          );
        },
      );

      // When
      final repository = ConsultationDioRepository(
        minimalSendingTime: Duration(milliseconds: 5),
        httpClient: httpClient,
        storageClient: MockConsultationQuestionHiveStorageClient([]),
      );
      final response = await repository.fetchDynamicConsultationUpdate(
        consultationId: 'consultationId',
        updateId: 'updateId',
      );

      // Then
      expect(response, DynamicConsultationUpdateErrorResponse());
    });
  });
}

class MockConsultationQuestionHiveStorageClient extends ConsultationQuestionStorageClient {
  final List<ConsultationQuestionResponses> response;

  MockConsultationQuestionHiveStorageClient(this.response);

  @override
  Future<void> clear(String consultationId) {
    throw UnimplementedError();
  }

  @override
  Future<(List<String>, List<ConsultationQuestionResponses>, String?)> get(String consultationId) async {
    return (<String>[], response, null);
  }

  @override
  Future<void> save({
    required String consultationId,
    required List<String> questionIdStack,
    required List<ConsultationQuestionResponses> questionsResponses,
    required String? restoreQuestionId,
  }) {
    throw UnimplementedError();
  }
}
