import 'package:agora/profil/demographic/bloc/get/demographic_information_bloc.dart';
import 'package:agora/profil/demographic/bloc/get/demographic_information_event.dart';
import 'package:agora/profil/demographic/bloc/get/demographic_information_state.dart';
import 'package:agora/profil/demographic/domain/demographic_information.dart';
import 'package:agora/profil/demographic/domain/demographic_question_type.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/demographic/fakes_demographic_repository.dart';

void main() {
  group("GetDemographicInformationEvent", () {
    blocTest(
      "when repository succeed - should emit loading then success state",
      build: () => DemographicInformationBloc(
        demographicRepository: FakeDemographicSuccessRepository(),
      ),
      act: (bloc) => bloc.add(GetDemographicInformationEvent()),
      expect: () => [
        GetDemographicInformationInitialLoadingState(),
        GetDemographicInformationSuccessState(
          demographicInformationResponse: [
            DemographicInformation(demographicType: DemographicQuestionType.gender, data: "M"),
            DemographicInformation(demographicType: DemographicQuestionType.yearOfBirth, data: "1999"),
            DemographicInformation(
              demographicType: DemographicQuestionType.department,
              data: "75",
            ),
            DemographicInformation(demographicType: DemographicQuestionType.cityType, data: "R"),
            DemographicInformation(demographicType: DemographicQuestionType.jobCategory, data: null),
            DemographicInformation(demographicType: DemographicQuestionType.voteFrequency, data: "J"),
            DemographicInformation(demographicType: DemographicQuestionType.publicMeetingFrequency, data: "S"),
            DemographicInformation(demographicType: DemographicQuestionType.consultationFrequency, data: "P"),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit loading then failure state",
      build: () => DemographicInformationBloc(
        demographicRepository: FakeDemographicFailureRepository(),
      ),
      act: (bloc) => bloc.add(GetDemographicInformationEvent()),
      expect: () => [
        GetDemographicInformationInitialLoadingState(),
        GetDemographicInformationFailureState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("RemoveDemographicInformationEvent", () {
    blocTest<DemographicInformationBloc, DemographicInformationState>(
      "when repository succeed - should emit success state",
      build: () => DemographicInformationBloc(
        demographicRepository: FakeDemographicFailureRepository(),
      ),
      seed: () => GetDemographicInformationSuccessState(
        demographicInformationResponse: [
          DemographicInformation(demographicType: DemographicQuestionType.gender, data: "M"),
          DemographicInformation(demographicType: DemographicQuestionType.yearOfBirth, data: "1999"),
          DemographicInformation(
            demographicType: DemographicQuestionType.department,
            data: "Paris (75)",
          ),
          DemographicInformation(demographicType: DemographicQuestionType.cityType, data: "R"),
          DemographicInformation(demographicType: DemographicQuestionType.jobCategory, data: "C"),
          DemographicInformation(demographicType: DemographicQuestionType.voteFrequency, data: "J"),
          DemographicInformation(demographicType: DemographicQuestionType.publicMeetingFrequency, data: "S"),
          DemographicInformation(demographicType: DemographicQuestionType.consultationFrequency, data: "P"),
        ],
      ),
      act: (bloc) => bloc.add(RemoveDemographicInformationEvent()),
      expect: () => [
        GetDemographicInformationSuccessState(
          demographicInformationResponse: [
            DemographicInformation(demographicType: DemographicQuestionType.gender, data: null),
            DemographicInformation(demographicType: DemographicQuestionType.yearOfBirth, data: null),
            DemographicInformation(
              demographicType: DemographicQuestionType.department,
              data: null,
            ),
            DemographicInformation(demographicType: DemographicQuestionType.cityType, data: null),
            DemographicInformation(demographicType: DemographicQuestionType.jobCategory, data: null),
            DemographicInformation(demographicType: DemographicQuestionType.voteFrequency, data: null),
            DemographicInformation(demographicType: DemographicQuestionType.publicMeetingFrequency, data: null),
            DemographicInformation(demographicType: DemographicQuestionType.consultationFrequency, data: null),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
