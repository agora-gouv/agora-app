import 'package:agora/infrastructure/login/login_repository.dart';

class FakeLoginSuccessRepository extends LoginRepository {
  @override
  Future<LoginRepositoryResponse> login({
    required String deviceId,
    required String firebaseMessagingToken,
  }) async {
    return LoginSucceedResponse(userId: "userId");
  }
}

class FakeLoginFailureRepository extends LoginRepository {
  @override
  Future<LoginRepositoryResponse> login({
    required String deviceId,
    required String firebaseMessagingToken,
  }) async {
    return LoginFailedResponse();
  }
}

class FakeLoginNoImportantRepository extends LoginRepository {
  @override
  Future<LoginRepositoryResponse> login({
    required String deviceId,
    required String firebaseMessagingToken,
  }) {
    throw UnimplementedError();
  }
}
