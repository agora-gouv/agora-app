import 'package:agora/bloc/qag/similar/qag_similar_bloc.dart';
import 'package:agora/bloc/qag/similar/qag_similar_event.dart';
import 'package:agora/bloc/qag/similar/qag_similar_state.dart';
import 'package:agora/bloc/qag/similar/qag_similar_view_model.dart';
import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  group("GetQagSimilarEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => QagSimilarBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc.add(GetQagSimilarEvent(title: "qag similar title")),
      expect: () => [
        QagSimilarLoadingState(),
        QagSimilarSuccessState(
          similarQags: [
            QagSimilarViewModel(
              id: "id",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title",
              description: "description",
              username: "username",
              date: "23 avril",
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
      build: () => QagSimilarBloc(
        qagRepository: FakeQagFailureRepository(),
      ),
      act: (bloc) => bloc.add(GetQagSimilarEvent(title: "qag similar title")),
      expect: () => [
        QagSimilarLoadingState(),
        QagSimilarErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("UpdateSimilarQagEvent", () {
    blocTest<QagSimilarBloc, QagSimilarState>(
      "when update support - should emit updated state",
      build: () => QagSimilarBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      seed: () => QagSimilarSuccessState(
        similarQags: [
          QagSimilarViewModel(
            id: "qagId",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "title",
            description: "description",
            username: "username",
            date: "23 avril",
            supportCount: 9,
            isSupported: false,
          ),
        ],
      ),
      act: (bloc) => bloc.add(
        UpdateSimilarQagEvent(
          qagId: "qagId",
          supportCount: 10,
          isSupported: true,
        ),
      ),
      expect: () => [
        QagSimilarSuccessState(
          similarQags: [
            QagSimilarViewModel(
              id: "qagId",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title",
              description: "description",
              username: "username",
              date: "23 avril",
              supportCount: 10,
              isSupported: true,
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
