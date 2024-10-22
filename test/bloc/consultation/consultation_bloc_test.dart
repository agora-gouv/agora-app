import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/consultation/bloc/consultation_bloc.dart';
import 'package:agora/consultation/bloc/consultation_event.dart';
import 'package:agora/consultation/bloc/consultation_state.dart';
import 'package:agora/consultation/bloc/consultation_view_model.dart';
import 'package:agora/consultation/domain/consultations_error_type.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/thematique/bloc/thematique_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/concertation/fakes_concertation_repository.dart';
import '../../fakes/consultation/fakes_consultation_repository.dart';
import '../../fakes/referentiel/fakes_referentiel_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  group("fetchConsultationsEvent", () {
    blocTest(
      "when repository succeed - should emit loading then success state",
      build: () => ConsultationBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
        concertationRepository: FakesConcertationRepository(),
        referentielRepository: FakesReferentielRepository(),
      ),
      act: (bloc) => bloc.add(FetchConsultationsEvent()),
      expect: () => [
        ConsultationState.init(AllPurposeStatus.loading),
        ConsultationState(
          status: AllPurposeStatus.success,
          ongoingViewModels: [
            ConsultationOngoingViewModel(
              id: "consultationId",
              slug: "consultationId",
              title: "Développer le covoiturage au quotidien",
              coverUrl: "coverUrl1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              endDate: "23 janvier",
              label: "Plus que 3 jours",
              badgeLabel: 'PARIS',
              badgeColor: AgoraColors.badgeDepartemental,
              badgeTextColor: AgoraColors.badgeDepartementalTexte,
            ),
          ],
          finishedViewModels: [
            ConsultationFinishedViewModel(
              id: "consultationId2",
              slug: "consultationId2",
              title: "Quelles solutions pour les déserts médicaux ?",
              coverUrl: "coverUrl2",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              label: 'label',
              badgeLabel: 'PARIS',
              badgeColor: AgoraColors.badgeDepartemental,
              badgeTextColor: AgoraColors.badgeDepartementalTexte,
            ),
            ConcertationViewModel(
              id: "concertationId1",
              slug: "concertationId1",
              title: "Développer le covoiturage",
              coverUrl: "coverUrl1",
              externalLink: "externalLink1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              label: 'Plus que 3 jours',
              badgeLabel: 'PARIS',
              badgeColor: AgoraColors.badgeDepartemental,
              badgeTextColor: AgoraColors.badgeDepartementalTexte,
            ),
          ],
          answeredViewModels: [
            ConsultationAnsweredViewModel(
              id: "consultationId3",
              slug: "consultationId3",
              title: "Quand commencer ?",
              coverUrl: "coverUrl3",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              label: 'label',
              badgeLabel: 'PARIS',
              badgeColor: AgoraColors.badgeDepartemental,
              badgeTextColor: AgoraColors.badgeDepartementalTexte,
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
        referentielRepository: FakesReferentielRepository(),
      ),
      act: (bloc) => bloc.add(FetchConsultationsEvent()),
      expect: () => [
        ConsultationState.init(AllPurposeStatus.loading),
        ConsultationState(
          status: AllPurposeStatus.success,
          ongoingViewModels: [
            ConsultationOngoingViewModel(
              id: "consultationId",
              slug: "consultationId",
              title: "Développer le covoiturage au quotidien",
              coverUrl: "coverUrl",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              endDate: "23 janvier",
              label: null,
              badgeLabel: 'PARIS',
              badgeColor: AgoraColors.badgeDepartemental,
              badgeTextColor: AgoraColors.badgeDepartementalTexte,
            ),
          ],
          finishedViewModels: [
            ConsultationFinishedViewModel(
              id: "consultationId",
              slug: "consultationId",
              title: "Développer le covoiturage au quotidien",
              coverUrl: "coverUrl",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              label: null,
              badgeLabel: 'PARIS',
              badgeColor: AgoraColors.badgeDepartemental,
              badgeTextColor: AgoraColors.badgeDepartementalTexte,
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
        referentielRepository: FakesReferentielRepository(),
      ),
      act: (bloc) => bloc.add(FetchConsultationsEvent()),
      expect: () => [
        ConsultationState.init(AllPurposeStatus.loading),
        ConsultationState(
          status: AllPurposeStatus.error,
          ongoingViewModels: [],
          finishedViewModels: [],
          answeredViewModels: [],
          shouldDisplayFinishedAllButton: false,
          errorType: ConsultationsErrorType.timeout,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit loading then failure state",
      build: () => ConsultationBloc(
        consultationRepository: FakeConsultationFailureRepository(),
        concertationRepository: FakesConcertationRepository(),
        referentielRepository: FakesReferentielRepository(),
      ),
      act: (bloc) => bloc.add(FetchConsultationsEvent()),
      expect: () => [
        ConsultationState.init(AllPurposeStatus.loading),
        ConsultationState(
          status: AllPurposeStatus.error,
          ongoingViewModels: [],
          finishedViewModels: [],
          answeredViewModels: [],
          shouldDisplayFinishedAllButton: false,
          errorType: ConsultationsErrorType.generic,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
