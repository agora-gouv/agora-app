import 'package:agora/bloc/qag/details/qag_details_bloc.dart';
import 'package:agora/bloc/qag/details/qag_details_event.dart';
import 'package:agora/bloc/qag/details/qag_details_state.dart';
import 'package:agora/bloc/qag/details/qag_details_view_model.dart';
import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  const qagId = "qagId";

  group("fetchQagDetailsEvent", () {
    blocTest(
      "when repository succeed with support not null and response null - should emit success state",
      build: () => QagDetailsBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagDetailsEvent(qagId: qagId)),
      expect: () => [
        QagDetailsFetchedState(
          QagDetailsViewModel(
            id: qagId,
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "Pour la retraite : comment est-ce qu’on aboutit au chiffre de 65 ans ?",
            description: "Le conseil d’orientation des retraites indique que les comptes sont à l’équilibre.",
            date: "23 janvier",
            username: "CollectifSauvonsLaRetraite",
            support: QagDetailsSupportViewModel(count: 112, isSupported: true),
            response: null,
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository succeed with support null and response not null - should emit success state",
      build: () => QagDetailsBloc(
        qagRepository: FakeQagSuccessWithSupportNullAndResponseNotNullRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagDetailsEvent(qagId: qagId)),
      expect: () => [
        QagDetailsFetchedState(
          QagDetailsViewModel(
            id: qagId,
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "Pour la retraite : comment est-ce qu’on aboutit au chiffre de 65 ans ?",
            description: "Le conseil d’orientation des retraites indique que les comptes sont à l’équilibre.",
            date: "23 janvier",
            username: "CollectifSauvonsLaRetraite",
            support: null,
            response: QagDetailsResponseViewModel(
              author: "Olivier Véran",
              authorDescription: "Ministre délégué auprès de...",
              responseDate: "20 février",
              videoUrl: "https://betagouv.github.io/agora-content/QaG-Stormtrooper-Response.mp4",
              transcription: "Blablabla",
              feedbackStatus: true,
            ),
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed with qag moderate error - should emit failure state",
      build: () => QagDetailsBloc(
        qagRepository: FakeQagDetailsModerateFailureRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagDetailsEvent(qagId: qagId)),
      expect: () => [
        QagDetailsModerateErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
    blocTest(
      "when repository failed - should emit failure state",
      build: () => QagDetailsBloc(
        qagRepository: FakeQagFailureRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagDetailsEvent(qagId: qagId)),
      expect: () => [
        QagDetailsErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
