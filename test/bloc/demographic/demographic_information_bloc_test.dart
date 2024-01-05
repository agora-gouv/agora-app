import 'package:agora/bloc/demographic/get/demographic_information_bloc.dart';
import 'package:agora/bloc/demographic/get/demographic_information_event.dart';
import 'package:agora/bloc/demographic/get/demographic_information_state.dart';
import 'package:agora/domain/demographic/demographic_information.dart';
import 'package:agora/domain/demographic/demographic_question_type.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/demographic/fakes_demographic_repository.dart';

void main() {
  group("GetDemographicInformationEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => DemographicInformationBloc(
        demographicRepository: FakeDemographicSuccessRepository(),
      ),
      act: (bloc) => bloc.add(GetDemographicInformationEvent()),
      expect: () => [
        GetDemographicInformationSuccessState(
          demographicInformationResponse: [
            DemographicInformation(demographicType: DemographicType.gender, data: "M"),
            DemographicInformation(demographicType: DemographicType.yearOfBirth, data: "1999"),
            DemographicInformation(
              demographicType: DemographicType.department,
              data: "75",
            ),
            DemographicInformation(demographicType: DemographicType.cityType, data: "R"),
            DemographicInformation(demographicType: DemographicType.jobCategory, data: null),
            DemographicInformation(demographicType: DemographicType.voteFrequency, data: "J"),
            DemographicInformation(demographicType: DemographicType.publicMeetingFrequency, data: "S"),
            DemographicInformation(demographicType: DemographicType.consultationFrequency, data: "P"),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => DemographicInformationBloc(
        demographicRepository: FakeDemographicFailureRepository(),
      ),
      act: (bloc) => bloc.add(GetDemographicInformationEvent()),
      expect: () => [
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
          DemographicInformation(demographicType: DemographicType.gender, data: "M"),
          DemographicInformation(demographicType: DemographicType.yearOfBirth, data: "1999"),
          DemographicInformation(
            demographicType: DemographicType.department,
            data: "Paris (75)",
          ),
          DemographicInformation(demographicType: DemographicType.cityType, data: "R"),
          DemographicInformation(demographicType: DemographicType.jobCategory, data: "C"),
          DemographicInformation(demographicType: DemographicType.voteFrequency, data: "J"),
          DemographicInformation(demographicType: DemographicType.publicMeetingFrequency, data: "S"),
          DemographicInformation(demographicType: DemographicType.consultationFrequency, data: "P"),
        ],
      ),
      act: (bloc) => bloc.add(RemoveDemographicInformationEvent()),
      expect: () => [
        GetDemographicInformationSuccessState(
          demographicInformationResponse: [
            DemographicInformation(demographicType: DemographicType.gender, data: null),
            DemographicInformation(demographicType: DemographicType.yearOfBirth, data: null),
            DemographicInformation(
              demographicType: DemographicType.department,
              data: null,
            ),
            DemographicInformation(demographicType: DemographicType.cityType, data: null),
            DemographicInformation(demographicType: DemographicType.jobCategory, data: null),
            DemographicInformation(demographicType: DemographicType.voteFrequency, data: null),
            DemographicInformation(demographicType: DemographicType.publicMeetingFrequency, data: null),
            DemographicInformation(demographicType: DemographicType.consultationFrequency, data: null),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
