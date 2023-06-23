import 'dart:io';

import 'package:agora/domain/login/login_error_type.dart';
import 'package:agora/infrastructure/login/login_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/common/fake_crashlytics_helper.dart';
import '../../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();
  final fakeCrashlyticsHelper = FakeCrashlyticsHelper();

  const userId = "userId";
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
            "userId": userId,
            "jwtToken": "jwtToken",
            "loginToken": "loginToken",
            "isModerator": true,
          },
        ),
        headers: {
          "accept": "application/json",
          "fcmToken": fcmToken,
        },
      );

      // When
      final repository = LoginDioRepository(
        httpClient: httpClient,
        crashlyticsHelper: fakeCrashlyticsHelper,
      );
      final response = await repository.signup(
        firebaseMessagingToken: fcmToken,
      );

      // Then
      expect(
        response,
        SignupSucceedResponse(
          userId: userId,
          jwtToken: "jwtToken",
          loginToken: "loginToken",
          isModerator: true,
        ),
      );
    });

    test("when failure with connection timeout should return failed", () async {
      // Given
      dioAdapter.onPost(
        "/signup",
        (server) {
          server.throws(
            404,
            DioException.connectionTimeout(
              timeout: Duration(seconds: 60),
              requestOptions: RequestOptions(),
            ),
          );
        },
        headers: {
          "accept": "application/json",
          "fcmToken": fcmToken,
        },
      );

      // When
      final repository = LoginDioRepository(
        httpClient: httpClient,
        crashlyticsHelper: fakeCrashlyticsHelper,
      );
      final response = await repository.signup(
        firebaseMessagingToken: fcmToken,
      );

      // Then
      expect(response, SignupFailedResponse(errorType: LoginErrorType.timeout));
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onPost(
        "/signup",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "fcmToken": fcmToken,
        },
      );

      // When
      final repository = LoginDioRepository(
        httpClient: httpClient,
        crashlyticsHelper: fakeCrashlyticsHelper,
      );
      final response = await repository.signup(
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
          "fcmToken": fcmToken,
        },
        data: loginToken,
      );

      // When
      final repository = LoginDioRepository(
        httpClient: httpClient,
        crashlyticsHelper: fakeCrashlyticsHelper,
      );
      final response = await repository.login(
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

    test("when failure with connection timeout should return failed", () async {
      // Given
      dioAdapter.onPost(
        "/login",
        (server) {
          server.throws(
            404,
            DioException.connectionTimeout(
              timeout: Duration(seconds: 60),
              requestOptions: RequestOptions(),
            ),
          );
        },
        headers: {
          "accept": "application/json",
          "fcmToken": fcmToken,
        },
        data: loginToken,
      );

      // When
      final repository = LoginDioRepository(
        httpClient: httpClient,
        crashlyticsHelper: fakeCrashlyticsHelper,
      );
      final response = await repository.login(
        firebaseMessagingToken: fcmToken,
        loginToken: loginToken,
      );

      // Then
      expect(response, LoginFailedResponse(errorType: LoginErrorType.timeout));
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onPost(
        "/login",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "fcmToken": fcmToken,
        },
        data: loginToken,
      );

      // When
      final repository = LoginDioRepository(
        httpClient: httpClient,
        crashlyticsHelper: fakeCrashlyticsHelper,
      );
      final response = await repository.login(
        firebaseMessagingToken: fcmToken,
        loginToken: loginToken,
      );

      // Then
      expect(response, LoginFailedResponse());
    });
  });
}
