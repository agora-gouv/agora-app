import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/infrastructure/errors/sentry_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class ParticipationCharterRepository {
  Future<GetParticipationCharterRepositoryResponse> getParticipationCharterResponse();
}

class ParticipationCharterDioRepository extends ParticipationCharterRepository {
  final AgoraDioHttpClient httpClient;
  final SentryWrapper? sentryWrapper;

  ParticipationCharterDioRepository({required this.httpClient, this.sentryWrapper});

  @override
  Future<GetParticipationCharterRepositoryResponse> getParticipationCharterResponse() async {
    try {
      final response = await httpClient.get("/participation_charter");
      return GetParticipationCharterSucceedResponse(
        extraText: response.data["extraText"] as String,
      );
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
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
