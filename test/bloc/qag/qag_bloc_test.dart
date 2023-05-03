import 'package:agora/bloc/qag/qag_bloc.dart';
import 'package:agora/bloc/qag/qag_event.dart';
import 'package:agora/bloc/qag/qag_state.dart';
import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/qag/fake_device_id_helper.dart';
import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  group("FetchQagsEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => QagBloc(
        qagRepository: FakeQagSuccessRepository(),
        deviceIdHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) => bloc.add(FetchQagsEvent()),
      expect: () => [
        QagFetchedState(
          [
            QagResponseViewModel(
              qagId: "qagId",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports", color: 0xFFFCF7CF),
              title: "Pour la retraite : comment est-ce qu’on aboutit au chiffre de 65 ans ?",
              author: "author",
              authorPortraitUrl: "authorPortraitUrl",
              responseDate: "a répondu le 23 janvier",
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when device id is null - should emit failure state",
      build: () => QagBloc(
        qagRepository: FakeQagSuccessRepository(),
        deviceIdHelper: FakeDeviceIdNullHelper(),
      ),
      act: (bloc) => bloc.add(FetchQagsEvent()),
      expect: () => [
        QagErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => QagBloc(
        qagRepository: FakeQagFailureRepository(),
        deviceIdHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) => bloc.add(FetchQagsEvent()),
      expect: () => [
        QagErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
