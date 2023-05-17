import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/demographic_question_type_extension.dart';
import 'package:agora/common/log/log.dart';
import 'package:agora/domain/demographic/demographic_question_type.dart';
import 'package:agora/domain/demographic/demographic_response.dart';
import 'package:equatable/equatable.dart';

abstract class DemographicRepository {
  Future<SendDemographicResponsesRepositoryResponse> sendDemographicResponses({
    required String deviceId,
    required List<DemographicResponse> demographicResponses,
  });
}

class DemographicDioRepository extends DemographicRepository {
  final AgoraDioHttpClient httpClient;

  DemographicDioRepository({required this.httpClient});

  @override
  Future<SendDemographicResponsesRepositoryResponse> sendDemographicResponses({
    required String deviceId,
    required List<DemographicResponse> demographicResponses,
  }) async {
    try {
      final data = {};
      for (var questionType in DemographicQuestionType.values) {
        data.putIfAbsent(questionType.toTypeString(), () => _buildResponse(questionType, demographicResponses));
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

  String? _buildResponse(DemographicQuestionType type, List<DemographicResponse> demographicResponses) {
    try {
      final demographic =
          demographicResponses.firstWhere((demographicResponse) => demographicResponse.questionType == type);
      return demographic.response;
    } catch (e) {
      return null;
    }
  }
}

abstract class SendDemographicResponsesRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class SendDemographicResponsesSucceedResponse extends SendDemographicResponsesRepositoryResponse {}

class SendDemographicResponsesFailureResponse extends SendDemographicResponsesRepositoryResponse {}
