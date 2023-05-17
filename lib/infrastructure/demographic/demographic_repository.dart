import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/demographic_question_type_extension.dart';
import 'package:agora/common/log/log.dart';
import 'package:agora/domain/demographic/demographic_information.dart';
import 'package:agora/domain/demographic/demographic_question_type.dart';
import 'package:agora/domain/demographic/demographic_response.dart';
import 'package:equatable/equatable.dart';

abstract class DemographicRepository {
  Future<GetDemographicInformationRepositoryResponse> getDemographicResponses({
    required String deviceId,
  });

  Future<SendDemographicResponsesRepositoryResponse> sendDemographicResponses({
    required String deviceId,
    required List<DemographicResponse> demographicResponses,
  });
}

class DemographicDioRepository extends DemographicRepository {
  final AgoraDioHttpClient httpClient;

  DemographicDioRepository({required this.httpClient});

  @override
  Future<GetDemographicInformationRepositoryResponse> getDemographicResponses({
    required String deviceId,
  }) async {
    try {
      final response = await httpClient.get("/profile", headers: {"deviceId": deviceId});
      return GetDemographicInformationSucceedResponse(
        demographicInformations: DemographicType.values.map((demographicType) {
          return DemographicInformation(
            demographicType: demographicType,
            data: response.data[demographicType.toTypeString()] as String?,
          );
        }).toList(),
      );
    } catch (e) {
      Log.e("getDemographicResponses failed", e);
      return GetDemographicInformationFailureResponse();
    }
  }

  @override
  Future<SendDemographicResponsesRepositoryResponse> sendDemographicResponses({
    required String deviceId,
    required List<DemographicResponse> demographicResponses,
  }) async {
    try {
      final data = {};
      for (var demographicType in DemographicType.values) {
        data.putIfAbsent(demographicType.toTypeString(), () => _buildResponse(demographicType, demographicResponses));
      }
      await httpClient.post(
        "/profile",
        headers: {"deviceId": deviceId},
        data: data,
      );
      return SendDemographicResponsesSucceedResponse();
    } catch (e) {
      Log.e("sendDemographicResponses failed", e);
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
