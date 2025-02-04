import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/qag/domain/qag_response.dart';
import 'package:agora/reponse/bloc/qag_response_bloc.dart';
import 'package:agora/reponse/bloc/qag_response_event.dart';
import 'package:agora/reponse/bloc/qag_response_state.dart';
import 'package:agora/thematique/domain/thematique.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/qag/fake_qag_repository.dart';
import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  group("FetchQagsResponseEvent", () {
    blocTest(
      "when repository succeed - should emit loading then success state",
      build: () => QagResponseBloc(
        previousState: QagResponseState.init(),
        qagRepository: FakeQagCacheSuccessRepository(qagRepository: FakeQagSuccessRepository()),
      ),
      act: (bloc) => bloc.add(FetchQagsResponseEvent()),
      expect: () => [
        QagResponseState(status: AllPurposeStatus.loading, incomingQagResponses: [], qagResponses: []),
        QagResponseState(
          status: AllPurposeStatus.success,
          incomingQagResponses: [
            QagResponseIncoming(
              qagId: "qagId2",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "Pour la ...",
              supportCount: 200,
              isSupported: true,
              order: 0,
              dateLundiPrecedent: DateTime(2024, 6, 3),
              dateLundiSuivant: DateTime(2024, 6, 10),
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
      "when repository failed - should emit loading then failure state",
      build: () => QagResponseBloc(
        previousState: QagResponseState.init(),
        qagRepository: FakeQagCacheFailureRepository(qagRepository: FakeQagFailureRepository()),
      ),
      act: (bloc) => bloc.add(FetchQagsResponseEvent()),
      expect: () => [
        QagResponseState(status: AllPurposeStatus.loading, incomingQagResponses: [], qagResponses: []),
        QagResponseState(status: AllPurposeStatus.error, incomingQagResponses: [], qagResponses: []),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
