import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/qag/domain/qag_theme_hebdo.dart';
import 'package:agora/qag/theme/bloc/qags_theme_bloc.dart';
import 'package:agora/qag/theme/bloc/qags_theme_event.dart';
import 'package:agora/qag/theme/bloc/qags_theme_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting("fr_FR", null);

  group("FetchQagsThemeEvent", () {
    blocTest(
      "when repository succesful - should emit loading then success state",
      build: () => QagsThemeBloc(qagRepository: FakeQagSuccessRepository()),
      act: (bloc) => bloc.add(FetchQagsThemeEvent()),
      expect: () => [
        QagsThemeState(status: AllPurposeStatus.loading, qagThemeHebdo: null),
        QagsThemeState(
          status: AllPurposeStatus.success,
          qagThemeHebdo: QagThemeHebdo(
            titre: "titre",
            sousTitre: "sousTitre",
            periode: "periode",
            theme: "theme",
            avatarUrl: "avatarUrl",
            nom: "nom",
            fonction: "fonction",
            prochainsThemes: ["prochainTheme", "prochainTheme2", "prochainTheme3"],
            titreCompteur: "titreCompteur",
            dateFinTheme: "2026-06-04T23:45:00+02:00",
            dateDebutTheme: "2026-05-31T00:15:00+02:00",
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit loading then failure state",
      build: () => QagsThemeBloc(qagRepository: FakeQagFailureRepository()),
      act: (bloc) => bloc.add(FetchQagsThemeEvent()),
      expect: () => [
        QagsThemeState(status: AllPurposeStatus.loading, qagThemeHebdo: null),
        QagsThemeState(status: AllPurposeStatus.error, qagThemeHebdo: null),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
