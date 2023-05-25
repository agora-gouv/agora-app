import 'dart:io';

import 'package:agora/infrastructure/login/login_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();

  const deviceId = "deviceId";
  const fcmToken = "fcmToken";
  const loginToken = "loginToken";

  group("Signup", () {
    test("when success should return jwtToken & loginToken", () async {
      // Given
      dioAdapter.onPost(
        "/signup",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "jwtToken": "jwtToken",
            "loginToken": "loginToken",
            "isModerator": true,
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
      final response = await repository.signup(
        deviceId: deviceId,
        firebaseMessagingToken: fcmToken,
      );

      // Then
      expect(
        response,
        SignupSucceedResponse(
          jwtToken: "jwtToken",
          loginToken: "loginToken",
          isModerator: true,
        ),
      );
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onPost(
        "/signup",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "deviceId": deviceId,
          "fcmToken": fcmToken,
        },
      );

      // When
      final repository = LoginDioRepository(httpClient: httpClient);
      final response = await repository.signup(
        deviceId: deviceId,
        firebaseMessagingToken: fcmToken,
      );

      // Then
      expect(response, SignupFailedResponse());
    });
  });

  group("Login", () {
    test("when success should return jwtToken", () async {
      // Given
      dioAdapter.onPost(
        "/login",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "jwtToken": "jwtToken",
            "loginToken": "loginToken",
            "isModerator": false,
          },
        ),
        headers: {
          "accept": "application/json",
          "deviceId": deviceId,
          "fcmToken": fcmToken,
        },
        data: loginToken,
      );

      // When
      final repository = LoginDioRepository(httpClient: httpClient);
      final response = await repository.login(
        deviceId: deviceId,
        firebaseMessagingToken: fcmToken,
        loginToken: loginToken,
      );

      // Then
      expect(
        response,
        LoginSucceedResponse(
          jwtToken: "jwtToken",
          isModerator: false,
        ),
      );
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
        data: loginToken,
      );

      // When
      final repository = LoginDioRepository(httpClient: httpClient);
      final response = await repository.login(
        deviceId: deviceId,
        firebaseMessagingToken: fcmToken,
        loginToken: loginToken,
      );

      // Then
      expect(response, LoginFailedResponse());
    });
  });
}
