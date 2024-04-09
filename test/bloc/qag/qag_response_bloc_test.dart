import 'package:agora/bloc/qag/response/qag_response_bloc.dart';
import 'package:agora/bloc/qag/response/qag_response_event.dart';
import 'package:agora/bloc/qag/response/qag_response_state.dart';
import 'package:agora/domain/qag/qag_response.dart';
import 'package:agora/domain/thematique/thematique.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  group("FetchQagsResponseEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => QagResponseBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagsResponseEvent()),
      expect: () => [
        QagResponseFetchedState(
          incomingQagResponses: [
            QagResponseIncoming(
              qagId: "qagId2",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "Pour la ...",
              supportCount: 200,
              isSupported: true,
              order: 0,
            ),
          ],
          qagResponses: [
            QagResponse(
              qagId: "qagId",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "Pour la retraite : comment est-ce qu'on aboutit au chiffre de 65 ans ?",
              author: "author",
              authorPortraitUrl: "authorPortraitUrl",
              responseDate: DateTime(2024, 1, 23),
              order: 1,
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => QagResponseBloc(
        qagRepository: FakeQagFailureRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagsResponseEvent()),
      expect: () => [
        QagResponseErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
