import 'package:agora/infrastructure/qag/qag_repository.dart';

class MockQagRepository extends QagDioRepository {
  MockQagRepository({required super.httpClient, required super.crashlyticsHelper});

  @override
  Future<QagHasSimilarRepositoryResponse> hasSimilarQag({
    required String title,
  }) async {
    return QagHasSimilarSuccessResponse(hasSimilar: true);
  }
}
