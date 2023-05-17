import 'package:agora/domain/demographic/demographic_information.dart';
import 'package:agora/domain/demographic/demographic_question_type.dart';
import 'package:agora/domain/demographic/demographic_response.dart';
import 'package:agora/infrastructure/demographic/demographic_repository.dart';

class FakeDemographicSuccessRepository extends DemographicRepository {
  @override
  Future<GetDemographicInformationRepositoryResponse> getDemographicResponses({required String deviceId}) async {
    return GetDemographicInformationSucceedResponse(
      demographicInformations: [
        DemographicInformation(demographicType: DemographicType.gender, data: "M"),
        DemographicInformation(demographicType: DemographicType.yearOfBirth, data: "1999"),
        DemographicInformation(demographicType: DemographicType.department, data: "75"),
        DemographicInformation(demographicType: DemographicType.cityType, data: "R"),
        DemographicInformation(demographicType: DemographicType.jobCategory, data: null),
        DemographicInformation(demographicType: DemographicType.voteFrequency, data: "J"),
        DemographicInformation(demographicType: DemographicType.publicMeetingFrequency, data: "S"),
        DemographicInformation(demographicType: DemographicType.consultationFrequency, data: "P"),
      ],
    );
  }

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
  Future<GetDemographicInformationRepositoryResponse> getDemographicResponses({required String deviceId}) async {
    return GetDemographicInformationFailureResponse();
  }

  @override
  Future<SendDemographicResponsesRepositoryResponse> sendDemographicResponses({
    required String deviceId,
    required List<DemographicResponse> demographicResponses,
  }) async {
    return SendDemographicResponsesFailureResponse();
  }
}
