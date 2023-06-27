import 'package:agora/bloc/qag/response_paginated/qag_response_paginated_bloc.dart';
import 'package:agora/bloc/qag/response_paginated/qag_response_paginated_event.dart';
import 'package:agora/bloc/qag/response_paginated/qag_response_paginated_state.dart';
import 'package:agora/bloc/qag/response_paginated/qag_response_paginated_view_model.dart';
import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  group("FetchQagsResponsePaginatedEvent", () {
    blocTest(
      "when repository succeed and page number to load is 1 - should emit success state",
      build: () => QagResponsePaginatedBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagsResponsePaginatedEvent(pageNumber: 1)),
      expect: () => [
        QagResponsePaginatedLoadingState(
          maxPage: -1,
          currentPageNumber: 1,
          qagResponseViewModels: [],
        ),
        QagResponsePaginatedFetchedState(
          maxPage: 3,
          currentPageNumber: 1,
          qagResponseViewModels: [
            QagResponsePaginatedViewModel(
              qagId: "qagId",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "Pour la ... ?",
              author: "author",
              authorPortraitUrl: "authorPortraitUrl",
              responseDate: "a répondu le 23 janvier",
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagResponsePaginatedBloc, QagResponsePaginatedState>(
      "when repository succeed and page number to load is other than 1 - should emit success state",
      build: () => QagResponsePaginatedBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      seed: () => QagResponsePaginatedFetchedState(
        maxPage: 3,
        currentPageNumber: 1,
        qagResponseViewModels: [
          QagResponsePaginatedViewModel(
            qagId: "qagId1",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "title 1",
            author: "author 1",
            authorPortraitUrl: "authorPortraitUrl 1",
            responseDate: "a répondu le 22 janvier",
          ),
        ],
      ),
      act: (bloc) => bloc.add(FetchQagsResponsePaginatedEvent(pageNumber: 2)),
      expect: () => [
        QagResponsePaginatedLoadingState(
          maxPage: 3,
          currentPageNumber: 2,
          qagResponseViewModels: [
            QagResponsePaginatedViewModel(
              qagId: "qagId1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title 1",
              author: "author 1",
              authorPortraitUrl: "authorPortraitUrl 1",
              responseDate: "a répondu le 22 janvier",
            ),
          ],
        ),
        QagResponsePaginatedFetchedState(
          maxPage: 3,
          currentPageNumber: 2,
          qagResponseViewModels: [
            QagResponsePaginatedViewModel(
              qagId: "qagId1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title 1",
              author: "author 1",
              authorPortraitUrl: "authorPortraitUrl 1",
              responseDate: "a répondu le 22 janvier",
            ),
            QagResponsePaginatedViewModel(
              qagId: "qagId",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "Pour la ... ?",
              author: "author",
              authorPortraitUrl: "authorPortraitUrl",
              responseDate: "a répondu le 23 janvier",
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagResponsePaginatedBloc, QagResponsePaginatedState>(
      "when repository succeed and page number reset to 1 - should emit success state",
      build: () => QagResponsePaginatedBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      seed: () => QagResponsePaginatedFetchedState(
        maxPage: 3,
        currentPageNumber: 2,
        qagResponseViewModels: [
          QagResponsePaginatedViewModel(
            qagId: "qagId 0",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "title 0",
            author: "author 0",
            authorPortraitUrl: "authorPortraitUrl 0",
            responseDate: "a répondu le 22 janvier",
          ),
          QagResponsePaginatedViewModel(
            qagId: "qagId1",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "title 1",
            author: "author 1",
            authorPortraitUrl: "authorPortraitUrl 1",
            responseDate: "a répondu le 22 janvier",
          ),
        ],
      ),
      act: (bloc) => bloc.add(FetchQagsResponsePaginatedEvent(pageNumber: 1)),
      expect: () => [
        QagResponsePaginatedLoadingState(
          maxPage: -1,
          currentPageNumber: 1,
          qagResponseViewModels: [],
        ),
        QagResponsePaginatedFetchedState(
          maxPage: 3,
          currentPageNumber: 1,
          qagResponseViewModels: [
            QagResponsePaginatedViewModel(
              qagId: "qagId",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "Pour la ... ?",
              author: "author",
              authorPortraitUrl: "authorPortraitUrl",
              responseDate: "a répondu le 23 janvier",
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed and page number to load is 1 - should emit failure state",
      build: () => QagResponsePaginatedBloc(
        qagRepository: FakeQagFailureRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagsResponsePaginatedEvent(pageNumber: 1)),
      expect: () => [
        QagResponsePaginatedLoadingState(
          maxPage: -1,
          currentPageNumber: 1,
          qagResponseViewModels: [],
        ),
        QagResponsePaginatedErrorState(
          maxPage: -1,
          currentPageNumber: 1,
          qagResponseViewModels: [],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagResponsePaginatedBloc, QagResponsePaginatedState>(
      "when repository failed and page number to load is other than 1 - should emit failure state",
      build: () => QagResponsePaginatedBloc(
        qagRepository: FakeQagFailureRepository(),
      ),
      seed: () => QagResponsePaginatedFetchedState(
        maxPage: 3,
        currentPageNumber: 1,
        qagResponseViewModels: [
          QagResponsePaginatedViewModel(
            qagId: "qagId1",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "title 1",
            author: "author 1",
            authorPortraitUrl: "authorPortraitUrl 1",
            responseDate: "a répondu le 22 janvier",
          ),
        ],
      ),
      act: (bloc) => bloc.add(FetchQagsResponsePaginatedEvent(pageNumber: 2)),
      expect: () => [
        QagResponsePaginatedLoadingState(
          maxPage: 3,
          currentPageNumber: 2,
          qagResponseViewModels: [
            QagResponsePaginatedViewModel(
              qagId: "qagId1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title 1",
              author: "author 1",
              authorPortraitUrl: "authorPortraitUrl 1",
              responseDate: "a répondu le 22 janvier",
            ),
          ],
        ),
        QagResponsePaginatedErrorState(
          maxPage: 3,
          currentPageNumber: 2,
          qagResponseViewModels: [
            QagResponsePaginatedViewModel(
              qagId: "qagId1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title 1",
              author: "author 1",
              authorPortraitUrl: "authorPortraitUrl 1",
              responseDate: "a répondu le 22 janvier",
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
