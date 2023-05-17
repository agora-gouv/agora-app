import 'package:agora/domain/demographic/demographic_response.dart';
import 'package:agora/infrastructure/demographic/demographic_repository.dart';

class FakeDemographicSuccessRepository extends DemographicRepository {
  @override
  Future<SendDemographicResponsesRepositoryResponse> sendDemographicResponses({
    required String deviceId,
    required List<DemographicResponse> demographicResponses,
  }) async {
    return SendDemographicResponsesSucceedResponse();
  }
}

class FakeDemographicFailureRepository extends DemographicRepository {
  @override
  Future<SendDemographicResponsesRepositoryResponse> sendDemographicResponses({
    required String deviceId,
    required List<DemographicResponse> demographicResponses,
  }) async {
    return SendDemographicResponsesFailureResponse();
  }
}
