import 'package:agora/consultation/bloc/consultation_bloc.dart';
import 'package:agora/consultation/bloc/consultation_event.dart';
import 'package:agora/consultation/bloc/consultation_state.dart';
import 'package:agora/consultation/bloc/consultation_view_model.dart';
import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/consultation/domain/consultations_error_type.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/concertation/fakes_concertation_repository.dart';
import '../../fakes/consultation/fakes_consultation_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  group("fetchConsultationsEvent", () {
    blocTest(
      "when repository succeed - should emit loading then success state",
      build: () => ConsultationBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
        concertationRepository: FakesConcertationRepository(),
      ),
      act: (bloc) => bloc.add(FetchConsultationsEvent()),
      expect: () => [
        ConsultationInitialLoadingState(),
        ConsultationsFetchedState(
          ongoingViewModels: [
            ConsultationOngoingViewModel(
              id: "consultationId",
              title: "Développer le covoiturage au quotidien",
              coverUrl: "coverUrl1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              endDate: "23 janvier",
              label: "Plus que 3 jours",
            ),
          ],
          finishedViewModels: [
            ConsultationFinishedViewModel(
              id: "consultationId2",
              title: "Quelles solutions pour les déserts médicaux ?",
              coverUrl: "coverUrl2",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              label: 'label',
            ),
            ConcertationViewModel(
              id: "concertationId1",
              title: "Développer le covoiturage",
              coverUrl: "coverUrl1",
              externalLink: "externalLink1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              label: 'Plus que 3 jours',
            ),
          ],
          answeredViewModels: [
            ConsultationAnsweredViewModel(
              id: "consultationId3",
              title: "Quand commencer ?",
              coverUrl: "coverUrl3",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              label: 'label',
            ),
          ],
          shouldDisplayFinishedAllButton: true,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository succeed and finished consultation is empty - should emit loading then success state",
      build: () => ConsultationBloc(
        consultationRepository: FakeConsultationSuccessWithFinishedConsultationEmptyRepository(),
        concertationRepository: FakesConcertationRepository(),
      ),
      act: (bloc) => bloc.add(FetchConsultationsEvent()),
      expect: () => [
        ConsultationInitialLoadingState(),
        ConsultationsFetchedState(
          ongoingViewModels: [
            ConsultationOngoingViewModel(
              id: "consultationId",
              title: "Développer le covoiturage au quotidien",
              coverUrl: "coverUrl",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              endDate: "23 janvier",
              label: null,
            ),
          ],
          finishedViewModels: [
            ConsultationFinishedViewModel(
              id: "consultationId",
              title: "Développer le covoiturage au quotidien",
              coverUrl: "coverUrl",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              label: null,
            ),
          ],
          answeredViewModels: [],
          shouldDisplayFinishedAllButton: false,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed with timeout - should emit loading then failure state",
      build: () => ConsultationBloc(
        consultationRepository: FakeConsultationTimeoutFailureRepository(),
        concertationRepository: FakesConcertationRepository(),
      ),
      act: (bloc) => bloc.add(FetchConsultationsEvent()),
      expect: () => [
        ConsultationInitialLoadingState(),
        ConsultationErrorState(errorType: ConsultationsErrorType.timeout),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit loading then failure state",
      build: () => ConsultationBloc(
        consultationRepository: FakeConsultationFailureRepository(),
        concertationRepository: FakesConcertationRepository(),
      ),
      act: (bloc) => bloc.add(FetchConsultationsEvent()),
      expect: () => [
        ConsultationInitialLoadingState(),
        ConsultationErrorState(errorType: ConsultationsErrorType.generic),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
