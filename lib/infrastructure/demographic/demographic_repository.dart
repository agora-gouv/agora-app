import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/demographic_question_type_extension.dart';
import 'package:agora/common/helper/crashlytics_helper.dart';
import 'package:agora/domain/demographic/demographic_information.dart';
import 'package:agora/domain/demographic/demographic_question_type.dart';
import 'package:agora/domain/demographic/demographic_response.dart';
import 'package:equatable/equatable.dart';

abstract class DemographicRepository {
  Future<GetDemographicInformationRepositoryResponse> getDemographicResponses();

  Future<SendDemographicResponsesRepositoryResponse> sendDemographicResponses({
    required List<DemographicResponse> demographicResponses,
  });
}

class DemographicDioRepository extends DemographicRepository {
  final AgoraDioHttpClient httpClient;
  final CrashlyticsHelper crashlyticsHelper;

  DemographicDioRepository({required this.httpClient, required this.crashlyticsHelper});

  @override
  Future<GetDemographicInformationRepositoryResponse> getDemographicResponses() async {
    try {
      final response = await httpClient.get("/profile");
      return GetDemographicInformationSucceedResponse(
        demographicInformations: DemographicType.values.map((demographicType) {
          return DemographicInformation(
            demographicType: demographicType,
            data: response.data[demographicType.toTypeString()] as String?,
          );
        }).toList(),
      );
    } catch (e, s) {
      crashlyticsHelper.recordError(e, s, reason: "getDemographicResponses failed");
      return GetDemographicInformationFailureResponse();
    }
  }

  @override
  Future<SendDemographicResponsesRepositoryResponse> sendDemographicResponses({
    required List<DemographicResponse> demographicResponses,
  }) async {
    try {
      final data = {};
      for (var demographicType in DemographicType.values) {
        data.putIfAbsent(demographicType.toTypeString(), () => _buildResponse(demographicType, demographicResponses));
      }
      await httpClient.post(
        "/profile",
        data: data,
      );
      return SendDemographicResponsesSucceedResponse();
    } catch (e, s) {
      crashlyticsHelper.recordError(e, s, reason: "sendDemographicResponses failed");
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
