import 'package:agora/qag/ask/bloc/search/qag_search_bloc.dart';
import 'package:agora/qag/ask/bloc/search/qag_search_event.dart';
import 'package:agora/qag/ask/bloc/search/qag_search_state.dart';
import 'package:agora/qag/domain/qag.dart';
import 'package:agora/domain/thematique/thematique.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  group("FetchQagsLoadedEvent", () {
    blocTest<QagSearchBloc, QagSearchState>(
      "when fetch qags with success - should emit loaded state",
      build: () => QagSearchBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc.add(
        FetchQagsSearchEvent(keywords: 'test'),
      ),
      expect: () => [
        QagSearchLoadedState(
          qags: [
            Qag(
              id: "id0",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "title0",
              username: "username0",
              date: DateTime(2024, 4, 23),
              supportCount: 8,
              isSupported: true,
              isAuthor: false,
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagSearchBloc, QagSearchState>(
      "when fetch qags with failure - should emit failure state",
      build: () => QagSearchBloc(
        qagRepository: FakeQagFailureRepository(),
      ),
      act: (bloc) => bloc.add(
        FetchQagsSearchEvent(keywords: 'test'),
      ),
      expect: () => [
        QagSearchErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("UpdateQagSupportEvent", () {
    blocTest<QagSearchBloc, QagSearchState>(
      "when qag support support is in non loaded state - should emit nothing",
      build: () => QagSearchBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc.add(UpdateQagSearchSupportEvent.create(qagId: "id0", isSupported: false, supportCount: 7)),
      expect: () => [],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagSearchBloc, QagSearchState>(
      "when qag support support is loaded but could not find qag to update - should emit nothing more than first loaded state",
      build: () => QagSearchBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc
        ..add(FetchQagsSearchEvent(keywords: 'test'))
        ..add(UpdateQagSearchSupportEvent.create(qagId: "idUnknown", isSupported: false, supportCount: 66)),
      expect: () => [
        QagSearchLoadedState(
          qags: [
            Qag(
              id: "id0",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "title0",
              username: "username0",
              date: DateTime(2024, 4, 23),
              supportCount: 8,
              isSupported: true,
              isAuthor: false,
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagSearchBloc, QagSearchState>(
      "when qag support support is loaded and find qag to update - should emit first loaded state then updated loaded state",
      build: () => QagSearchBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc
        ..add(FetchQagsSearchEvent(keywords: 'test'))
        ..add(UpdateQagSearchSupportEvent.create(qagId: "id0", isSupported: false, supportCount: 7)),
      expect: () => [
        QagSearchLoadedState(
          qags: [
            Qag(
              id: "id0",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "title0",
              username: "username0",
              date: DateTime(2024, 4, 23),
              supportCount: 8,
              isSupported: true,
              isAuthor: false,
            ),
          ],
        ),
        QagSearchLoadedState(
          qags: [
            Qag(
              id: "id0",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "title0",
              username: "username0",
              date: DateTime(2024, 4, 23),
              supportCount: 7,
              isSupported: false,
              isAuthor: false,
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
