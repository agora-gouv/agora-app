import 'dart:io';

import 'package:agora/common/log/sentry_wrapper.dart';
import 'package:agora/login/domain/login_error_type.dart';
import 'package:agora/login/repository/login_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();
  final sentryWrapper = SentryWrapper();

  const userId = "userId";
  const fcmToken = "fcmToken";
  const loginToken = "loginToken";
  const appVersion = "1.0.0";
  const buildNumber = "10";
  const platformNameAndroid = "android";
  const platformNameIos = "ios";
  const platformNameWeb = "web";

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
            "jwtExpirationEpochMilli": 1234567890,
          },
        ),
        headers: {
          "accept": "application/json",
          "fcmToken": fcmToken,
          "versionName": appVersion,
          "versionCode": buildNumber,
          "platform": platformNameAndroid,
        },
      );

      // When
      final repository = LoginDioRepository(
        httpClient: httpClient,
        sentryWrapper: sentryWrapper,
      );
      final response = await repository.signup(
        firebaseMessagingToken: fcmToken,
        appVersion: appVersion,
        buildNumber: buildNumber,
        platformName: platformNameAndroid,
      );

      // Then
      expect(
        response,
        SignupSucceedResponse(
          userId: userId,
          jwtToken: "jwtToken",
          loginToken: "loginToken",
          isModerator: true,
          jwtExpirationEpochMilli: 1234567890,
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
          "versionName": appVersion,
          "versionCode": buildNumber,
          "platform": platformNameIos,
        },
      );

      // When
      final repository = LoginDioRepository(
        httpClient: httpClient,
        sentryWrapper: sentryWrapper,
      );
      final response = await repository.signup(
        firebaseMessagingToken: fcmToken,
        appVersion: appVersion,
        buildNumber: buildNumber,
        platformName: platformNameIos,
      );

      // Then
      expect(response, SignupFailedResponse(errorType: LoginErrorType.timeout));
    });

    test("when failure with 412 should return update app error", () async {
      // Given
      dioAdapter.onPost(
        "/signup",
        (server) => server.reply(HttpStatus.preconditionFailed, {}),
        headers: {
          "accept": "application/json",
          "fcmToken": fcmToken,
          "versionName": appVersion,
          "versionCode": buildNumber,
          "platform": platformNameWeb,
        },
      );

      // When
      final repository = LoginDioRepository(
        httpClient: httpClient,
        sentryWrapper: sentryWrapper,
      );
      final response = await repository.signup(
        firebaseMessagingToken: fcmToken,
        appVersion: appVersion,
        buildNumber: buildNumber,
        platformName: platformNameWeb,
      );

      // Then
      expect(response, SignupFailedResponse(errorType: LoginErrorType.updateVersion));
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onPost(
        "/signup",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "fcmToken": fcmToken,
          "versionName": appVersion,
          "versionCode": buildNumber,
          "platform": platformNameWeb,
        },
      );

      // When
      final repository = LoginDioRepository(
        httpClient: httpClient,
        sentryWrapper: sentryWrapper,
      );
      final response = await repository.signup(
        firebaseMessagingToken: fcmToken,
        appVersion: appVersion,
        buildNumber: buildNumber,
        platformName: platformNameWeb,
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
            "jwtExpirationEpochMilli": 1234567890,
          },
        ),
        headers: {
          "accept": "application/json",
          "fcmToken": fcmToken,
          "versionName": appVersion,
          "versionCode": buildNumber,
          "platform": platformNameWeb,
        },
        data: {
          "loginToken": loginToken,
        },
      );

      // When
      final repository = LoginDioRepository(
        httpClient: httpClient,
        sentryWrapper: sentryWrapper,
      );
      final response = await repository.login(
        firebaseMessagingToken: fcmToken,
        loginToken: loginToken,
        appVersion: appVersion,
        buildNumber: buildNumber,
        platformName: platformNameWeb,
      );

      // Then
      expect(
        response,
        LoginSucceedResponse(
          jwtToken: "jwtToken",
          isModerator: false,
          jwtExpirationEpochMilli: 1234567890,
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
          "versionName": appVersion,
          "versionCode": buildNumber,
          "platform": platformNameWeb,
        },
        data: {
          "loginToken": loginToken,
        },
      );

      // When
      final repository = LoginDioRepository(
        httpClient: httpClient,
        sentryWrapper: sentryWrapper,
      );
      final response = await repository.login(
        firebaseMessagingToken: fcmToken,
        loginToken: loginToken,
        appVersion: appVersion,
        buildNumber: buildNumber,
        platformName: platformNameWeb,
      );

      // Then
      expect(response, LoginFailedResponse(errorType: LoginErrorType.timeout));
    });

    test("when failure with 412 should return update app error", () async {
      // Given
      dioAdapter.onPost(
        "/login",
        (server) => server.reply(HttpStatus.preconditionFailed, {}),
        headers: {
          "accept": "application/json",
          "fcmToken": fcmToken,
          "versionName": appVersion,
          "versionCode": buildNumber,
          "platform": platformNameWeb,
        },
        data: {
          "loginToken": loginToken,
        },
      );

      // When
      final repository = LoginDioRepository(
        httpClient: httpClient,
        sentryWrapper: sentryWrapper,
      );
      final response = await repository.login(
        firebaseMessagingToken: fcmToken,
        loginToken: loginToken,
        appVersion: appVersion,
        buildNumber: buildNumber,
        platformName: platformNameWeb,
      );

      // Then
      expect(response, LoginFailedResponse(errorType: LoginErrorType.updateVersion));
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onPost(
        "/login",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "fcmToken": fcmToken,
          "versionName": appVersion,
          "versionCode": buildNumber,
          "platform": platformNameWeb,
        },
        data: {
          "loginToken": loginToken,
        },
      );

      // When
      final repository = LoginDioRepository(
        httpClient: httpClient,
        sentryWrapper: sentryWrapper,
      );
      final response = await repository.login(
        firebaseMessagingToken: fcmToken,
        loginToken: loginToken,
        appVersion: appVersion,
        buildNumber: buildNumber,
        platformName: platformNameWeb,
      );

      // Then
      expect(response, LoginFailedResponse());
    });
  });
}
