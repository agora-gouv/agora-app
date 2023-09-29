import 'package:agora/bloc/qag/similar/has_similar/qag_has_similar_bloc.dart';
import 'package:agora/bloc/qag/similar/has_similar/qag_has_similar_event.dart';
import 'package:agora/bloc/qag/similar/has_similar/qag_has_similar_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  group("QagHasSimilarEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => QagHasSimilarBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc.add(
        QagHasSimilarEvent(title: "qag title"),
      ),
      expect: () => [
        QagHasSimilarLoadingState(),
        QagHasSimilarSuccessState(hasSimilar: true),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => QagHasSimilarBloc(
        qagRepository: FakeQagFailureRepository(),
      ),
      act: (bloc) => bloc.add(
        QagHasSimilarEvent(title: "qag title"),
      ),
      expect: () => [
        QagHasSimilarLoadingState(),
        QagHasSimilarErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
