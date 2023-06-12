import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/log/log.dart';
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

  LoginDioRepository({required this.httpClient});

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
    } catch (e) {
      if (e is DioError) {
        if (e.type == DioErrorType.connectionTimeout || e.type == DioErrorType.receiveTimeout) {
          Log.e("signup failed : timeout error", e);
          return SignupFailedResponse(errorType: LoginErrorType.timeout);
        }
      }
      Log.e("signup failed", e);
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
    } catch (e) {
      if (e is DioError) {
        if (e.type == DioErrorType.connectionTimeout || e.type == DioErrorType.receiveTimeout) {
          Log.e("signup failed : timeout error", e);
          return LoginFailedResponse(errorType: LoginErrorType.timeout);
        }
      }
      Log.e("login failed", e);
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
