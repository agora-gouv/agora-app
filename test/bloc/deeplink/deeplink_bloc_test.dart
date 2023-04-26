import 'package:agora/bloc/deeplink/deeplink_event.dart';
import 'package:agora/bloc/deeplink/deeplink_state.dart';
import 'package:agora/bloc/qag/details/deeplink_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/deeplink/fakes_deep_link_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("initial deeplink", () {
    group("common", () {
      blocTest(
        "when receive null uri deeplink - should emit empty state",
        build: () => DeeplinkBloc(deeplinkHelper: FakeNullInitialUriDeeplinkHelper()),
        act: (bloc) => bloc.add(InitDeeplinkListenerEvent()),
        expect: () => [
          DeeplinkLoadingState(),
          DeeplinkEmptyState(),
        ],
        wait: const Duration(milliseconds: 5),
      );

      blocTest(
        "when receive unknown host deeplink - should emit empty state",
        build: () => DeeplinkBloc(deeplinkHelper: FakeUnknownHostInitialDeeplinkHelper()),
        act: (bloc) => bloc.add(InitDeeplinkListenerEvent()),
        expect: () => [
          DeeplinkLoadingState(),
          DeeplinkEmptyState(),
        ],
        wait: const Duration(milliseconds: 5),
      );
    });

    group("consultation deeplink", () {
      blocTest(
        "when receive correct consultation deeplink - should emit consultation deeplink state",
        build: () => DeeplinkBloc(deeplinkHelper: FakeConsultationCorrectInitialUriDeeplinkHelper()),
        act: (bloc) => bloc.add(InitDeeplinkListenerEvent()),
        expect: () => [
          DeeplinkLoadingState(),
          ConsultationDeeplinkState(consultationId: "c29255f2-10ca-4be5-aab1-801ea173337c"),
        ],
        wait: const Duration(milliseconds: 5),
      );

      blocTest(
        "when receive incorrect consultation deeplink - should emit empty state",
        build: () => DeeplinkBloc(deeplinkHelper: FakeConsultationIncorrectInitialUriDeeplinkHelper()),
        act: (bloc) => bloc.add(InitDeeplinkListenerEvent()),
        expect: () => [
          DeeplinkLoadingState(),
          DeeplinkEmptyState(),
        ],
        wait: const Duration(milliseconds: 5),
      );
    });

    group("QaG deeplink", () {
      blocTest(
        "when receive correct QaG deeplink - should emit QaG deeplink state",
        build: () => DeeplinkBloc(deeplinkHelper: FakeQaGCorrectInitialUriDeeplinkHelper()),
        act: (bloc) => bloc.add(InitDeeplinkListenerEvent()),
        expect: () => [
          DeeplinkLoadingState(),
          QagDeeplinkState(qagId: "c29255f2-10ca-4be5-aab1-801ea173337c"),
        ],
        wait: const Duration(milliseconds: 5),
      );

      blocTest(
        "when receive incorrect QaG deeplink - should emit empty state",
        build: () => DeeplinkBloc(deeplinkHelper: FakeQaGIncorrectInitialUriDeeplinkHelper()),
        act: (bloc) => bloc.add(InitDeeplinkListenerEvent()),
        expect: () => [
          DeeplinkLoadingState(),
          DeeplinkEmptyState(),
        ],
        wait: const Duration(milliseconds: 5),
      );
    });
  });

  group("uri link stream", () {
    const skip = 2; // skip initial uri state
    group("common", () {
      blocTest(
        "when receive null uri deeplink - should emit empty state",
        build: () => DeeplinkBloc(deeplinkHelper: FakeNullUriInStreamHelper()),
        act: (bloc) => bloc.add(InitDeeplinkListenerEvent()),
        skip: skip,
        expect: () => [
          DeeplinkLoadingState(),
          DeeplinkEmptyState(),
        ],
        wait: const Duration(milliseconds: 5),
      );

      blocTest(
        "when receive unknown host deeplink - should emit empty state",
        build: () => DeeplinkBloc(deeplinkHelper: FakeUnknownHostInStreamHelper()),
        act: (bloc) => bloc.add(InitDeeplinkListenerEvent()),
        skip: skip,
        expect: () => [
          DeeplinkLoadingState(),
          DeeplinkEmptyState(),
        ],
        wait: const Duration(milliseconds: 5),
      );
    });

    group("consultation deeplink", () {
      blocTest(
        "when receive correct consultation deeplink - should emit consultation deeplink state",
        build: () => DeeplinkBloc(deeplinkHelper: FakeConsultationStreamCorrectDeeplinkHelper()),
        act: (bloc) => bloc.add(InitDeeplinkListenerEvent()),
        skip: skip,
        expect: () => [
          DeeplinkLoadingState(),
          ConsultationDeeplinkState(consultationId: "c29255f2-10ca-4be5-aab1-801ea17333dd"),
        ],
        wait: const Duration(milliseconds: 5),
      );

      blocTest(
        "when receive incorrect consultation deeplink - should emit empty state",
        build: () => DeeplinkBloc(deeplinkHelper: FakeConsultationStreamIncorrectDeeplinkHelper()),
        act: (bloc) => bloc.add(InitDeeplinkListenerEvent()),
        skip: skip,
        expect: () => [
          DeeplinkLoadingState(),
          DeeplinkEmptyState(),
        ],
        wait: const Duration(milliseconds: 5),
      );
    });

    group("QaG deeplink", () {
      blocTest(
        "when receive correct QaG deeplink - should emit QaG deeplink state",
        build: () => DeeplinkBloc(deeplinkHelper: FakeQaGStreamCorrectDeeplinkHelper()),
        act: (bloc) => bloc.add(InitDeeplinkListenerEvent()),
        skip: skip,
        expect: () => [
          DeeplinkLoadingState(),
          QagDeeplinkState(qagId: "c29255f2-10ca-4be5-aab1-801ea17333dd"),
        ],
        wait: const Duration(milliseconds: 5),
      );

      blocTest(
        "when receive incorrect QaG deeplink - should emit empty state",
        build: () => DeeplinkBloc(deeplinkHelper: FakeQaGStreamIncorrectDeeplinkHelper()),
        act: (bloc) => bloc.add(InitDeeplinkListenerEvent()),
        skip: skip,
        expect: () => [
          DeeplinkLoadingState(),
          DeeplinkEmptyState(),
        ],
        wait: const Duration(milliseconds: 5),
      );
    });
  });
}
