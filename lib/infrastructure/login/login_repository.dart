import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/log/log.dart';
import 'package:equatable/equatable.dart';

abstract class LoginRepository {
  Future<SignupRepositoryResponse> signup({
    required String deviceId,
    required String firebaseMessagingToken,
  });

  Future<LoginRepositoryResponse> login({
    required String deviceId,
    required String firebaseMessagingToken,
    required String loginToken,
  });
}

class LoginDioRepository extends LoginRepository {
  final AgoraDioHttpClient httpClient;

  LoginDioRepository({required this.httpClient});

  @override
  Future<SignupRepositoryResponse> signup({
    required String deviceId,
    required String firebaseMessagingToken,
  }) async {
    try {
      final response = await httpClient.post(
        "/signup",
        headers: {
          "deviceId": deviceId,
          "fcmToken": firebaseMessagingToken,
        },
      );
      return SignupSucceedResponse(
        jwtToken: response.data["jwtToken"] as String,
        loginToken: response.data["loginToken"] as String,
        isModerator: response.data["isModerator"] as bool,
      );
    } catch (e) {
      Log.e("signup failed", e);
      return SignupFailedResponse();
    }
  }

  @override
  Future<LoginRepositoryResponse> login({
    required String deviceId,
    required String firebaseMessagingToken,
    required String loginToken,
  }) async {
    try {
      final response = await httpClient.post(
        "/login",
        headers: {
          "deviceId": deviceId,
          "fcmToken": firebaseMessagingToken,
        },
        data: loginToken,
      );
      return LoginSucceedResponse(
        jwtToken: response.data["jwtToken"] as String,
        isModerator: response.data["isModerator"] as bool,
      );
    } catch (e) {
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
  final String jwtToken;
  final String loginToken;
  final bool isModerator;

  SignupSucceedResponse({required this.jwtToken, required this.loginToken, required this.isModerator});

  @override
  List<Object> get props => [jwtToken, loginToken, isModerator];
}

class SignupFailedResponse extends SignupRepositoryResponse {}

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

class LoginFailedResponse extends LoginRepositoryResponse {}
