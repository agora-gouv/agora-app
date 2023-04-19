import 'dart:io';

import 'package:agora/domain/qag/details/qag_details.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();

  const qagId = "qagId";
  const deviceId = "deviceId";

  group("Fetch qag details", () {
    test("when success and support is not null should return qag details", () async {
      // Given
      dioAdapter.onGet(
        "/qags/$qagId",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "id": "qagId",
            "thematiqueId": "thematiqueId",
            "title": "Titre de la QaG",
            "description": "Description textuelle",
            "date": "2024-01-23",
            "username": "Henri J.",
            "support": {"count": 112, "isSupported": true}
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
            thematiqueId: "thematiqueId",
            title: "Titre de la QaG",
            description: "Description textuelle",
            date: DateTime(2024, 1, 23),
            username: "Henri J.",
            support: QagDetailsSupport(count: 112, isSupported: true),
          ),
        ),
      );
    });

    test("when success and support is null should return qag details", () async {
      // Given
      dioAdapter.onGet(
        "/qags/$qagId",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "id": "qagId",
            "thematiqueId": "thematiqueId",
            "title": "Titre de la QaG",
            "description": "Description textuelle",
            "date": "2024-01-23",
            "username": "Henri J.",
            "support": null
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
            thematiqueId: "thematiqueId",
            title: "Titre de la QaG",
            description: "Description textuelle",
            date: DateTime(2024, 1, 23),
            username: "Henri J.",
            support: null,
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
}
