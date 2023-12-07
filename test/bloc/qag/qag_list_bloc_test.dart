import 'package:agora/bloc/qag/list/qag_list_bloc.dart';
import 'package:agora/bloc/qag/list/qag_list_event.dart';
import 'package:agora/bloc/qag/list/qag_list_state.dart';
import 'package:agora/domain/qag/qag.dart';
import 'package:agora/domain/qag/qag_support.dart';
import 'package:agora/domain/qag/qas_list_filter.dart';
import 'package:agora/domain/thematique/thematique.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  group("FetchQagsListEvent", () {
    const fakeFilter = QagListFilter.top;
    blocTest<QagListBloc, QagListState>(
      "when fetch qags list with success - should emit loaded state",
      build: () => QagListBloc(
        qagRepository: FakeQagSuccessRepository(),
        qagFilter: fakeFilter,
      ),
      act: (bloc) => bloc.add(
        FetchQagsListEvent(thematiqueId: null),
      ),
      expect: () => [
        QagListInitialState(),
        QagListLoadedState(
          qags: [
            Qag(
              id: "id1",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: DateTime(2024, 2, 23),
              supportCount: 8,
              isSupported: false,
              isAuthor: false,
            ),
          ],
          currentPage: 1,
          maxPage: 2,
          isLoadingMore: false,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagListBloc, QagListState>(
      "when fetch qags list with failure - should emit failure state",
      build: () => QagListBloc(
        qagRepository: FakeQagFailureRepository(),
        qagFilter: fakeFilter,
      ),
      act: (bloc) => bloc.add(
        FetchQagsListEvent(thematiqueId: null),
      ),
      expect: () => [
        QagListInitialState(),
        QagListErrorState(currentPage: 1),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("UpdateQagsListEvent", () {
    const fakeFilter = QagListFilter.top;
    blocTest<QagListBloc, QagListState>(
      "when update qags list with success - should emit loaded state",
      build: () => QagListBloc(
        qagRepository: FakeQagSuccessRepository(),
        qagFilter: fakeFilter,
      ),
      act: (bloc) {
        bloc.add(FetchQagsListEvent(thematiqueId: 'Transports'));
        bloc.add(UpdateQagsListEvent(thematiqueId: 'Transports'));
      },
      expect: () => [
        QagListInitialState(),
        QagListLoadedState(
          qags: [
            Qag(
              id: "id1",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: DateTime(2024, 2, 23),
              supportCount: 8,
              isSupported: false,
              isAuthor: false,
            ),
          ],
          currentPage: 1,
          maxPage: 2,
          isLoadingMore: false,
        ),
        QagListLoadedState(
          qags: [
            Qag(
              id: "id1",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: DateTime(2024, 2, 23),
              supportCount: 8,
              isSupported: false,
              isAuthor: false,
            ),
          ],
          currentPage: 1,
          maxPage: 2,
          isLoadingMore: true,
        ),
        QagListLoadedState(
          qags: [
            Qag(
              id: "id1",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: DateTime(2024, 2, 23),
              supportCount: 8,
              isSupported: false,
              isAuthor: false,
            ),
            Qag(
              id: "id2",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: DateTime(2024, 2, 23),
              supportCount: 8,
              isSupported: true,
              isAuthor: false,
            ),
          ],
          currentPage: 2,
          maxPage: 2,
          isLoadingMore: false,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagListBloc, QagListState>(
      "when update qags list with failure - should emit failure state",
      build: () => QagListBloc(
        qagRepository: FakeQagFailureRepository(),
        qagFilter: fakeFilter,
      ),
      act: (bloc) {
        bloc.add(FetchQagsListEvent(thematiqueId: 'Transports'));
        bloc.add(UpdateQagsListEvent(thematiqueId: 'Transports'));
      },
      expect: () => [
        QagListInitialState(),
        QagListErrorState(currentPage: 1),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("UpdateQagListSupportEvent", () {
    const fakeFilter = QagListFilter.top;
    final fakeQagSupport = QagSupport(
      qagId: "id1",
      supportCount: 9,
      isSupported: true,
    );
    final fakeUnknownQag = QagSupport(
      qagId: "idUnknown",
      supportCount: 8,
      isSupported: false,
    );

    blocTest<QagListBloc, QagListState>(
      "when qag support is in non loaded state - should emit nothing",
      build: () => QagListBloc(
        qagRepository: FakeQagSuccessRepository(),
        qagFilter: fakeFilter,
      ),
      act: (bloc) {
        bloc.add(UpdateQagListSupportEvent(qagSupport: fakeQagSupport));
      },
      expect: () => [],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagListBloc, QagListState>(
      "when qag support is in loaded state but could not find qag to update - should emit nothing more than first loaded state",
      build: () => QagListBloc(
        qagRepository: FakeQagSuccessRepository(),
        qagFilter: fakeFilter,
      ),
      act: (bloc) {
        bloc.add(FetchQagsListEvent(thematiqueId: 'Transports'));
        bloc.add(UpdateQagListSupportEvent(qagSupport: fakeUnknownQag));
      },
      expect: () => [
        QagListInitialState(),
        QagListLoadedState(
          qags: [
            Qag(
              id: "id1",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: DateTime(2024, 2, 23),
              supportCount: 8,
              isSupported: false,
              isAuthor: false,
            ),
          ],
          currentPage: 1,
          maxPage: 2,
          isLoadingMore: false,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagListBloc, QagListState>(
      "when qag support is in loaded state and find qag to update - should emit nothing updated loaded state",
      build: () => QagListBloc(
        qagRepository: FakeQagSuccessRepository(),
        qagFilter: fakeFilter,
      ),
      act: (bloc) {
        bloc.add(FetchQagsListEvent(thematiqueId: 'Transports'));
        bloc.add(UpdateQagListSupportEvent(qagSupport: fakeQagSupport));
      },
      expect: () => [
        QagListInitialState(),
        QagListLoadedState(
          qags: [
            Qag(
              id: "id1",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: DateTime(2024, 2, 23),
              supportCount: 8,
              isSupported: false,
              isAuthor: false,
            ),
          ],
          currentPage: 1,
          maxPage: 2,
          isLoadingMore: false,
        ),
        QagListLoadedState(
          qags: [
            Qag(
              id: "id1",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: DateTime(2024, 2, 23),
              supportCount: 9,
              isSupported: true,
              isAuthor: false,
            ),
          ],
          currentPage: 1,
          maxPage: 2,
          isLoadingMore: false,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
