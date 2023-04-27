import 'dart:io';

import 'package:agora/infrastructure/login/login_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();

  const deviceId = "deviceId";
  const fcmToken = "fcmToken";

  group("Login", () {
    test("when success should return userId", () async {
      // Given
      dioAdapter.onPost(
        "/login",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "userId": "userId",
          },
        ),
        headers: {
          "accept": "application/json",
          "deviceId": deviceId,
          "fcmToken": fcmToken,
        },
      );

      // When
      final repository = LoginDioRepository(httpClient: httpClient);
      final response = await repository.login(
        deviceId: deviceId,
        firebaseMessagingToken: fcmToken,
      );

      // Then
      expect(response, LoginSucceedResponse(userId: "userId"));
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onPost(
        "/login",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "deviceId": deviceId,
          "fcmToken": fcmToken,
        },
      );

      // When
      final repository = LoginDioRepository(httpClient: httpClient);
      final response = await repository.login(
        deviceId: deviceId,
        firebaseMessagingToken: fcmToken,
      );

      // Then
      expect(response, LoginFailedResponse());
    });
  });
}
