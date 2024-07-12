import 'package:agora/profil/participation_charter/bloc/participation_charter_bloc.dart';
import 'package:agora/profil/participation_charter/bloc/participation_charter_event.dart';
import 'package:agora/profil/participation_charter/bloc/participation_charter_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/fakes_participation_charter_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting("fr_FR", null);

  group("GetParticipationCharterEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => PartcipationCharterBloc(
        repository: FakeParticipationCharterSuccessRepository(),
      ),
      act: (bloc) => bloc.add(GetParticipationCharterEvent()),
      expect: () => [
        GetParticipationCharterLoadingState(),
        GetParticipationCharterLoadedState(
          extraText: 'RichText',
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
