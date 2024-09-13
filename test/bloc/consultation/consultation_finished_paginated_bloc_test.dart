import 'package:agora/consultation/finished_paginated/bloc/consultation_finished_paginated_bloc.dart';
import 'package:agora/consultation/finished_paginated/bloc/consultation_finished_paginated_event.dart';
import 'package:agora/consultation/finished_paginated/bloc/consultation_finished_paginated_state.dart';
import 'package:agora/consultation/finished_paginated/bloc/consultation_finished_paginated_view_model.dart';
import 'package:agora/consultation/finished_paginated/pages/consultation_finished_paginated_page.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/thematique/bloc/thematique_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/concertation/fakes_concertation_repository.dart';
import '../../fakes/consultation/fakes_consultation_repository.dart';

void main() {
  group("FetchConsultationFinishedPaginatedEvent", () {
    blocTest(
      "when repository succeed and page number to load is 1 - should emit success state",
      build: () => ConsultationPaginatedBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
        concertationRepository: FakesConcertationRepository(),
      ),
      act: (bloc) =>
          bloc.add(FetchConsultationPaginatedEvent(pageNumber: 1, type: ConsultationPaginatedPageType.finished)),
      expect: () => [
        ConsultationFinishedPaginatedLoadingState(
          maxPage: -1,
          currentPageNumber: 1,
          consultationPaginatedViewModels: [],
        ),
        ConsultationPaginatedFetchedState(
          maxPage: 3,
          currentPageNumber: 1,
          consultationPaginatedViewModels: [
            ConsultationPaginatedViewModel(
              id: "consultationId",
              title: "Quelles solutions pour les déserts médicaux ?",
              coverUrl: "coverUrl",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              label: 'label',
              badgeLabel: 'PARIS',
              badgeColor: AgoraColors.badgeDepartemental,
              badgeTextColor: AgoraColors.badgeDepartementalTexte,
            ),
            ConsultationPaginatedViewModel(
              id: "concertationId1",
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
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository succeed and type is answered - should emit success state",
      build: () => ConsultationPaginatedBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
        concertationRepository: FakesConcertationRepository(),
      ),
      act: (bloc) =>
          bloc.add(FetchConsultationPaginatedEvent(pageNumber: 1, type: ConsultationPaginatedPageType.answered)),
      expect: () => [
        ConsultationFinishedPaginatedLoadingState(
          maxPage: -1,
          currentPageNumber: 1,
          consultationPaginatedViewModels: [],
        ),
        ConsultationPaginatedFetchedState(
          maxPage: 3,
          currentPageNumber: 1,
          consultationPaginatedViewModels: [
            ConsultationPaginatedViewModel(
              id: "consultationId",
              title: "Quelles solutions pour les déserts médicaux ?",
              coverUrl: "coverUrl",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              label: 'label',
              badgeLabel: 'PARIS',
              badgeColor: AgoraColors.badgeDepartemental,
              badgeTextColor: AgoraColors.badgeDepartementalTexte,
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<ConsultationPaginatedBloc, ConsultationPaginatedState>(
      "when repository succeed and page number to load is other than 1 - should emit success state",
      build: () => ConsultationPaginatedBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
        concertationRepository: FakesConcertationRepository(),
      ),
      seed: () => ConsultationPaginatedFetchedState(
        maxPage: 3,
        currentPageNumber: 1,
        consultationPaginatedViewModels: [
          ConsultationPaginatedViewModel(
            id: "consultationId1",
            title: "Quelles ... ?",
            coverUrl: "coverUrl1",
            thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
            label: 'label',
            badgeLabel: 'PARIS',
            badgeColor: AgoraColors.badgeDepartemental,
            badgeTextColor: AgoraColors.badgeDepartementalTexte,
          ),
        ],
      ),
      act: (bloc) => bloc.add(
        FetchConsultationPaginatedEvent(
          pageNumber: 2,
          type: ConsultationPaginatedPageType.finished,
        ),
      ),
      expect: () => [
        ConsultationFinishedPaginatedLoadingState(
          maxPage: 3,
          currentPageNumber: 2,
          consultationPaginatedViewModels: [
            ConsultationPaginatedViewModel(
              id: "consultationId1",
              title: "Quelles ... ?",
              coverUrl: "coverUrl1",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              label: 'label',
              badgeLabel: 'PARIS',
              badgeColor: AgoraColors.badgeDepartemental,
              badgeTextColor: AgoraColors.badgeDepartementalTexte,
            ),
          ],
        ),
        ConsultationPaginatedFetchedState(
          maxPage: 3,
          currentPageNumber: 2,
          consultationPaginatedViewModels: [
            ConsultationPaginatedViewModel(
              id: "consultationId1",
              title: "Quelles ... ?",
              coverUrl: "coverUrl1",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              label: 'label',
              badgeLabel: 'PARIS',
              badgeColor: AgoraColors.badgeDepartemental,
              badgeTextColor: AgoraColors.badgeDepartementalTexte,
            ),
            ConsultationPaginatedViewModel(
              id: "consultationId",
              title: "Quelles solutions pour les déserts médicaux ?",
              coverUrl: "coverUrl",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              label: 'label',
              badgeLabel: 'PARIS',
              badgeColor: AgoraColors.badgeDepartemental,
              badgeTextColor: AgoraColors.badgeDepartementalTexte,
            ),
            ConsultationPaginatedViewModel(
              id: "concertationId1",
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
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<ConsultationPaginatedBloc, ConsultationPaginatedState>(
      "when repository succeed and page number reset to 1 - should emit success state",
      build: () => ConsultationPaginatedBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
        concertationRepository: FakesConcertationRepository(),
      ),
      seed: () => ConsultationPaginatedFetchedState(
        maxPage: 3,
        currentPageNumber: 2,
        consultationPaginatedViewModels: [
          ConsultationPaginatedViewModel(
            id: "consultationId1",
            title: "Quelles ... ?",
            coverUrl: "coverUrl1",
            thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
            label: 'label',
            badgeLabel: 'PARIS',
            badgeColor: AgoraColors.badgeDepartemental,
            badgeTextColor: AgoraColors.badgeDepartementalTexte,
          ),
          ConsultationPaginatedViewModel(
            id: "consultationId2",
            title: "Quelles ... ?",
            coverUrl: "coverUrl2",
            thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
            label: 'label',
            badgeLabel: 'PARIS',
            badgeColor: AgoraColors.badgeDepartemental,
            badgeTextColor: AgoraColors.badgeDepartementalTexte,
          ),
        ],
      ),
      act: (bloc) => bloc.add(
        FetchConsultationPaginatedEvent(
          pageNumber: 1,
          type: ConsultationPaginatedPageType.finished,
        ),
      ),
      expect: () => [
        ConsultationFinishedPaginatedLoadingState(
          maxPage: -1,
          currentPageNumber: 1,
          consultationPaginatedViewModels: [],
        ),
        ConsultationPaginatedFetchedState(
          maxPage: 3,
          currentPageNumber: 1,
          consultationPaginatedViewModels: [
            ConsultationPaginatedViewModel(
              id: "consultationId",
              title: "Quelles solutions pour les déserts médicaux ?",
              coverUrl: "coverUrl",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              label: 'label',
              badgeLabel: 'PARIS',
              badgeColor: AgoraColors.badgeDepartemental,
              badgeTextColor: AgoraColors.badgeDepartementalTexte,
            ),
            ConsultationPaginatedViewModel(
              id: "concertationId1",
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
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed and page number to load is 1 - should emit failure state",
      build: () => ConsultationPaginatedBloc(
        consultationRepository: FakeConsultationFailureRepository(),
        concertationRepository: FakesConcertationRepository(),
      ),
      act: (bloc) => bloc.add(
        FetchConsultationPaginatedEvent(
          pageNumber: 1,
          type: ConsultationPaginatedPageType.finished,
        ),
      ),
      expect: () => [
        ConsultationFinishedPaginatedLoadingState(
          maxPage: -1,
          currentPageNumber: 1,
          consultationPaginatedViewModels: [],
        ),
        ConsultationPaginatedErrorState(
          maxPage: -1,
          currentPageNumber: 1,
          consultationPaginatedViewModels: [],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<ConsultationPaginatedBloc, ConsultationPaginatedState>(
      "when repository failed and page number to load is other than 1 - should emit failure state",
      build: () => ConsultationPaginatedBloc(
        consultationRepository: FakeConsultationFailureRepository(),
        concertationRepository: FakesConcertationRepository(),
      ),
      seed: () => ConsultationPaginatedFetchedState(
        maxPage: 3,
        currentPageNumber: 1,
        consultationPaginatedViewModels: [
          ConsultationPaginatedViewModel(
            id: "consultationId1",
            title: "Quelles ... ?",
            coverUrl: "coverUrl1",
            thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
            label: 'label',
            badgeLabel: 'PARIS',
            badgeColor: AgoraColors.badgeDepartemental,
            badgeTextColor: AgoraColors.badgeDepartementalTexte,
          ),
        ],
      ),
      act: (bloc) => bloc.add(
        FetchConsultationPaginatedEvent(
          pageNumber: 2,
          type: ConsultationPaginatedPageType.finished,
        ),
      ),
      expect: () => [
        ConsultationFinishedPaginatedLoadingState(
          maxPage: 3,
          currentPageNumber: 2,
          consultationPaginatedViewModels: [
            ConsultationPaginatedViewModel(
              id: "consultationId1",
              title: "Quelles ... ?",
              coverUrl: "coverUrl1",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              label: 'label',
              badgeLabel: 'PARIS',
              badgeColor: AgoraColors.badgeDepartemental,
              badgeTextColor: AgoraColors.badgeDepartementalTexte,
            ),
          ],
        ),
        ConsultationPaginatedErrorState(
          maxPage: 3,
          currentPageNumber: 2,
          consultationPaginatedViewModels: [
            ConsultationPaginatedViewModel(
              id: "consultationId1",
              title: "Quelles ... ?",
              coverUrl: "coverUrl1",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              label: 'label',
              badgeLabel: 'PARIS',
              badgeColor: AgoraColors.badgeDepartemental,
              badgeTextColor: AgoraColors.badgeDepartementalTexte,
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
