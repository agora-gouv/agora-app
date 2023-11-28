import 'package:agora/bloc/qag/search/qag_search_bloc.dart';
import 'package:agora/bloc/qag/search/qag_search_event.dart';
import 'package:agora/bloc/qag/search/qag_search_state.dart';
import 'package:agora/domain/qag/qag.dart';
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
      "when qags is going to be search - should emit loading state",
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
  });
}
