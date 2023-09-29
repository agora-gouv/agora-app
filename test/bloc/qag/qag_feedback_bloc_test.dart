import 'package:agora/bloc/qag/feedback/qag_feedback_bloc.dart';
import 'package:agora/bloc/qag/feedback/qag_feedback_event.dart';
import 'package:agora/bloc/qag/feedback/qag_feedback_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  const qagId = "qagId";

  group("QaG feedback Event", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => QagFeedbackBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc.add(QagFeedbackEvent(qagId: qagId, isHelpful: true)),
      expect: () => [
        QagFeedbackLoadingState(),
        QagFeedbackSuccessState(),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => QagFeedbackBloc(
        qagRepository: FakeQagFailureRepository(),
      ),
      act: (bloc) => bloc.add(QagFeedbackEvent(qagId: qagId, isHelpful: true)),
      expect: () => [
        QagFeedbackLoadingState(),
        QagFeedbackErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
