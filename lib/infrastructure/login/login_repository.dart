import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/log/log.dart';
import 'package:equatable/equatable.dart';

abstract class LoginRepository {
  Future<LoginRepositoryResponse> login({
    required String deviceId,
    required String firebaseMessagingToken,
  });
}

class LoginDioRepository extends LoginRepository {
  final AgoraDioHttpClient httpClient;

  LoginDioRepository({required this.httpClient});

  @override
  Future<LoginRepositoryResponse> login({
    required String deviceId,
    required String firebaseMessagingToken,
  }) async {
    try {
      final response = await httpClient.post(
        "/login",
        headers: {
          "deviceId": deviceId,
          "fcmToken": firebaseMessagingToken,
        },
      );
      return LoginSucceedResponse(userId: response.data["userId"] as String);
    } catch (e) {
      Log.e("login failed", e);
      return LoginFailedResponse();
    }
  }
}

abstract class LoginRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginSucceedResponse extends LoginRepositoryResponse {
  final String userId;

  LoginSucceedResponse({required this.userId});

  @override
  List<Object> get props => [userId];
}

class LoginFailedResponse extends LoginRepositoryResponse {}
