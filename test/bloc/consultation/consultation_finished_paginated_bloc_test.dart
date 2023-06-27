import 'package:agora/bloc/consultation/finished_paginated/consultation_finished_paginated_bloc.dart';
import 'package:agora/bloc/consultation/finished_paginated/consultation_finished_paginated_event.dart';
import 'package:agora/bloc/consultation/finished_paginated/consultation_finished_paginated_state.dart';
import 'package:agora/bloc/consultation/finished_paginated/consultation_finished_paginated_view_model.dart';
import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/consultation/fakes_consultation_repository.dart';

void main() {
  group("FetchConsultationFinishedPaginatedEvent", () {
    blocTest(
      "when repository succeed and page number to load is 1 - should emit success state",
      build: () => ConsultationFinishedPaginatedBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
      ),
      act: (bloc) => bloc.add(FetchConsultationFinishedPaginatedEvent(pageNumber: 1)),
      expect: () => [
        ConsultationFinishedPaginatedLoadingState(
          maxPage: -1,
          currentPageNumber: 1,
          consultationFinishedViewModels: [],
        ),
        ConsultationFinishedPaginatedFetchedState(
          maxPage: 3,
          currentPageNumber: 1,
          consultationFinishedViewModels: [
            ConsultationFinishedPaginatedViewModel(
              id: "consultationId",
              title: "Quelles solutions pour les déserts médicaux ?",
              coverUrl: "coverUrl",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              step: 2,
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<ConsultationFinishedPaginatedBloc, ConsultationFinishedPaginatedState>(
      "when repository succeed and page number to load is other than 1 - should emit success state",
      build: () => ConsultationFinishedPaginatedBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
      ),
      seed: () => ConsultationFinishedPaginatedFetchedState(
        maxPage: 3,
        currentPageNumber: 1,
        consultationFinishedViewModels: [
          ConsultationFinishedPaginatedViewModel(
            id: "consultationId1",
            title: "Quelles ... ?",
            coverUrl: "coverUrl1",
            thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
            step: 2,
          ),
        ],
      ),
      act: (bloc) => bloc.add(FetchConsultationFinishedPaginatedEvent(pageNumber: 2)),
      expect: () => [
        ConsultationFinishedPaginatedLoadingState(
          maxPage: 3,
          currentPageNumber: 2,
          consultationFinishedViewModels: [
            ConsultationFinishedPaginatedViewModel(
              id: "consultationId1",
              title: "Quelles ... ?",
              coverUrl: "coverUrl1",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              step: 2,
            ),
          ],
        ),
        ConsultationFinishedPaginatedFetchedState(
          maxPage: 3,
          currentPageNumber: 2,
          consultationFinishedViewModels: [
            ConsultationFinishedPaginatedViewModel(
              id: "consultationId1",
              title: "Quelles ... ?",
              coverUrl: "coverUrl1",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              step: 2,
            ),
            ConsultationFinishedPaginatedViewModel(
              id: "consultationId",
              title: "Quelles solutions pour les déserts médicaux ?",
              coverUrl: "coverUrl",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              step: 2,
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<ConsultationFinishedPaginatedBloc, ConsultationFinishedPaginatedState>(
      "when repository succeed and page number reset to 1 - should emit success state",
      build: () => ConsultationFinishedPaginatedBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
      ),
      seed: () => ConsultationFinishedPaginatedFetchedState(
        maxPage: 3,
        currentPageNumber: 2,
        consultationFinishedViewModels: [
          ConsultationFinishedPaginatedViewModel(
            id: "consultationId1",
            title: "Quelles ... ?",
            coverUrl: "coverUrl1",
            thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
            step: 2,
          ),
          ConsultationFinishedPaginatedViewModel(
            id: "consultationId2",
            title: "Quelles ... ?",
            coverUrl: "coverUrl2",
            thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
            step: 2,
          ),
        ],
      ),
      act: (bloc) => bloc.add(FetchConsultationFinishedPaginatedEvent(pageNumber: 1)),
      expect: () => [
        ConsultationFinishedPaginatedLoadingState(
          maxPage: -1,
          currentPageNumber: 1,
          consultationFinishedViewModels: [],
        ),
        ConsultationFinishedPaginatedFetchedState(
          maxPage: 3,
          currentPageNumber: 1,
          consultationFinishedViewModels: [
            ConsultationFinishedPaginatedViewModel(
              id: "consultationId",
              title: "Quelles solutions pour les déserts médicaux ?",
              coverUrl: "coverUrl",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              step: 2,
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed and page number to load is 1 - should emit failure state",
      build: () => ConsultationFinishedPaginatedBloc(
        consultationRepository: FakeConsultationFailureRepository(),
      ),
      act: (bloc) => bloc.add(FetchConsultationFinishedPaginatedEvent(pageNumber: 1)),
      expect: () => [
        ConsultationFinishedPaginatedLoadingState(
          maxPage: -1,
          currentPageNumber: 1,
          consultationFinishedViewModels: [],
        ),
        ConsultationFinishedPaginatedErrorState(
          maxPage: -1,
          currentPageNumber: 1,
          consultationFinishedViewModels: [],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<ConsultationFinishedPaginatedBloc, ConsultationFinishedPaginatedState>(
      "when repository failed and page number to load is other than 1 - should emit failure state",
      build: () => ConsultationFinishedPaginatedBloc(
        consultationRepository: FakeConsultationFailureRepository(),
      ),
      seed: () => ConsultationFinishedPaginatedFetchedState(
        maxPage: 3,
        currentPageNumber: 1,
        consultationFinishedViewModels: [
          ConsultationFinishedPaginatedViewModel(
            id: "consultationId1",
            title: "Quelles ... ?",
            coverUrl: "coverUrl1",
            thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
            step: 2,
          ),
        ],
      ),
      act: (bloc) => bloc.add(FetchConsultationFinishedPaginatedEvent(pageNumber: 2)),
      expect: () => [
        ConsultationFinishedPaginatedLoadingState(
          maxPage: 3,
          currentPageNumber: 2,
          consultationFinishedViewModels: [
            ConsultationFinishedPaginatedViewModel(
              id: "consultationId1",
              title: "Quelles ... ?",
              coverUrl: "coverUrl1",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              step: 2,
            ),
          ],
        ),
        ConsultationFinishedPaginatedErrorState(
          maxPage: 3,
          currentPageNumber: 2,
          consultationFinishedViewModels: [
            ConsultationFinishedPaginatedViewModel(
              id: "consultationId1",
              title: "Quelles ... ?",
              coverUrl: "coverUrl1",
              thematique: ThematiqueViewModel(picto: "🩺", label: "Santé"),
              step: 2,
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
