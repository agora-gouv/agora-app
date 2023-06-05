import 'package:agora/infrastructure/login/login_repository.dart';

class FakeLoginSuccessRepository extends LoginRepository {
  @override
  Future<SignupRepositoryResponse> signup({
    required String firebaseMessagingToken,
  }) async {
    return SignupSucceedResponse(
      userId: "userId",
      jwtToken: "jwtToken",
      loginToken: "loginToken",
      isModerator: true,
    );
  }

  @override
  Future<LoginRepositoryResponse> login({
    required String firebaseMessagingToken,
    required String loginToken,
  }) async {
    return LoginSucceedResponse(
      jwtToken: "jwtToken",
      isModerator: false,
    );
  }
}

class FakeLoginFailureRepository extends LoginRepository {
  @override
  Future<SignupRepositoryResponse> signup({
    required String firebaseMessagingToken,
  }) async {
    return SignupFailedResponse();
  }

  @override
  Future<LoginRepositoryResponse> login({
    required String firebaseMessagingToken,
    required String loginToken,
  }) async {
    return LoginFailedResponse();
  }
}
