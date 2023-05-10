import 'package:agora/bloc/consultation/consultation_bloc.dart';
import 'package:agora/bloc/consultation/consultation_event.dart';
import 'package:agora/bloc/consultation/consultation_state.dart';
import 'package:agora/bloc/consultation/consultation_view_model.dart';
import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/consultation/fakes_consultation_repository.dart';
import '../../fakes/qag/fake_device_id_helper.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  group("fetchConsultationsEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => ConsultationBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) => bloc.add(FetchConsultationsEvent()),
      expect: () => [
        ConsultationsFetchedState(
          ongoingViewModels: [
            ConsultationOngoingViewModel(
              id: "consultationId",
              title: "Développer le covoiturage au quotidien",
              coverUrl: "coverUrl1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              endDate: "23 janvier",
              hasAnswered: false,
            )
          ],
          finishedViewModels: [
            ConsultationFinishedViewModel(
              id: "consultationId2",
              title: "Quelles solutions pour les déserts médicaux ?",
              coverUrl: "coverUrl2",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              step: 2,
            ),
          ],
          answeredViewModels: [
            ConsultationAnsweredViewModel(
              id: "consultationId3",
              title: "Quand commencer ?",
              coverUrl: "coverUrl3",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              step: 3,
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository succeed and finished consultation is empty - should emit success state",
      build: () => ConsultationBloc(
        consultationRepository: FakeConsultationSuccessWithFinishedConsultationEmptyRepository(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) => bloc.add(FetchConsultationsEvent()),
      expect: () => [
        ConsultationsFetchedState(
          ongoingViewModels: [
            ConsultationOngoingViewModel(
              id: "consultationId",
              title: "Développer le covoiturage au quotidien",
              coverUrl: "coverUrl",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              endDate: "23 janvier",
              hasAnswered: false,
            )
          ],
          finishedViewModels: [
            ConsultationFinishedViewModel(
              id: "consultationId",
              title: "Développer le covoiturage au quotidien",
              coverUrl: "coverUrl",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              step: 1,
            ),
          ],
          answeredViewModels: [],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when device id is null - should emit failure state",
      build: () => ConsultationBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
        deviceInfoHelper: FakeDeviceIdNullHelper(),
      ),
      act: (bloc) => bloc.add(FetchConsultationsEvent()),
      expect: () => [
        ConsultationErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => ConsultationBloc(
        consultationRepository: FakeConsultationFailureRepository(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) => bloc.add(FetchConsultationsEvent()),
      expect: () => [
        ConsultationErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
