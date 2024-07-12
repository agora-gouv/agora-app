import 'package:agora/qag/details/bloc/delete/qag_delete_bloc.dart';
import 'package:agora/qag/details/bloc/delete/qag_delete_event.dart';
import 'package:agora/qag/details/bloc/delete/qag_delete_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  const qagId = "qagId";

  group("Delete QaG Event", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => QagDeleteBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc.add(DeleteQagEvent(qagId: qagId)),
      expect: () => [
        QagDeleteLoadingState(),
        QagDeleteSuccessState(),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => QagDeleteBloc(
        qagRepository: FakeQagFailureRepository(),
      ),
      act: (bloc) => bloc.add(DeleteQagEvent(qagId: qagId)),
      expect: () => [
        QagDeleteLoadingState(),
        QagDeleteErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
