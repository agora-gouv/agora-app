import 'package:agora/infrastructure/qag/qag_repository.dart';

// TODO suppress when debouncing is done
class MockQagSuccessRepository extends QagDioRepository {
  MockQagSuccessRepository({required super.httpClient});

  @override
  Future<QagFeedbackRepositoryResponse> giveQagResponseFeedback({
    required String qagId,
    required String deviceId,
    required bool isHelpful,
  }) async {
    return QagFeedbackSuccessResponse();
  }
}
