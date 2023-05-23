import 'package:agora/domain/demographic/demographic_information.dart';
import 'package:agora/domain/demographic/demographic_question_type.dart';
import 'package:agora/domain/demographic/demographic_response.dart';
import 'package:agora/infrastructure/demographic/demographic_repository.dart';

class MockDemographicRepository extends DemographicDioRepository {
  MockDemographicRepository({required super.httpClient});

  @override
  Future<GetDemographicInformationRepositoryResponse> getDemographicResponses() async {
    return GetDemographicInformationSucceedResponse(
      demographicInformations: [
        DemographicInformation(demographicType: DemographicType.gender, data: "F"),
        DemographicInformation(demographicType: DemographicType.yearOfBirth, data: "1999"),
        DemographicInformation(demographicType: DemographicType.department, data: "75"),
        DemographicInformation(demographicType: DemographicType.cityType, data: "U"),
        DemographicInformation(demographicType: DemographicType.jobCategory, data: "CA"),
        DemographicInformation(demographicType: DemographicType.voteFrequency, data: "P"),
        DemographicInformation(demographicType: DemographicType.publicMeetingFrequency, data: "S"),
        DemographicInformation(demographicType: DemographicType.consultationFrequency, data: "J"),
      ],
    );
  }

  @override
  Future<SendDemographicResponsesRepositoryResponse> sendDemographicResponses({
    required List<DemographicResponse> demographicResponses,
  }) async {
    return SendDemographicResponsesSucceedResponse();
  }
}
