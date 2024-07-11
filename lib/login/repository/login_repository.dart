import 'dart:io';

import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/infrastructure/errors/sentry_wrapper.dart';
import 'package:agora/login/domain/login_error_type.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class LoginRepository {
  Future<SignupRepositoryResponse> signup({
    required String firebaseMessagingToken,
    required String appVersion,
    required String buildNumber,
    required String platformName,
  });

  Future<LoginRepositoryResponse> login({
    required String firebaseMessagingToken,
    required String loginToken,
    required String appVersion,
    required String buildNumber,
    required String platformName,
  });
}

class LoginDioRepository extends LoginRepository {
  final AgoraDioHttpClient httpClient;
  final SentryWrapper sentryWrapper;

  LoginDioRepository({required this.httpClient, required this.sentryWrapper});

  @override
  Future<SignupRepositoryResponse> signup({
    required String firebaseMessagingToken,
    required String appVersion,
    required String buildNumber,
    required String platformName,
  }) async {
    const uri = "/signup";
    try {
      final response = await httpClient.post(
        uri,
        headers: {
          "fcmToken": firebaseMessagingToken,
          "versionName": appVersion,
          "versionCode": buildNumber,
          "platform": platformName,
        },
      );
      return SignupSucceedResponse(
        userId: response.data["userId"] as String,
        jwtToken: response.data["jwtToken"] as String,
        loginToken: response.data["loginToken"] as String,
        isModerator: response.data["isModerator"] as bool,
        jwtExpirationEpochMilli: response.data["jwtExpirationEpochMilli"] as int,
      );
    } catch (exception, stacktrace) {
      if (exception is DioException) {
        final response = exception.response;
        if (response != null && response.statusCode == HttpStatus.preconditionFailed) {
          return SignupFailedResponse(errorType: LoginErrorType.updateVersion);
        } else if (exception.type == DioExceptionType.connectionTimeout ||
            exception.type == DioExceptionType.receiveTimeout) {
          return SignupFailedResponse(errorType: LoginErrorType.timeout);
        }
      }
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
      return SignupFailedResponse();
    }
  }

  @override
  Future<LoginRepositoryResponse> login({
    required String firebaseMessagingToken,
    required String loginToken,
    required String appVersion,
    required String buildNumber,
    required String platformName,
  }) async {
    const uri = "/login";
    try {
      final response = await httpClient.post(
        uri,
        headers: {
          "fcmToken": firebaseMessagingToken,
          "versionName": appVersion,
          "versionCode": buildNumber,
          "platform": platformName,
        },
        data: {
          "loginToken": loginToken,
        },
      );
      return LoginSucceedResponse(
        jwtToken: response.data["jwtToken"] as String,
        isModerator: response.data["isModerator"] as bool,
        jwtExpirationEpochMilli: response.data["jwtExpirationEpochMilli"] as int,
      );
    } catch (exception, stacktrace) {
      if (exception is DioException) {
        final response = exception.response;
        if (response != null && response.statusCode == HttpStatus.preconditionFailed) {
          return LoginFailedResponse(errorType: LoginErrorType.updateVersion);
        } else if (exception.type == DioExceptionType.connectionTimeout ||
            exception.type == DioExceptionType.receiveTimeout) {
          return LoginFailedResponse(errorType: LoginErrorType.timeout);
        }
      }
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
      return LoginFailedResponse();
    }
  }
}

abstract class SignupRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class SignupSucceedResponse extends SignupRepositoryResponse {
  final String userId;
  final String jwtToken;
  final String loginToken;
  final bool isModerator;
  final int jwtExpirationEpochMilli;

  SignupSucceedResponse({
    required this.userId,
    required this.jwtToken,
    required this.loginToken,
    required this.isModerator,
    required this.jwtExpirationEpochMilli,
  });

  @override
  List<Object> get props => [
        userId,
        jwtToken,
        loginToken,
        isModerator,
        jwtExpirationEpochMilli,
      ];
}

class SignupFailedResponse extends SignupRepositoryResponse {
  final LoginErrorType errorType;

  SignupFailedResponse({this.errorType = LoginErrorType.generic});

  @override
  List<Object> get props => [errorType];
}

abstract class LoginRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginSucceedResponse extends LoginRepositoryResponse {
  final String jwtToken;
  final bool isModerator;
  final int jwtExpirationEpochMilli;

  LoginSucceedResponse({
    required this.jwtToken,
    required this.isModerator,
    required this.jwtExpirationEpochMilli,
  });

  @override
  List<Object> get props => [jwtToken, isModerator, jwtExpirationEpochMilli];
}

class LoginFailedResponse extends LoginRepositoryResponse {
  final LoginErrorType errorType;

  LoginFailedResponse({this.errorType = LoginErrorType.generic});

  @override
  List<Object> get props => [errorType];
}
