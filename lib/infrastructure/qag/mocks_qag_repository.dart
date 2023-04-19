import 'package:agora/infrastructure/qag/qag_repository.dart';

// TODO suppress when debouncing is done
class MockQagSuccessRepository extends QagDioRepository {
  MockQagSuccessRepository({required super.httpClient});

  @override
  Future<SupportQagRepositoryResponse> supportQag({required String qagId, required String deviceId}) async {
    return SupportQagSucceedResponse();
  }

  @override
  Future<DeleteSupportQagRepositoryResponse> deleteSupportQag({required String qagId, required String deviceId}) async {
    return DeleteSupportQagSucceedResponse();
  }
}
