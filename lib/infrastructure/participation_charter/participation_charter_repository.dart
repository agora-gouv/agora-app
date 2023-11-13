import 'package:agora/common/client/agora_http_client.dart';
import 'package:equatable/equatable.dart';

abstract class ParticipationCharterRepository {
  Future<GetParticipationCharterRepositoryResponse> getParticipationCharterResponse();
}

class ParticipationCharterDioRepository extends ParticipationCharterRepository {
  final AgoraDioHttpClient httpClient;

  ParticipationCharterDioRepository({required this.httpClient});

  @override
  Future<GetParticipationCharterRepositoryResponse> getParticipationCharterResponse() async {
    try {
      final response = await httpClient.get("/participation_charter");
      return GetParticipationCharterSucceedResponse(
        extraText: response.data["extraText"] as String,
      );
    } catch (e) {
      return SendDemographicResponsesFailureResponse();
    }
  }
}

abstract class GetParticipationCharterRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetParticipationCharterSucceedResponse extends GetParticipationCharterRepositoryResponse {
  final String extraText;

  GetParticipationCharterSucceedResponse({required this.extraText});

  @override
  List<Object> get props => [extraText];
}

class SendDemographicResponsesFailureResponse extends GetParticipationCharterRepositoryResponse {}
