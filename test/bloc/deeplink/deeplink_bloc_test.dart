import 'package:agora/bloc/deeplink/deeplink_event.dart';
import 'package:agora/bloc/deeplink/deeplink_state.dart';
import 'package:agora/bloc/qag/details/deeplink_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/deeplink/fakes_deep_link_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("consultation deeplink", () {
    blocTest(
      "when receive correct format initial uri consultation deeplink - should emit consultation deeplink state",
      build: () => DeeplinkBloc(deeplinkHelper: FakeConsultationInitialUriDeeplinkHelper()),
      act: (bloc) => bloc.add(InitDeeplinkListenerEvent()),
      expect: () => [
        DeeplinkLoadingState(),
        ConsultationDeeplinkState(consultationId: "c29255f2-10ca-4be5-aab1-801ea173337c"),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when receive correct format stream uri consultation deeplink - should emit consultation deeplink state",
      build: () => DeeplinkBloc(deeplinkHelper: FakeConsultationStreamDeeplinkHelper()),
      act: (bloc) => bloc.add(InitDeeplinkListenerEvent()),
      expect: () => [
        DeeplinkLoadingState(),
        ConsultationDeeplinkState(consultationId: "c29255f2-10ca-4be5-aab1-801ea17333dd"),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
