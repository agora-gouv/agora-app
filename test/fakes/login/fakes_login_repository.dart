import 'package:agora/infrastructure/login/login_repository.dart';

class FakeLoginSuccessRepository extends LoginRepository {
  @override
  Future<SignupRepositoryResponse> signup({
    required String deviceId,
    required String firebaseMessagingToken,
  }) async {
    return SignupSucceedResponse(jwtToken: "jwtToken", loginToken: "loginToken");
  }

  @override
  Future<LoginRepositoryResponse> login({
    required String deviceId,
    required String firebaseMessagingToken,
    required String loginToken,
  }) async {
    return LoginSucceedResponse(jwtToken: "jwtToken");
  }
}

class FakeLoginFailureRepository extends LoginRepository {
  @override
  Future<SignupRepositoryResponse> signup({
    required String deviceId,
    required String firebaseMessagingToken,
  }) async {
    return SignupFailedResponse();
  }

  @override
  Future<LoginRepositoryResponse> login({
    required String deviceId,
    required String firebaseMessagingToken,
    required String loginToken,
  }) async {
    return LoginFailedResponse();
  }
}

class FakeLoginNoImportantRepository extends LoginRepository {
  @override
  Future<SignupRepositoryResponse> signup({
    required String deviceId,
    required String firebaseMessagingToken,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<LoginRepositoryResponse> login({
    required String deviceId,
    required String firebaseMessagingToken,
    required String loginToken,
  }) async {
    throw UnimplementedError();
  }
}
