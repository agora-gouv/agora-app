import 'package:agora/bloc/qag/paginated/bloc/qag_paginated_latest_bloc.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_event.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_state.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_view_model.dart';
import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  group("FetchQagsPaginatedEvent", () {
    blocTest(
      "when repository succeed and page number to load is 1 - should emit success state",
      build: () => QagPaginatedLatestBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagsPaginatedEvent(thematiqueId: null, pageNumber: 1)),
      expect: () => [
        QagPaginatedLoadingState(
          maxPage: -1,
          currentPageNumber: 1,
          qagViewModels: [],
        ),
        QagPaginatedFetchedState(
          maxPage: 3,
          currentPageNumber: 1,
          qagViewModels: [
            QagPaginatedViewModel(
              id: "id1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: "23 février",
              supportCount: 8,
              isSupported: false,
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagPaginatedLatestBloc, QagPaginatedState>(
      "when repository succeed and page number to load is other than 1 - should emit success state",
      build: () => QagPaginatedLatestBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      seed: () => QagPaginatedFetchedState(
        maxPage: 3,
        currentPageNumber: 1,
        qagViewModels: [
          QagPaginatedViewModel(
            id: "id1",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "title1",
            username: "username1",
            date: "23 février",
            supportCount: 8,
            isSupported: false,
          ),
        ],
      ),
      act: (bloc) => bloc.add(FetchQagsPaginatedEvent(thematiqueId: null, pageNumber: 2)),
      expect: () => [
        QagPaginatedLoadingState(
          maxPage: 3,
          currentPageNumber: 2,
          qagViewModels: [
            QagPaginatedViewModel(
              id: "id1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: "23 février",
              supportCount: 8,
              isSupported: false,
            ),
          ],
        ),
        QagPaginatedFetchedState(
          maxPage: 3,
          currentPageNumber: 2,
          qagViewModels: [
            QagPaginatedViewModel(
              id: "id1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: "23 février",
              supportCount: 8,
              isSupported: false,
            ),
            QagPaginatedViewModel(
              id: "id2",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title2",
              username: "username2",
              date: "23 mars",
              supportCount: 9,
              isSupported: true,
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagPaginatedLatestBloc, QagPaginatedState>(
      "when repository succeed and page number reset to 1 - should emit success state",
      build: () => QagPaginatedLatestBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      seed: () => QagPaginatedFetchedState(
        maxPage: 3,
        currentPageNumber: 2,
        qagViewModels: [
          QagPaginatedViewModel(
            id: "id11",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "title11",
            username: "username11",
            date: "23 février",
            supportCount: 8,
            isSupported: false,
          ),
          QagPaginatedViewModel(
            id: "id22",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "title22",
            username: "username22",
            date: "23 mars",
            supportCount: 9,
            isSupported: true,
          ),
        ],
      ),
      act: (bloc) => bloc.add(FetchQagsPaginatedEvent(thematiqueId: null, pageNumber: 1)),
      expect: () => [
        QagPaginatedLoadingState(
          maxPage: -1,
          currentPageNumber: 1,
          qagViewModels: [],
        ),
        QagPaginatedFetchedState(
          maxPage: 3,
          currentPageNumber: 1,
          qagViewModels: [
            QagPaginatedViewModel(
              id: "id1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: "23 février",
              supportCount: 8,
              isSupported: false,
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed and page number to load is 1 - should emit failure state",
      build: () => QagPaginatedLatestBloc(
        qagRepository: FakeQagFailureRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagsPaginatedEvent(thematiqueId: null, pageNumber: 1)),
      expect: () => [
        QagPaginatedLoadingState(
          maxPage: -1,
          currentPageNumber: 1,
          qagViewModels: [],
        ),
        QagPaginatedErrorState(
          maxPage: -1,
          currentPageNumber: 1,
          qagViewModels: [],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagPaginatedLatestBloc, QagPaginatedState>(
      "when repository failed and page number to load is other than 1 - should emit failure state",
      build: () => QagPaginatedLatestBloc(
        qagRepository: FakeQagFailureRepository(),
      ),
      seed: () => QagPaginatedFetchedState(
        maxPage: 3,
        currentPageNumber: 1,
        qagViewModels: [
          QagPaginatedViewModel(
            id: "id1",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "title1",
            username: "username1",
            date: "23 février",
            supportCount: 8,
            isSupported: false,
          ),
        ],
      ),
      act: (bloc) => bloc.add(FetchQagsPaginatedEvent(thematiqueId: null, pageNumber: 2)),
      expect: () => [
        QagPaginatedLoadingState(
          maxPage: 3,
          currentPageNumber: 2,
          qagViewModels: [
            QagPaginatedViewModel(
              id: "id1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: "23 février",
              supportCount: 8,
              isSupported: false,
            ),
          ],
        ),
        QagPaginatedErrorState(
          maxPage: 3,
          currentPageNumber: 2,
          qagViewModels: [
            QagPaginatedViewModel(
              id: "id1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: "23 février",
              supportCount: 8,
              isSupported: false,
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
