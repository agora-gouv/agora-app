import 'package:agora/bloc/qag/list/qag_list_bloc.dart';
import 'package:agora/bloc/qag/list/qag_list_event.dart';
import 'package:agora/bloc/qag/list/qag_list_state.dart';
import 'package:agora/bloc/qag/qag_list_footer_type.dart';
import 'package:agora/domain/qag/header_qag.dart';
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

  final defaultLoadedState = QagListLoadedState(
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
    header: HeaderQag(
      id: "headerId",
      title: "headerTitle",
      description: "headerMessage",
    ),
    currentPage: 1,
    maxPage: 2,
    footerType: QagListFooterType.loaded,
  );

  group("FetchQagsListEvent", () {
    blocTest<QagListBloc, QagListState>(
      "when fetch qags list with success - should emit loaded state",
      build: () => QagListBloc(
        qagRepository: FakeQagSuccessRepository(),
        qagFilter: QagListFilter.top,
      ),
      act: (bloc) => bloc.add(
        FetchQagsListEvent(thematiqueId: null),
      ),
      expect: () => [
        QagListInitialState(),
        defaultLoadedState,
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagListBloc, QagListState>(
      "when fetch qags list with failure - should emit failure state",
      build: () => QagListBloc(
        qagRepository: FakeQagFailureRepository(),
        qagFilter: QagListFilter.top,
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
    blocTest<QagListBloc, QagListState>(
      "when update qags list with success - should emit loaded state",
      build: () => QagListBloc(
        qagRepository: FakeQagSuccessRepository(),
        qagFilter: QagListFilter.top,
      ),
      act: (bloc) {
        bloc.add(FetchQagsListEvent(thematiqueId: 'Transports'));
        bloc.add(UpdateQagsListEvent(thematiqueId: 'Transports'));
      },
      expect: () => [
        QagListInitialState(),
        defaultLoadedState,
        QagListLoadedState.copyWith(state: defaultLoadedState, footerType: QagListFooterType.loading),
        QagListLoadedState.copyWith(
          state: defaultLoadedState,
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
          footerType: QagListFooterType.loaded,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagListBloc, QagListState>(
      "when update qags list with failure - should emit failure state",
      build: () => QagListBloc(
        qagRepository: FakeQagFailureRepository(),
        qagFilter: QagListFilter.top,
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
    final qagSupportId1 = QagSupport(
      qagId: "id1",
      supportCount: 9,
      isSupported: true,
    );
    final unknownQag = QagSupport(
      qagId: "idUnknown",
      supportCount: 8,
      isSupported: false,
    );

    blocTest<QagListBloc, QagListState>(
      "when qag support is in non loaded state - should emit nothing",
      build: () => QagListBloc(
        qagRepository: FakeQagSuccessRepository(),
        qagFilter: QagListFilter.top,
      ),
      act: (bloc) {
        bloc.add(UpdateQagListSupportEvent(qagSupport: qagSupportId1));
      },
      expect: () => [],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagListBloc, QagListState>(
      "when qag support is in loaded state but could not find qag to update - should emit nothing more than first loaded state",
      build: () => QagListBloc(
        qagRepository: FakeQagSuccessRepository(),
        qagFilter: QagListFilter.top,
      ),
      act: (bloc) {
        bloc.add(FetchQagsListEvent(thematiqueId: 'Transports'));
        bloc.add(UpdateQagListSupportEvent(qagSupport: unknownQag));
      },
      expect: () => [
        QagListInitialState(),
        defaultLoadedState,
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagListBloc, QagListState>(
      "when qag support is in loaded state and find qag to update - should emit updated loaded state",
      build: () => QagListBloc(
        qagRepository: FakeQagSuccessRepository(),
        qagFilter: QagListFilter.top,
      ),
      act: (bloc) {
        bloc.add(FetchQagsListEvent(thematiqueId: 'Transports'));
        bloc.add(UpdateQagListSupportEvent(qagSupport: qagSupportId1));
      },
      expect: () => [
        QagListInitialState(),
        defaultLoadedState,
        QagListLoadedState.copyWith(
          state: defaultLoadedState,
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
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
