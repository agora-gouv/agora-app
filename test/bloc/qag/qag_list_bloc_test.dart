import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/common/helper/semantics_helper.dart';
import 'package:agora/qag/domain/header_qag.dart';
import 'package:agora/qag/domain/qag.dart';
import 'package:agora/qag/domain/qag_support.dart';
import 'package:agora/qag/domain/qas_list_filter.dart';
import 'package:agora/qag/list/bloc/qag_list_bloc.dart';
import 'package:agora/qag/list/bloc/qag_list_event.dart';
import 'package:agora/qag/list/bloc/qag_list_state.dart';
import 'package:agora/thematique/domain/thematique.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:optional/optional.dart';

import '../../fakes/qag/fakes_qag_repository.dart';
import '../../fakes/qag/header_qag_storage_client_stub.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  final defaultLoadedState = QagListState(
    status: AllPurposeStatus.success,
    qags: [
      Qag(
        id: "id1",
        description: "description",
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
      message: "headerMessage",
    ),
    currentPage: 1,
    maxPage: 2,
    footerType: QagListFooterType.loaded,
  );

  group("FetchQagsListEvent", () {
    blocTest<QagListBloc, QagListState>(
      "when fetch qags list with success - should emit loaded state",
      build: () => QagListBloc.fromRepositories(
        qagRepository: FakeQagSuccessRepository(),
        headerQagStorageClient: HeaderQagStorageClientNoClosedStub(),
      ),
      act: (bloc) => bloc.add(
        FetchQagsListEvent(thematiqueId: null, thematiqueLabel: null, qagFilter: QagListFilter.top),
      ),
      expect: () => [
        QagListState(
          status: AllPurposeStatus.loading,
          qags: [],
          header: null,
          maxPage: 0,
          footerType: QagListFooterType.loading,
          currentPage: 1,
        ),
        defaultLoadedState,
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagListBloc, QagListState>(
      "when fetch qags list with success and closed header closed - should emit loaded state without header",
      build: () => QagListBloc.fromRepositories(
        qagRepository: FakeQagSuccessRepository(),
        headerQagStorageClient: HeaderQagStorageClientAllClosedStub(),
      ),
      act: (bloc) => bloc.add(
        FetchQagsListEvent(thematiqueId: null, thematiqueLabel: null, qagFilter: QagListFilter.top),
      ),
      expect: () => [
        QagListState(
          status: AllPurposeStatus.loading,
          qags: [],
          header: null,
          maxPage: 0,
          footerType: QagListFooterType.loading,
          currentPage: 1,
        ),
        defaultLoadedState.clone(headerOptional: Optional.ofNullable(null)),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagListBloc, QagListState>(
      "when fetch qags list with failure - should emit failure state",
      build: () => QagListBloc.fromRepositories(
        qagRepository: FakeQagFailureRepository(),
        headerQagStorageClient: HeaderQagStorageClientNoClosedStub(),
      ),
      act: (bloc) => bloc.add(
        FetchQagsListEvent(thematiqueId: null, thematiqueLabel: null, qagFilter: QagListFilter.top),
      ),
      expect: () => [
        QagListState(
          status: AllPurposeStatus.loading,
          qags: [],
          header: null,
          maxPage: 0,
          footerType: QagListFooterType.loading,
          currentPage: 1,
        ),
        QagListState(
          status: AllPurposeStatus.error,
          qags: [],
          header: null,
          maxPage: 0,
          footerType: QagListFooterType.loading,
          currentPage: 1,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("UpdateQagsListEvent", () {
    blocTest<QagListBloc, QagListState>(
      "when update qags list with success - should emit loaded state",
      build: () => QagListBloc.fromRepositories(
        qagRepository: FakeQagSuccessRepository(),
        headerQagStorageClient: HeaderQagStorageClientNoClosedStub(),
        semanticsHelperWrapper: _MockSemanticsHelperWrapper(),
      ),
      act: (bloc) async {
        bloc.add(
          FetchQagsListEvent(
            thematiqueId: 'Transports',
            thematiqueLabel: 'Transports',
            qagFilter: QagListFilter.top,
          ),
        );
        await Future.delayed(Duration(milliseconds: 5));
        bloc.add(UpdateQagsListEvent(thematiqueId: 'Transports', qagFilter: QagListFilter.top));
      },
      expect: () => [
        QagListState(
          status: AllPurposeStatus.loading,
          qags: [],
          header: null,
          maxPage: 0,
          footerType: QagListFooterType.loading,
          currentPage: 1,
        ),
        defaultLoadedState,
        defaultLoadedState.clone(footerType: QagListFooterType.loading),
        defaultLoadedState.clone(
          qags: [
            Qag(
              id: "id1",
              description: "description",
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
              description: "description",
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
      build: () => QagListBloc.fromRepositories(
        qagRepository: FakeQagFailureRepository(),
        headerQagStorageClient: HeaderQagStorageClientNoClosedStub(),
      ),
      act: (bloc) {
        bloc.add(FetchQagsListEvent(thematiqueId: 'Transports', thematiqueLabel: null, qagFilter: QagListFilter.top));
        bloc.add(UpdateQagsListEvent(thematiqueId: 'Transports', qagFilter: QagListFilter.top));
      },
      expect: () => [
        QagListState(
          status: AllPurposeStatus.loading,
          qags: [],
          header: null,
          maxPage: 0,
          footerType: QagListFooterType.loading,
          currentPage: 1,
        ),
        QagListState(
          status: AllPurposeStatus.error,
          qags: [],
          header: null,
          maxPage: 0,
          footerType: QagListFooterType.loading,
          currentPage: 1,
        ),
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
      build: () => QagListBloc.fromRepositories(
        qagRepository: FakeQagSuccessRepository(),
        headerQagStorageClient: HeaderQagStorageClientNoClosedStub(),
      ),
      act: (bloc) {
        bloc.add(UpdateQagListSupportEvent(qagSupport: qagSupportId1));
      },
      expect: () => [],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagListBloc, QagListState>(
      "when qag support is in loaded state but could not find qag to update - should emit nothing more than first loaded state",
      build: () => QagListBloc.fromRepositories(
        qagRepository: FakeQagSuccessRepository(),
        headerQagStorageClient: HeaderQagStorageClientNoClosedStub(),
      ),
      act: (bloc) {
        bloc.add(FetchQagsListEvent(thematiqueId: 'Transports', thematiqueLabel: null, qagFilter: QagListFilter.top));
        bloc.add(UpdateQagListSupportEvent(qagSupport: unknownQag));
      },
      expect: () => [
        QagListState(
          status: AllPurposeStatus.loading,
          qags: [],
          header: null,
          maxPage: 0,
          footerType: QagListFooterType.loading,
          currentPage: 1,
        ),
        defaultLoadedState,
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagListBloc, QagListState>(
      "when qag support is in loaded state and find qag to update - should emit updated loaded state",
      build: () => QagListBloc.fromRepositories(
        qagRepository: FakeQagSuccessRepository(),
        headerQagStorageClient: HeaderQagStorageClientNoClosedStub(),
      ),
      act: (bloc) async {
        bloc.add(FetchQagsListEvent(thematiqueId: 'Transports', thematiqueLabel: null, qagFilter: QagListFilter.top));
        await Future.delayed(Duration(milliseconds: 5));
        bloc.add(UpdateQagListSupportEvent(qagSupport: qagSupportId1));
      },
      expect: () => [
        QagListState(
          status: AllPurposeStatus.loading,
          qags: [],
          header: null,
          maxPage: 0,
          footerType: QagListFooterType.loading,
          currentPage: 1,
        ),
        defaultLoadedState,
        defaultLoadedState.clone(
          qags: [
            Qag(
              id: "id1",
              description: "description",
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

  group("CloseHeaderQagListEvent", () {
    blocTest<QagListBloc, QagListState>(
      "when is in non loaded state - should emit nothing",
      build: () => QagListBloc.fromRepositories(
        qagRepository: FakeQagSuccessRepository(),
        headerQagStorageClient: HeaderQagStorageClientNoClosedStub(),
      ),
      act: (bloc) {
        bloc.add(CloseHeaderQagListEvent(headerId: "headerId"));
      },
      expect: () => [],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagListBloc, QagListState>(
      "when is in loaded state - should emit loaded state without header",
      build: () => QagListBloc.fromRepositories(
        qagRepository: FakeQagSuccessRepository(),
        headerQagStorageClient: HeaderQagStorageClientNoClosedStub(),
      ),
      act: (bloc) async {
        bloc.add(FetchQagsListEvent(thematiqueId: 'Transports', thematiqueLabel: null, qagFilter: QagListFilter.top));
        await Future.delayed(Duration(milliseconds: 5));
        bloc.add(CloseHeaderQagListEvent(headerId: "headerId"));
      },
      expect: () => [
        QagListState(
          status: AllPurposeStatus.loading,
          qags: [],
          header: null,
          maxPage: 0,
          footerType: QagListFooterType.loading,
          currentPage: 1,
        ),
        defaultLoadedState,
        defaultLoadedState.clone(headerOptional: Optional.ofNullable(null)),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}

class _MockSemanticsHelperWrapper extends SemanticsHelperWrapper {
  @override
  void announceThematicChosen(String? thematic, int size) {
    // Do nothing
  }
}
