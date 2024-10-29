import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/qag/ask/bloc/ask_qag_status_bloc.dart';
import 'package:agora/qag/ask/bloc/ask_qag_status_event.dart';
import 'package:agora/qag/ask/bloc/ask_qag_status_state.dart';
import 'package:agora/qag/domain/qags_error_type.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  group("FetchAskQagStatusEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => AskQagStatusBloc.fromRepositories(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc.add(FetchAskQagStatusEvent()),
      expect: () => [
        AskQagStatusState(
          status: AllPurposeStatus.success,
          askQagError: "askQagError",
          errorType: QagsErrorType.generic,
        ),
      ],
    );

    blocTest(
      "when repository fails - should emit error state",
      build: () => AskQagStatusBloc.fromRepositories(
        qagRepository: FakeQagFailureRepository(),
      ),
      act: (bloc) => bloc.add(FetchAskQagStatusEvent()),
      expect: () => [
        AskQagStatusState(
          status: AllPurposeStatus.error,
          askQagError: null,
          errorType: QagsErrorType.generic,
        ),
      ],
    );
  });
}
