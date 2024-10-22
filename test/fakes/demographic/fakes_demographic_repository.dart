import 'package:agora/profil/demographic/domain/demographic_information.dart';
import 'package:agora/profil/demographic/domain/demographic_question_type.dart';
import 'package:agora/profil/demographic/domain/demographic_response.dart';
import 'package:agora/profil/demographic/repository/demographic_repository.dart';

class FakeDemographicSuccessRepository extends DemographicRepository {
  @override
  Future<GetDemographicInformationRepositoryResponse> getDemographicResponses() async {
    return GetDemographicInformationSucceedResponse(
      demographicInformations: [
        DemographicInformation(demographicType: DemographicQuestionType.gender, data: "M"),
        DemographicInformation(demographicType: DemographicQuestionType.yearOfBirth, data: "1999"),
        DemographicInformation(demographicType: DemographicQuestionType.department, data: "75"),
        DemographicInformation(demographicType: DemographicQuestionType.cityType, data: "R"),
        DemographicInformation(demographicType: DemographicQuestionType.jobCategory, data: null),
        DemographicInformation(demographicType: DemographicQuestionType.voteFrequency, data: "J"),
        DemographicInformation(demographicType: DemographicQuestionType.publicMeetingFrequency, data: "S"),
        DemographicInformation(demographicType: DemographicQuestionType.consultationFrequency, data: "P"),
        DemographicInformation(demographicType: DemographicQuestionType.primaryDepartment, data: "Paris"),
        DemographicInformation(demographicType: DemographicQuestionType.secondaryDepartment, data: null),
      ],
    );
  }

  @override
  Future<SendDemographicResponsesRepositoryResponse> sendDemographicResponses({
    required List<DemographicResponse> demographicResponses,
  }) async {
    return SendDemographicResponsesSucceedResponse();
  }

  @override
  Future<SendTerritoireInfoRepositoryResponse> sendTerritoireInfo({required List<String> departementsSuivis}) async {
    return SendTerritoireInfoRepositoryResponseSuccess();
  }
}

class FakeDemographicFailureRepository extends DemographicRepository {
  @override
  Future<GetDemographicInformationRepositoryResponse> getDemographicResponses() async {
    return GetDemographicInformationFailureResponse();
  }

  @override
  Future<SendDemographicResponsesRepositoryResponse> sendDemographicResponses({
    required List<DemographicResponse> demographicResponses,
  }) async {
    return SendDemographicResponsesFailureResponse();
  }

  @override
  Future<SendTerritoireInfoRepositoryResponse> sendTerritoireInfo({required List<String> departementsSuivis}) async {
    return SendTerritoireInfoRepositoryResponseError();
  }
}
