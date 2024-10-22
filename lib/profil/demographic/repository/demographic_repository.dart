import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/demographic_question_type_extension.dart';
import 'package:agora/common/log/sentry_wrapper.dart';
import 'package:agora/profil/demographic/domain/demographic_information.dart';
import 'package:agora/profil/demographic/domain/demographic_question_type.dart';
import 'package:agora/profil/demographic/domain/demographic_response.dart';
import 'package:equatable/equatable.dart';

abstract class DemographicRepository {
  Future<GetDemographicInformationRepositoryResponse> getDemographicResponses();

  Future<SendDemographicResponsesRepositoryResponse> sendDemographicResponses({
    required List<DemographicResponse> demographicResponses,
  });

  Future<SendTerritoireInfoRepositoryResponse> sendTerritoireInfo({required List<String> departementsSuivis});
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
        demographicInformations: DemographicQuestionType.values.map((demographicType) {
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
      for (var demographicType in DemographicQuestionType.values) {
        data.putIfAbsent(demographicType.toTypeString(), () => _buildResponse(demographicType, demographicResponses));
      }
      await httpClient.post(uri, data: data);
      return SendDemographicResponsesSucceedResponse();
    } catch (exception, stacktrace) {
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
      return SendDemographicResponsesFailureResponse();
    }
  }

  String? _buildResponse(DemographicQuestionType type, List<DemographicResponse> demographicResponses) {
    try {
      final demographic =
          demographicResponses.firstWhere((demographicResponse) => demographicResponse.demographicType == type);
      return demographic.response;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<SendTerritoireInfoRepositoryResponse> sendTerritoireInfo({required List<String> departementsSuivis}) async {
    const uri = "/profile/departments";
    try {
      await httpClient.post(
        uri,
        data: {
          "departments": departementsSuivis,
        },
      );
      return SendTerritoireInfoRepositoryResponseSuccess();
    } catch (exception, stacktrace) {
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
      return SendTerritoireInfoRepositoryResponseError();
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

abstract class SendTerritoireInfoRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class SendTerritoireInfoRepositoryResponseSuccess extends SendTerritoireInfoRepositoryResponse {}

class SendTerritoireInfoRepositoryResponseError extends SendTerritoireInfoRepositoryResponse {}
