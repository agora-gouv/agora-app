import 'package:agora/bloc/qag/details/qag_details_bloc.dart';
import 'package:agora/bloc/qag/details/qag_details_event.dart';
import 'package:agora/bloc/qag/details/qag_details_state.dart';
import 'package:agora/bloc/qag/details/qag_details_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  const qagId = "qagId";
  blocTest(
    "fetchQagDetailsEvent - when repository succeed - should emit success state",
    build: () => QagDetailsBloc(qagRepository: FakeQagSuccessRepository()),
    act: (bloc) => bloc.add(FetchQagDetailsEvent(qagId: qagId)),
    expect: () => [
      QagDetailsFetchedState(
        QagDetailsViewModel(
          id: qagId,
          thematiqueId: "1f3dbdc6-cff7-4d6a-88b5-c5ec84c55d15",
          title: "Pour la retraite : comment est-ce qu’on aboutit au chiffre de 65 ans ?",
          description: "Le conseil d’orientation des retraites indique que les comptes sont à l’équilibre.",
          date: "23 janvier",
          username: "CollectifSauvonsLaRetraite",
          supportCount: 112,
        ),
      ),
    ],
    wait: const Duration(milliseconds: 5),
  );

  blocTest(
    "fetchQagDetailsEvent - when repository failed - should emit failure state",
    build: () => QagDetailsBloc(qagRepository: FakeQagFailureRepository()),
    act: (bloc) => bloc.add(FetchQagDetailsEvent(qagId: qagId)),
    expect: () => [
      QagDetailsErrorState(),
    ],
    wait: const Duration(milliseconds: 5),
  );
}
