import 'package:agora/login/domain/login_error_type.dart';
import 'package:agora/login/repository/login_repository.dart';

class FakeLoginSuccessRepository extends LoginRepository {
  @override
  Future<SignupRepositoryResponse> signup({
    required String firebaseMessagingToken,
    required String appVersion,
    required String buildNumber,
    required String platformName,
  }) async {
    return SignupSucceedResponse(
      userId: "userId",
      jwtToken: "jwtToken",
      loginToken: "loginToken",
      isModerator: true,
      jwtExpirationEpochMilli: 1234567890,
    );
  }

  @override
  Future<LoginRepositoryResponse> login({
    required String firebaseMessagingToken,
    required String loginToken,
    required String appVersion,
    required String buildNumber,
    required String platformName,
  }) async {
    return LoginSucceedResponse(
      jwtToken: "jwtToken",
      isModerator: false,
      jwtExpirationEpochMilli: 1234567890,
    );
  }
}

class FakeLoginTimeoutFailureRepository extends LoginRepository {
  @override
  Future<SignupRepositoryResponse> signup({
    required String firebaseMessagingToken,
    required String appVersion,
    required String buildNumber,
    required String platformName,
  }) async {
    return SignupFailedResponse(errorType: LoginErrorType.timeout);
  }

  @override
  Future<LoginRepositoryResponse> login({
    required String firebaseMessagingToken,
    required String loginToken,
    required String appVersion,
    required String buildNumber,
    required String platformName,
  }) async {
    return LoginFailedResponse(errorType: LoginErrorType.timeout);
  }
}

class FakeLoginFailureRepository extends LoginRepository {
  @override
  Future<SignupRepositoryResponse> signup({
    required String firebaseMessagingToken,
    required String appVersion,
    required String buildNumber,
    required String platformName,
  }) async {
    return SignupFailedResponse();
  }

  @override
  Future<LoginRepositoryResponse> login({
    required String firebaseMessagingToken,
    required String loginToken,
    required String appVersion,
    required String buildNumber,
    required String platformName,
  }) async {
    return LoginFailedResponse();
  }
}
