import 'package:agora/bloc/demographic/get/demographic_information_bloc.dart';
import 'package:agora/bloc/demographic/get/demographic_information_event.dart';
import 'package:agora/bloc/demographic/get/demographic_information_state.dart';
import 'package:agora/bloc/demographic/get/demographic_information_view_model.dart';
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
          demographicInformationViewModels: [
            DemographicInformationViewModel(demographicType: "Genre", data: "Homme"),
            DemographicInformationViewModel(demographicType: "Année de naissance", data: "1999"),
            DemographicInformationViewModel(
              demographicType: "Département ou collectivité d'outre mer",
              data: "Paris (75)",
            ),
            DemographicInformationViewModel(demographicType: "J'habite", data: "En milieu rural"),
            DemographicInformationViewModel(demographicType: "Catégorie socio-professionnelle", data: "Non renseigné"),
            DemographicInformationViewModel(demographicType: "Fréquence de vote", data: "Jamais"),
            DemographicInformationViewModel(demographicType: "Engagement sur le terrain", data: "Souvent"),
            DemographicInformationViewModel(demographicType: "Engagement en ligne", data: "Parfois"),
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
        demographicInformationViewModels: [
          DemographicInformationViewModel(demographicType: "Genre", data: "Homme"),
          DemographicInformationViewModel(demographicType: "Année de naissance", data: "1999"),
          DemographicInformationViewModel(
            demographicType: "Département ou collectivité d'outre mer",
            data: "Paris (75)",
          ),
          DemographicInformationViewModel(demographicType: "J'habite", data: "En milieu rural"),
          DemographicInformationViewModel(demographicType: "Catégorie socio-professionnelle", data: "Cadres"),
          DemographicInformationViewModel(demographicType: "Vote", data: "Jamais"),
          DemographicInformationViewModel(demographicType: "Engagement sur le terrain", data: "Souvent"),
          DemographicInformationViewModel(demographicType: "Engagement en ligne", data: "Parfois"),
        ],
      ),
      act: (bloc) => bloc.add(RemoveDemographicInformationEvent()),
      expect: () => [
        GetDemographicInformationSuccessState(
          demographicInformationViewModels: [
            DemographicInformationViewModel(demographicType: "Genre", data: "Non renseigné"),
            DemographicInformationViewModel(demographicType: "Année de naissance", data: "Non renseigné"),
            DemographicInformationViewModel(
              demographicType: "Département ou collectivité d'outre mer",
              data: "Non renseigné",
            ),
            DemographicInformationViewModel(demographicType: "J'habite", data: "Non renseigné"),
            DemographicInformationViewModel(demographicType: "Catégorie socio-professionnelle", data: "Non renseigné"),
            DemographicInformationViewModel(demographicType: "Vote", data: "Non renseigné"),
            DemographicInformationViewModel(demographicType: "Engagement sur le terrain", data: "Non renseigné"),
            DemographicInformationViewModel(demographicType: "Engagement en ligne", data: "Non renseigné"),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
