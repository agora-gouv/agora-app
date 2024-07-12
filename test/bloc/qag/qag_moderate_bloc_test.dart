import 'package:agora/qag/moderation/bloc/moderate/qag_moderate_bloc.dart';
import 'package:agora/qag/moderation/bloc/moderate/qag_moderate_event.dart';
import 'package:agora/qag/moderation/bloc/moderate/qag_moderate_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  group("QagModerateEvent", () {
    const qagId = "qagId";
    blocTest(
      "when repository succeed - should emit success state",
      build: () => QagModerateBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc.add(QagModerateEvent(qagId: qagId, isAccept: true)),
      expect: () => [
        QagModerateLoadingState(qagId: qagId, isAccept: true),
        QagModerateSuccessState(qagId: qagId),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => QagModerateBloc(
        qagRepository: FakeQagFailureRepository(),
      ),
      act: (bloc) => bloc.add(QagModerateEvent(qagId: qagId, isAccept: true)),
      expect: () => [
        QagModerateLoadingState(qagId: qagId, isAccept: true),
        QagModerateErrorState(qagId: qagId),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
