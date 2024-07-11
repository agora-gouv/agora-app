import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/demographic_question_type_extension.dart';
import 'package:agora/domain/demographic/demographic_information.dart';
import 'package:agora/domain/demographic/demographic_question_type.dart';
import 'package:agora/domain/demographic/demographic_response.dart';
import 'package:agora/infrastructure/errors/sentry_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class DemographicRepository {
  Future<GetDemographicInformationRepositoryResponse> getDemographicResponses();

  Future<SendDemographicResponsesRepositoryResponse> sendDemographicResponses({
    required List<DemographicResponse> demographicResponses,
  });
}

class DemographicDioRepository extends DemographicRepository {
  final AgoraDioHttpClient httpClient;
  final SentryWrapper sentryWrapper;

  DemographicDioRepository({required this.httpClient, required this.sentryWrapper});

  @override
  Future<GetDemographicInformationRepositoryResponse> getDemographicResponses() async {
    const uri = "/profile";
    try {
      final response = await httpClient.get(uri);
      return GetDemographicInformationSucceedResponse(
        demographicInformations: DemographicType.values.map((demographicType) {
          return DemographicInformation(
            demographicType: demographicType,
            data: response.data[demographicType.toTypeString()] as String?,
          );
        }).toList(),
      );
    } catch (exception, stacktrace) {
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
      return GetDemographicInformationFailureResponse();
    }
  }

  @override
  Future<SendDemographicResponsesRepositoryResponse> sendDemographicResponses({
    required List<DemographicResponse> demographicResponses,
  }) async {
    const uri = "/profile";
    try {
      final data = {};
      for (var demographicType in DemographicType.values) {
        data.putIfAbsent(demographicType.toTypeString(), () => _buildResponse(demographicType, demographicResponses));
      }
      await httpClient.post(uri, data: data);
      return SendDemographicResponsesSucceedResponse();
    } catch (exception, stacktrace) {
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
      return SendDemographicResponsesFailureResponse();
    }
  }

  String? _buildResponse(DemographicType type, List<DemographicResponse> demographicResponses) {
    try {
      final demographic =
          demographicResponses.firstWhere((demographicResponse) => demographicResponse.demographicType == type);
      return demographic.response;
    } catch (e) {
      return null;
    }
  }
}

abstract class GetDemographicInformationRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetDemographicInformationSucceedResponse extends GetDemographicInformationRepositoryResponse {
  final List<DemographicInformation> demographicInformations;

  GetDemographicInformationSucceedResponse({required this.demographicInformations});

  @override
  List<Object> get props => [demographicInformations];
}

class GetDemographicInformationFailureResponse extends GetDemographicInformationRepositoryResponse {}

abstract class SendDemographicResponsesRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class SendDemographicResponsesSucceedResponse extends SendDemographicResponsesRepositoryResponse {}

class SendDemographicResponsesFailureResponse extends SendDemographicResponsesRepositoryResponse {}
