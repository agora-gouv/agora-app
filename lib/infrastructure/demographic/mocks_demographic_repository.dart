import 'package:agora/domain/demographic/demographic_response.dart';
import 'package:agora/infrastructure/demographic/demographic_repository.dart';

class MockDemographicRepository extends DemographicDioRepository {
  MockDemographicRepository({required super.httpClient});

  @override
  Future<SendDemographicResponsesRepositoryResponse> sendDemographicResponses({
    required String deviceId,
    required List<DemographicResponse> demographicResponses,
  }) async {
    return SendDemographicResponsesSucceedResponse();
  }
}
