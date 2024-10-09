import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/welcome/bloc/welcome_bloc.dart';
import 'package:agora/welcome/bloc/welcome_event.dart';
import 'package:agora/welcome/bloc/welcome_state.dart';
import 'package:agora/welcome/domain/welcome_a_la_une.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/welcome/fakes_welcome_repository.dart';

void main() {
  group("GetWelcomeALaUneEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => WelcomeBloc(welcomeRepository: FakeWelcomeSuccessRepository()),
      act: (bloc) => bloc.add(GetWelcomeALaUneEvent()),
      expect: () => [
        WelcomeState(
          status: AllPurposeStatus.success,
          welcomeALaUne: WelcomeALaUne(
            description: "description",
            actionText: "actionText",
            routeName: "routeName",
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => WelcomeBloc(welcomeRepository: FakeWelcomeFailureRepository()),
      act: (bloc) => bloc.add(GetWelcomeALaUneEvent()),
      expect: () => [
        WelcomeState(
          status: AllPurposeStatus.error,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
