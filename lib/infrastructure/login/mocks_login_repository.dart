import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/infrastructure/login/login_repository.dart';

// TODO suppress when debouncing is done
class MockLoginSuccessRepository extends LoginDioRepository {
  MockLoginSuccessRepository({required super.httpClient});

  @override
  Future<LoginRepositoryResponse> login({
    required String deviceId,
    required String firebaseMessagingToken,
  }) async {
    final deviceId = await HelperManager.getDeviceInfoHelper().getDeviceId();
    return LoginSucceedResponse(userId: deviceId!);
  }
}
