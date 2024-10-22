import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/profil/demographic/bloc/get/demographic_information_bloc.dart';
import 'package:agora/profil/demographic/bloc/get/demographic_information_event.dart';
import 'package:agora/profil/demographic/bloc/get/demographic_information_state.dart';
import 'package:agora/profil/demographic/domain/demographic_information.dart';
import 'package:agora/profil/demographic/domain/demographic_question_type.dart';
import 'package:agora/referentiel/departement.dart';
import 'package:agora/referentiel/region.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/demographic/fakes_demographic_repository.dart';
import '../../fakes/referentiel/fakes_referentiel_repository.dart';

void main() {
  group("GetDemographicInformationEvent", () {
    blocTest(
      "when repository succeed - should emit loading then success state",
      build: () => DemographicInformationBloc(
        demographicRepository: FakeDemographicSuccessRepository(),
        referentielRepository: FakesReferentielRepository(),
      ),
      act: (bloc) => bloc.add(GetDemographicInformationEvent()),
      expect: () => [
        DemographicInformationState.init(),
        DemographicInformationState(
          status: AllPurposeStatus.success,
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
            DemographicInformation(demographicType: DemographicQuestionType.primaryDepartment, data: "Paris"),
            DemographicInformation(demographicType: DemographicQuestionType.secondaryDepartment, data: null),
          ],
          referentiel: [
            Region(label: "Ile-de-France", departements: [Departement(label: "Paris", codePostal: "75")]),
            Region(
              label: "Normandie",
              departements: [
                Departement(label: "Calvados", codePostal: "14"),
                Departement(label: "Eure", codePostal: "27"),
              ],
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit loading then failure state",
      build: () => DemographicInformationBloc(
        demographicRepository: FakeDemographicFailureRepository(),
        referentielRepository: FakesReferentielRepository(),
      ),
      act: (bloc) => bloc.add(GetDemographicInformationEvent()),
      expect: () => [
        DemographicInformationState.init(),
        DemographicInformationState(
          status: AllPurposeStatus.error,
          demographicInformationResponse: [],
          referentiel: [],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("RemoveDemographicInformationEvent", () {
    blocTest<DemographicInformationBloc, DemographicInformationState>(
      "when repository succeed - should emit success state",
      build: () => DemographicInformationBloc(
        demographicRepository: FakeDemographicFailureRepository(),
        referentielRepository: FakesReferentielRepository(),
      ),
      seed: () => DemographicInformationState(
        status: AllPurposeStatus.success,
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
        referentiel: [
          Region(label: "Ile-de-France", departements: [Departement(label: "Paris", codePostal: "75")]),
          Region(
            label: "Normandie",
            departements: [
              Departement(label: "Calvados", codePostal: "14"),
              Departement(label: "Eure", codePostal: "27"),
            ],
          ),
        ],
      ),
      act: (bloc) => bloc.add(RemoveDemographicInformationEvent()),
      expect: () => [
        DemographicInformationState(
          status: AllPurposeStatus.success,
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
          referentiel: [
            Region(label: "Ile-de-France", departements: [Departement(label: "Paris", codePostal: "75")]),
            Region(
              label: "Normandie",
              departements: [
                Departement(label: "Calvados", codePostal: "14"),
                Departement(label: "Eure", codePostal: "27"),
              ],
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
