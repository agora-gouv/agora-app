import 'dart:io';

import 'package:agora/domain/qag/details/qag_details.dart';
import 'package:agora/domain/qag/header_qag.dart';
import 'package:agora/domain/qag/moderation/qag_moderation_list.dart';
import 'package:agora/domain/qag/qag.dart';
import 'package:agora/domain/qag/qag_response.dart';
import 'package:agora/domain/qag/qag_response_paginated.dart';
import 'package:agora/domain/qag/qag_similar.dart';
import 'package:agora/domain/qag/qags_error_type.dart';
import 'package:agora/domain/qag/qas_list_filter.dart';
import 'package:agora/domain/thematique/thematique.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();

  const qagId = "qagId";
  const thematiqueId = "thematiqueId";

  group("Create qag", () {
    test("when success should return success", () async {
      // Given
      dioAdapter.onPost(
        "/qags",
        (server) => server.reply(
          HttpStatus.ok,
          {"qagId": qagId},
        ),
        data: {
          "title": "qag title",
          "description": "qag description",
          "author": "qag author",
          "thematiqueId": "thematiqueId",
        },
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.createQag(
        title: "qag title",
        description: "qag description",
        author: "qag author",
        thematiqueId: thematiqueId,
      );

      // Then
      expect(response, CreateQagSucceedResponse(qagId: qagId));
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onPost(
        "/qags",
        (server) => server.reply(HttpStatus.notFound, {}),
        data: {
          "title": "qag title",
          "description": "qag description",
          "author": "qag author",
          "thematiqueId": "thematiqueId",
        },
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.createQag(
        title: "qag title",
        description: "qag description",
        author: "qag author",
        thematiqueId: thematiqueId,
      );

      // Then
      expect(response, CreateQagFailedResponse());
    });

    test("when failure by unauthorized should return failed", () async {
      // Given
      dioAdapter.onPost(
        "/qags",
        (server) => server.reply(HttpStatus.forbidden, {}),
        data: {
          "title": "qag title",
          "description": "qag description",
          "author": "qag author",
          "thematiqueId": "thematiqueId",
        },
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.createQag(
        title: "qag title",
        description: "qag description",
        author: "qag author",
        thematiqueId: thematiqueId,
      );

      // Then
      expect(response, CreateQagFailedUnauthorizedResponse());
    });
  });

  group("Fetch ask QaG status", () {
    test("when success - should return success with askQagErrorText", () async {
      // Given
      dioAdapter.onGet(
        "/qags/ask_status",
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
        (server) => server.reply(
          HttpStatus.ok,
          {"askQagErrorText": "QaG weekly limit !"},
        ),
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.fetchAskQagStatus();

      // Then
      expect(response, AskQagStatusSucceedResponse(askQagError: "QaG weekly limit !"));
    });

    test("when failure timeout - should return failed with type timeout", () async {
      // Given
      dioAdapter.onGet(
        "/qags/ask_status",
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
        (server) => server.throws(
          408,
          DioException.connectionTimeout(
            timeout: Duration(seconds: 60),
            requestOptions: RequestOptions(),
          ),
        ),
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.fetchAskQagStatus();

      // Then
      expect(response, AskQagStatusFailedResponse(errorType: QagsErrorType.timeout));
    });

    test("when failure - should return failed with type generic", () async {
      // Given
      dioAdapter.onGet(
        "/qags/ask_status",
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
        (server) => server.reply(
          HttpStatus.badRequest,
          {},
        ),
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.fetchAskQagStatus();

      // Then
      expect(response, AskQagStatusFailedResponse());
    });
  });

  group("Fetch qags list", () {
    test("when success should return qags list", () async {
      // Given
      dioAdapter.onGet(
        "/v2/qags",
        queryParameters: {
          "pageNumber": 1,
          "thematiqueId": thematiqueId,
          "filterType": "top",
        },
        (server) => server.reply(
          HttpStatus.ok,
          {
            "maxPageNumber": 5,
            "qags": [
              {
                "qagId": "id1",
                "thematique": {"label": "Transports", "picto": "🚊"},
                "title": "title1",
                "username": "username1",
                "date": "2023-01-01",
                "support": {
                  "count": 116,
                  "isSupported": true,
                },
                "isAuthor": true,
              },
            ],
            "header": {
              "headerId": "headerId",
              "title": "headerTitle",
              "message": "headerMessage",
            },
          },
        ),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.fetchQagList(
        pageNumber: 1,
        thematiqueId: thematiqueId,
        filter: QagListFilter.top,
      );

      // Then
      expect(
        response,
        GetQagListSucceedResponse(
          maxPage: 5,
          qags: [
            Qag(
              id: "id1",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: DateTime(2023, 1, 1),
              supportCount: 116,
              isSupported: true,
              isAuthor: true,
            ),
          ],
          header: HeaderQag(
            id: "headerId",
            title: "headerTitle",
            message: "headerMessage",
          ),
        ),
      );
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/v2/qags",
        queryParameters: {
          "pageNumber": 1,
          "thematiqueId": thematiqueId,
          "filterType": "top",
        },
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.fetchQagList(
        pageNumber: 1,
        thematiqueId: thematiqueId,
        filter: QagListFilter.top,
      );

      // Then
      expect(response, GetQagListFailedResponse());
    });
  });

  group("Fetch qags response", () {
    test("when success should return qags response", () async {
      // Given
      dioAdapter.onGet(
        "/qags/responses",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "incomingResponses": [
              {
                "qagId": "incomingQagId",
                "thematique": {"label": "Transports", "picto": "🚊"},
                "title": "Pourquoi nana... ?",
                "support": {
                  "count": 200,
                  "isSupported": true,
                },
                "order": 0,
                "previousMondayDate": "2024-06-03",
                "nextMondayDate": "2024-06-10",
              },
            ],
            "responses": [
              {
                "qagId": "qagId",
                "thematique": {"label": "Transports", "picto": "🚊"},
                "title": "Pourquoi ... ?",
                "author": "Olivier Véran",
                "authorPortraitUrl": "authorPortraitUrl",
                "responseDate": "2023-01-23",
                "order": 1,
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
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.fetchQagsResponse();

      // Then
      expect(
        response,
        GetQagsResponseSucceedResponse(
          qagResponsesIncoming: [
            QagResponseIncoming(
              qagId: "incomingQagId",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "Pourquoi nana... ?",
              supportCount: 200,
              isSupported: true,
              order: 0,
              dateLundiPrecedent: DateTime(2024, 6, 3),
              dateLundiSuivant: DateTime(2024, 6, 10),
            ),
          ],
          qagResponses: [
            QagResponse(
              qagId: "qagId",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "Pourquoi ... ?",
              author: "Olivier Véran",
              authorPortraitUrl: "authorPortraitUrl",
              responseDate: DateTime(2023, 1, 23),
              order: 1,
            ),
          ],
        ),
      );
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/qags/responses",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.fetchQagsResponse();

      // Then
      expect(response, GetQagsResponseFailedResponse());
    });
  });

  group("Fetch qags response paginated", () {
    test("when success should return qags response paginated", () async {
      // Given
      dioAdapter.onGet(
        "/qags/responses/1",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "maxPageNumber": 5,
            "responses": [
              {
                "qagId": "qagId",
                "thematique": {"label": "Transports", "picto": "🚊"},
                "title": "Pourquoi ... ?",
                "author": "Olivier Véran",
                "authorPortraitUrl": "authorPortraitUrl",
                "responseDate": "2023-01-23",
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
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.fetchQagsResponsePaginated(pageNumber: 1);

      // Then
      expect(
        response,
        GetQagsResponsePaginatedSucceedResponse(
          maxPage: 5,
          paginatedQagsResponse: [
            QagResponsePaginated(
              qagId: "qagId",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "Pourquoi ... ?",
              author: "Olivier Véran",
              authorPortraitUrl: "authorPortraitUrl",
              responseDate: DateTime(2023, 1, 23),
            ),
          ],
        ),
      );
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/qags/responses/1",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.fetchQagsResponsePaginated(pageNumber: 1);

      // Then
      expect(response, GetQagsResponsePaginatedFailedResponse());
    });
  });

  group("Fetch qag details", () {
    test("when success with response null should return qag details", () async {
      // Given
      dioAdapter.onGet(
        "/qags/$qagId",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "id": "qagId",
            "thematique": {"label": "Transports", "picto": "🚊"},
            "title": "Titre de la QaG",
            "description": "Description textuelle",
            "date": "2024-01-23",
            "username": "Henri J.",
            "canShare": true,
            "canSupport": true,
            "canDelete": true,
            "isAuthor": true,
            "support": {"count": 112, "isSupported": true},
            "response": null,
          },
        ),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.fetchQagDetails(qagId: qagId);

      // Then
      expect(
        response,
        GetQagDetailsSucceedResponse(
          qagDetails: QagDetails(
            id: qagId,
            thematique: Thematique(picto: "🚊", label: "Transports"),
            title: "Titre de la QaG",
            description: "Description textuelle",
            date: DateTime(2024, 1, 23),
            username: "Henri J.",
            canShare: true,
            canSupport: true,
            canDelete: true,
            isAuthor: true,
            support: QagDetailsSupport(count: 112, isSupported: true),
            response: null,
            textResponse: null,
          ),
        ),
      );
    });

    test("when success with response not null should return qag details", () async {
      // Given
      dioAdapter.onGet(
        "/qags/$qagId",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "id": "qagId",
            "thematique": {"label": "Transports", "picto": "🚊"},
            "title": "Titre de la QaG",
            "description": "Description textuelle",
            "date": "2024-01-23",
            "username": "Henri J.",
            "canShare": false,
            "canSupport": false,
            "canDelete": false,
            "isAuthor": false,
            "support": {"count": 112, "isSupported": true},
            "response": {
              "author": "Olivier Véran",
              "authorDescription": "Ministre délégué auprès de...",
              "responseDate": "2024-02-20",
              "videoUrl": "https://betagouv.github.io/agora-content/QaG-Stormtrooper-Response.mp4",
              "videoWidth": 1080,
              "videoHeight": 1920,
              "transcription": "Blablabla",
              "feedbackQuestion": 'feedbackQuestion',
              "feedbackUserResponse": true,
              "feedbackResults": {
                "positiveRatio": 95,
                "negativeRatio": 5,
                "count": 117,
              },
              "additionalInfo": {
                "title": "Information complémentaires",
                "description": "Description d'infos complémentaires",
              },
            },
            "textResponse": null,
          },
        ),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.fetchQagDetails(qagId: qagId);

      // Then
      expect(
        response,
        GetQagDetailsSucceedResponse(
          qagDetails: QagDetails(
            id: qagId,
            thematique: Thematique(picto: "🚊", label: "Transports"),
            title: "Titre de la QaG",
            description: "Description textuelle",
            date: DateTime(2024, 1, 23),
            username: "Henri J.",
            canShare: false,
            canSupport: false,
            canDelete: false,
            isAuthor: false,
            support: QagDetailsSupport(count: 112, isSupported: true),
            response: QagDetailsResponse(
              author: "Olivier Véran",
              authorDescription: "Ministre délégué auprès de...",
              responseDate: DateTime(2024, 2, 20),
              videoUrl: "https://betagouv.github.io/agora-content/QaG-Stormtrooper-Response.mp4",
              videoWidth: 1080,
              videoHeight: 1920,
              transcription: "Blablabla",
              feedbackQuestion: 'feedbackQuestion',
              feedbackUserResponse: true,
              feedbackResults: QagFeedbackResults(
                positiveRatio: 95,
                negativeRatio: 5,
                count: 117,
              ),
              additionalInfo: QagDetailsResponseAdditionalInfo(
                title: "Information complémentaires",
                description: "Description d'infos complémentaires",
              ),
            ),
            textResponse: null,
          ),
        ),
      );
    });

    test("when success with textResponse not null should return qag details", () async {
      // Given
      dioAdapter.onGet(
        "/qags/$qagId",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "id": "qagId",
            "thematique": {"label": "Transports", "picto": "🚊"},
            "title": "Titre de la QaG",
            "description": "Description textuelle",
            "date": "2024-01-23",
            "username": "Henri J.",
            "canShare": false,
            "canSupport": false,
            "canDelete": false,
            "isAuthor": false,
            "support": {"count": 112, "isSupported": true},
            "response": null,
            "textResponse": {
              "responseLabel": "Réponse d'Agora",
              "responseText": "La réponse textuelle de la part de l'équipe Agora",
              "feedbackQuestion": 'feedbackQuestion',
              "feedbackUserResponse": true,
              "feedbackResults": {
                "positiveRatio": 95,
                "negativeRatio": 5,
                "count": 117,
              },
            },
          },
        ),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.fetchQagDetails(qagId: qagId);

      // Then
      expect(
        response,
        GetQagDetailsSucceedResponse(
          qagDetails: QagDetails(
            id: qagId,
            thematique: Thematique(picto: "🚊", label: "Transports"),
            title: "Titre de la QaG",
            description: "Description textuelle",
            date: DateTime(2024, 1, 23),
            username: "Henri J.",
            canShare: false,
            canSupport: false,
            canDelete: false,
            isAuthor: false,
            support: QagDetailsSupport(count: 112, isSupported: true),
            response: null,
            textResponse: QagDetailsTextResponse(
              responseLabel: "Réponse d'Agora",
              responseText: "La réponse textuelle de la part de l'équipe Agora",
              feedbackQuestion: "feedbackQuestion",
              feedbackUserResponse: true,
              feedbackResults: QagFeedbackResults(
                positiveRatio: 95,
                negativeRatio: 5,
                count: 117,
              ),
            ),
          ),
        ),
      );
    });

    test("when failure with 423 should return qag moderated failure", () async {
      // Given
      dioAdapter.onGet(
        "/qags/$qagId",
        (server) => server.reply(HttpStatus.locked, {}),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.fetchQagDetails(qagId: qagId);

      // Then
      expect(response, GetQagDetailsModerateFailedResponse());
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/qags/$qagId",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.fetchQagDetails(qagId: qagId);

      // Then
      expect(response, GetQagDetailsFailedResponse());
    });
  });

  group("Delete qag", () {
    test("when success should return success", () async {
      // Given
      dioAdapter.onDelete(
        "/qags/$qagId",
        (server) => server.reply(HttpStatus.ok, null),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.deleteQag(qagId: qagId);

      // Then
      expect(response, DeleteQagSucceedResponse());
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onDelete(
        "/qags/$qagId",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {"accept": "application/json"},
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.deleteQag(qagId: qagId);

      // Then
      expect(response, DeleteQagFailedResponse());
    });
  });

  group("Support qag", () {
    test("when success should return success", () async {
      // Given
      dioAdapter.onPost(
        "/qags/$qagId/support",
        (server) => server.reply(HttpStatus.ok, null),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.supportQag(qagId: qagId);

      // Then
      expect(response, SupportQagSucceedResponse());
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onPost(
        "/qags/$qagId/support",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {"accept": "application/json"},
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.supportQag(qagId: qagId);

      // Then
      expect(response, SupportQagFailedResponse());
    });
  });

  group("Delete support qag", () {
    test("when success should return success", () async {
      // Given
      dioAdapter.onDelete(
        "/qags/$qagId/support",
        (server) => server.reply(HttpStatus.ok, null),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.deleteSupportQag(qagId: qagId);

      // Then
      expect(response, DeleteSupportQagSucceedResponse());
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onDelete(
        "/qags/$qagId/support",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {"accept": "application/json"},
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.deleteSupportQag(qagId: qagId);

      // Then
      expect(response, DeleteSupportQagFailedResponse());
    });
  });

  group("Give qag feedback", () {
    test("when success should return success", () async {
      // Given
      dioAdapter.onPost(
        "/qags/$qagId/feedback",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "feedbackResults": {
              "positiveRatio": 68,
              "negativeRatio": 32,
              "count": 14034,
            },
          },
        ),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
        data: {"isHelpful": true},
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.giveQagResponseFeedback(qagId: qagId, isHelpful: true);

      // Then
      expect(response, QagFeedbackSuccessBodyResponse());
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onPost(
        "/qags/$qagId/feedback",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
        data: {"isHelpful": true},
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.giveQagResponseFeedback(qagId: qagId, isHelpful: true);

      // Then
      expect(response, QagFeedbackFailedResponse());
    });
  });

  group("Fetch qag moderation list", () {
    test("when success should return qag moderation list", () async {
      // Given
      dioAdapter.onGet(
        "/moderate/qags",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "totalNumber": 120,
            "qagsToModerate": [
              {
                "id": "qagId",
                "thematique": {"label": "Transports", "picto": "🚊"},
                "title": "Titre de la QaG",
                "description": "Description textuelle",
                "date": "2024-01-23",
                "username": "Henri J.",
                "support": {"count": 112, "isSupported": true},
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
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.fetchQagModerationList();

      // Then
      expect(
        response,
        QagModerationListSuccessResponse(
          qagModerationList: QagModerationList(
            totalNumber: 120,
            qagsToModeration: [
              QagModeration(
                id: qagId,
                thematique: Thematique(picto: "🚊", label: "Transports"),
                title: "Titre de la QaG",
                description: "Description textuelle",
                date: DateTime(2024, 1, 23),
                username: "Henri J.",
                supportCount: 112,
                isSupported: true,
              ),
            ],
          ),
        ),
      );
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/moderate/qags",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.fetchQagModerationList();

      // Then
      expect(response, QagModerationListFailedResponse());
    });
  });

  group("Moderate qag", () {
    test("when success should return success", () async {
      // Given
      dioAdapter.onPut(
        "/moderate/qags/$qagId",
        (server) => server.reply(HttpStatus.ok, {}),
        data: {
          "isAccepted": true,
        },
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.moderateQag(qagId: qagId, isAccepted: true);

      // Then
      expect(response, ModerateQagSuccessResponse());
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onPut(
        "/moderate/qags/$qagId",
        (server) => server.reply(HttpStatus.notFound, {}),
        data: {
          "isAccepted": true,
        },
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.moderateQag(qagId: qagId, isAccepted: true);

      // Then
      expect(response, ModerateQagFailedResponse());
    });
  });

  group("Has similar qag", () {
    test("when success should return success", () async {
      // Given
      dioAdapter.onGet(
        "/qags/has_similar",
        (server) => server.reply(HttpStatus.ok, {"hasSimilar": true}),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
        data: {
          "title": "qag title",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.hasSimilarQag(title: "qag title");

      // Then
      expect(response, QagHasSimilarSuccessResponse(hasSimilar: true));
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/qags/has_similar",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {"accept": "application/json"},
        data: {
          "title": "qag title",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.hasSimilarQag(title: "qag title");

      // Then
      expect(response, QagHasSimilarFailedResponse());
    });
  });

  group("Similar qags", () {
    test("when success should return similar qag list", () async {
      // Given
      dioAdapter.onGet(
        "/qags/similar",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "similarQags": [
              {
                "id": qagId,
                "thematique": {"label": "Transports", "picto": "🚊"},
                "title": "Titre de la QaG",
                "description": "Description textuelle",
                "date": "2024-01-23",
                "username": "Henri J.",
                "support": {"count": 112, "isSupported": true},
              },
            ],
          },
        ),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
        data: {
          "title": "qag title",
        },
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.getSimilarQags(title: "qag title");

      // Then
      expect(
        response,
        QagSimilarSuccessResponse(
          similarQags: [
            QagSimilar(
              id: qagId,
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "Titre de la QaG",
              description: "Description textuelle",
              date: DateTime(2024, 1, 23),
              username: "Henri J.",
              supportCount: 112,
              isSupported: true,
            ),
          ],
        ),
      );
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/qags/similar",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
        data: {"title": "qag title"},
      );

      // When
      final repository = QagDioRepository(
        httpClient: httpClient,
      );
      final response = await repository.getSimilarQags(title: "qag title");

      // Then
      expect(response, QagSimilarFailedResponse());
    });
  });
}
