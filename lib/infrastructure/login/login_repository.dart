import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/helper/crashlytics_helper.dart';
import 'package:agora/domain/login/login_error_type.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class LoginRepository {
  Future<SignupRepositoryResponse> signup({
    required String firebaseMessagingToken,
  });

  Future<LoginRepositoryResponse> login({
    required String firebaseMessagingToken,
    required String loginToken,
  });
}

class LoginDioRepository extends LoginRepository {
  final AgoraDioHttpClient httpClient;
  final CrashlyticsHelper crashlyticsHelper;

  LoginDioRepository({required this.httpClient, required this.crashlyticsHelper});

  @override
  Future<SignupRepositoryResponse> signup({
    required String firebaseMessagingToken,
  }) async {
    try {
      final response = await httpClient.post(
        "/signup",
        headers: {
          "fcmToken": firebaseMessagingToken,
        },
      );
      return SignupSucceedResponse(
        userId: response.data["userId"] as String,
        jwtToken: response.data["jwtToken"] as String,
        loginToken: response.data["loginToken"] as String,
        isModerator: response.data["isModerator"] as bool,
      );
    } catch (e, s) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
          crashlyticsHelper.recordError(e, s, reason: "signup failed : timeout error");
          return SignupFailedResponse(errorType: LoginErrorType.timeout);
        }
      }
      crashlyticsHelper.recordError(e, s, reason: "signup failed");
      return SignupFailedResponse();
    }
  }

  @override
  Future<LoginRepositoryResponse> login({
    required String firebaseMessagingToken,
    required String loginToken,
  }) async {
    try {
      final response = await httpClient.post(
        "/login",
        headers: {
          "fcmToken": firebaseMessagingToken,
        },
        data: loginToken,
      );
      return LoginSucceedResponse(
        jwtToken: response.data["jwtToken"] as String,
        isModerator: response.data["isModerator"] as bool,
      );
    } catch (e, s) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
          crashlyticsHelper.recordError(e, s, reason: "login failed : timeout error");
          return LoginFailedResponse(errorType: LoginErrorType.timeout);
        }
      }
      crashlyticsHelper.recordError(e, s, reason: "login failed");
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

  SignupSucceedResponse({
    required this.userId,
    required this.jwtToken,
    required this.loginToken,
    required this.isModerator,
  });

  @override
  List<Object> get props => [userId, jwtToken, loginToken, isModerator];
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

  LoginSucceedResponse({required this.jwtToken, required this.isModerator});

  @override
  List<Object> get props => [jwtToken, isModerator];
}

class LoginFailedResponse extends LoginRepositoryResponse {
  final LoginErrorType errorType;

  LoginFailedResponse({this.errorType = LoginErrorType.generic});

  @override
  List<Object> get props => [errorType];
}
