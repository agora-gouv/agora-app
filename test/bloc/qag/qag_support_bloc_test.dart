import 'package:agora/qag/details/bloc/support/qag_support_bloc.dart';
import 'package:agora/qag/details/bloc/support/qag_support_event.dart';
import 'package:agora/qag/details/bloc/support/qag_support_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  const qagId = "qagId";

  group("Support QaG Event", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => QagSupportBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc.add(SupportQagEvent(qagId: qagId, supportCount: 1, isSupported: true)),
      expect: () => [
        QagSupportLoadingState(),
        QagSupportSuccessState(qagId: qagId, supportCount: 2, isSupported: false),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => QagSupportBloc(
        qagRepository: FakeQagFailureRepository(),
      ),
      act: (bloc) => bloc.add(SupportQagEvent(qagId: qagId, supportCount: 1, isSupported: true)),
      expect: () => [
        QagSupportLoadingState(),
        QagSupportErrorState(qagId: qagId),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("Delete support QaG Event", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => QagSupportBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc.add(DeleteSupportQagEvent(qagId: qagId, supportCount: 1, isSupported: true)),
      expect: () => [
        QagSupportLoadingState(),
        QagSupportSuccessState(qagId: qagId, supportCount: 0, isSupported: false),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => QagSupportBloc(
        qagRepository: FakeQagFailureRepository(),
      ),
      act: (bloc) => bloc.add(DeleteSupportQagEvent(qagId: qagId, supportCount: 0, isSupported: false)),
      expect: () => [
        QagSupportLoadingState(),
        QagSupportErrorState(qagId: qagId),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
