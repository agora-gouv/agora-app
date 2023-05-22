import 'package:agora/bloc/qag/qag_bloc.dart';
import 'package:agora/bloc/qag/qag_event.dart';
import 'package:agora/bloc/qag/qag_state.dart';
import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  group("FetchQagsEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => QagBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagsEvent(thematiqueId: null)),
      expect: () => [
        QagFetchedState(
          qagResponseViewModels: [
            QagResponseViewModel(
              qagId: "qagId",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "Pour la retraite : comment est-ce qu’on aboutit au chiffre de 65 ans ?",
              author: "author",
              authorPortraitUrl: "authorPortraitUrl",
              responseDate: "a répondu le 23 janvier",
            ),
          ],
          popularViewModels: [
            QagViewModel(
              id: "id1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: "23 janvier",
              supportCount: 7,
              isSupported: true,
            ),
          ],
          latestViewModels: [
            QagViewModel(
              id: "id2",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title2",
              username: "username2",
              date: "23 février",
              supportCount: 8,
              isSupported: false,
            ),
          ],
          supportingViewModels: [
            QagViewModel(
              id: "id3",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title3",
              username: "username3",
              date: "23 mars",
              supportCount: 9,
              isSupported: true,
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => QagBloc(
        qagRepository: FakeQagFailureRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagsEvent(thematiqueId: "anotherThematiqueId")),
      expect: () => [
        QagErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
