import 'dart:io';

import 'package:agora/domain/qag/details/qag_details.dart';
import 'package:agora/domain/qag/qag.dart';
import 'package:agora/domain/qag/qag_response.dart';
import 'package:agora/domain/thematique/thematique.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();

  const qagId = "qagId";
  const deviceId = "deviceId";

  group("Fetch qags", () {
    test("when success should return qags", () async {
      // Given
      dioAdapter.onGet(
        "/qags",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "responses": [
              {
                "qagId": "qagId",
                "thematique": {"label": "Transports", "picto": "🚊", "color": "#FFFCF7CF"},
                "title": "Pourquoi ... ?",
                "author": "Olivier Véran",
                "authorPortraitUrl": "authorPortraitUrl",
                "responseDate": "2023-01-23"
              }
            ],
            "qags": {
              "popular": [
                {
                  "qagId": "id1",
                  "thematique": {"label": "Transports", "picto": "🚊", "color": "#FFFCF7CF"},
                  "title": "title1",
                  "username": "username1",
                  "date": "2023-01-01",
                  "support": {
                    "count": 116,
                    "isSupported": true,
                  }
                },
              ],
              "latest": [
                {
                  "qagId": "id2",
                  "thematique": {"label": "Transports", "picto": "🚊", "color": "#FFFCF7CF"},
                  "title": "title2",
                  "username": "username2",
                  "date": "2023-02-01",
                  "support": {
                    "count": 11,
                    "isSupported": false,
                  }
                },
              ],
              "supporting": [
                {
                  "qagId": "id3",
                  "thematique": {"label": "Transports", "picto": "🚊", "color": "#FFFCF7CF"},
                  "title": "title3",
                  "username": "username3",
                  "date": "2023-03-01",
                  "support": {
                    "count": 2,
                    "isSupported": true,
                  },
                }
              ],
            }
          },
        ),
        headers: {"accept": "application/json", "deviceId": deviceId},
      );

      // When
      final repository = QagDioRepository(httpClient: httpClient);
      final response = await repository.fetchQags(deviceId: deviceId);

      // Then
      expect(
        response,
        GetQagsSucceedResponse(
          qagResponses: [
            QagResponse(
              qagId: "qagId",
              thematique: Thematique(picto: "🚊", label: "Transports", color: "#FFFCF7CF"),
              title: "Pourquoi ... ?",
              author: "Olivier Véran",
              authorPortraitUrl: "authorPortraitUrl",
              responseDate: DateTime(2023, 1, 23),
            ),
          ],
          qagPopular: [
            Qag(
              id: "id1",
              thematique: Thematique(picto: "🚊", label: "Transports", color: "#FFFCF7CF"),
              title: "title1",
              username: "username1",
              date: DateTime(2023, 1, 1),
              supportCount: 116,
              isSupported: true,
            ),
          ],
          qagLatest: [
            Qag(
              id: "id2",
              thematique: Thematique(picto: "🚊", label: "Transports", color: "#FFFCF7CF"),
              title: "title2",
              username: "username2",
              date: DateTime(2023, 2, 1),
              supportCount: 11,
              isSupported: false,
            ),
          ],
          qagSupporting: [
            Qag(
              id: "id3",
              thematique: Thematique(picto: "🚊", label: "Transports", color: "#FFFCF7CF"),
              title: "title3",
              username: "username3",
              date: DateTime(2023, 3, 1),
              supportCount: 2,
              isSupported: true,
            ),
          ],
        ),
      );
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/qags",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {"accept": "application/json", "deviceId": deviceId},
      );

      // When
      final repository = QagDioRepository(httpClient: httpClient);
      final response = await repository.fetchQags(deviceId: deviceId);

      // Then
      expect(response, GetQagsFailedResponse());
    });
  });

  group("Fetch qag details", () {
    test("when success with support not null and response null should return qag details", () async {
      // Given
      dioAdapter.onGet(
        "/qags/$qagId",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "id": "qagId",
            "thematique": {"label": "Transports", "picto": "🚊", "color": "#FFFCF7CF"},
            "title": "Titre de la QaG",
            "description": "Description textuelle",
            "date": "2024-01-23",
            "username": "Henri J.",
            "support": {"count": 112, "isSupported": true},
            "response": null
          },
        ),
        headers: {"accept": "application/json", "deviceId": deviceId},
      );

      // When
      final repository = QagDioRepository(httpClient: httpClient);
      final response = await repository.fetchQagDetails(qagId: qagId, deviceId: deviceId);

      // Then
      expect(
        response,
        GetQagDetailsSucceedResponse(
          qagDetails: QagDetails(
            id: qagId,
            thematique: Thematique(picto: "🚊", label: "Transports", color: "#FFFCF7CF"),
            title: "Titre de la QaG",
            description: "Description textuelle",
            date: DateTime(2024, 1, 23),
            username: "Henri J.",
            support: QagDetailsSupport(count: 112, isSupported: true),
            response: null,
          ),
        ),
      );
    });

    test("when success with support null and response not null should return qag details", () async {
      // Given
      dioAdapter.onGet(
        "/qags/$qagId",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "id": "qagId",
            "thematique": {"label": "Transports", "picto": "🚊", "color": "#FFFCF7CF"},
            "title": "Titre de la QaG",
            "description": "Description textuelle",
            "date": "2024-01-23",
            "username": "Henri J.",
            "support": null,
            "response": {
              "author": "Olivier Véran",
              "authorDescription": "Ministre délégué auprès de...",
              "responseDate": "2024-02-20",
              "videoUrl": "https://betagouv.github.io/agora-content/QaG-Stormtrooper-Response.mp4",
              "transcription": "Blablabla",
              "feedbackStatus": true
            }
          },
        ),
        headers: {"accept": "application/json", "deviceId": deviceId},
      );

      // When
      final repository = QagDioRepository(httpClient: httpClient);
      final response = await repository.fetchQagDetails(qagId: qagId, deviceId: deviceId);

      // Then
      expect(
        response,
        GetQagDetailsSucceedResponse(
          qagDetails: QagDetails(
            id: qagId,
            thematique: Thematique(picto: "🚊", label: "Transports", color: "#FFFCF7CF"),
            title: "Titre de la QaG",
            description: "Description textuelle",
            date: DateTime(2024, 1, 23),
            username: "Henri J.",
            support: null,
            response: QagDetailsResponse(
              author: "Olivier Véran",
              authorDescription: "Ministre délégué auprès de...",
              responseDate: DateTime(2024, 2, 20),
              videoUrl: "https://betagouv.github.io/agora-content/QaG-Stormtrooper-Response.mp4",
              transcription: "Blablabla",
              feedbackStatus: true,
            ),
          ),
        ),
      );
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/qags/$qagId",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {"accept": "application/json", "deviceId": deviceId},
      );

      // When
      final repository = QagDioRepository(httpClient: httpClient);
      final response = await repository.fetchQagDetails(qagId: qagId, deviceId: deviceId);

      // Then
      expect(response, GetQagDetailsFailedResponse());
    });
  });

  group("Support qag", () {
    test("when success should return success", () async {
      // Given
      dioAdapter.onPost(
        "/qags/$qagId/support",
        (server) => server.reply(HttpStatus.ok, null),
        headers: {"accept": "application/json", "deviceId": deviceId},
      );

      // When
      final repository = QagDioRepository(httpClient: httpClient);
      final response = await repository.supportQag(qagId: qagId, deviceId: deviceId);

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
      final repository = QagDioRepository(httpClient: httpClient);
      final response = await repository.supportQag(qagId: qagId, deviceId: deviceId);

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
        headers: {"accept": "application/json", "deviceId": deviceId},
      );

      // When
      final repository = QagDioRepository(httpClient: httpClient);
      final response = await repository.deleteSupportQag(qagId: qagId, deviceId: deviceId);

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
      final repository = QagDioRepository(httpClient: httpClient);
      final response = await repository.deleteSupportQag(qagId: qagId, deviceId: deviceId);

      // Then
      expect(response, DeleteSupportQagFailedResponse());
    });
  });

  group("Give qag feedback", () {
    test("when success should return success", () async {
      // Given
      dioAdapter.onPost(
        "/qags/$qagId/feedback",
        (server) => server.reply(HttpStatus.ok, null),
        headers: {"accept": "application/json", "deviceId": deviceId},
        data: {"isHelpful": true},
      );

      // When
      final repository = QagDioRepository(httpClient: httpClient);
      final response = await repository.giveQagResponseFeedback(qagId: qagId, deviceId: deviceId, isHelpful: true);

      // Then
      expect(response, QagFeedbackSuccessResponse());
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onPost(
        "/qags/$qagId/feedback",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {"accept": "application/json"},
        data: {"isHelpful": true},
      );

      // When
      final repository = QagDioRepository(httpClient: httpClient);
      final response = await repository.giveQagResponseFeedback(qagId: qagId, deviceId: deviceId, isHelpful: true);

      // Then
      expect(response, QagFeedbackFailedResponse());
    });
  });
}
