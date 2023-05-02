import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/bloc/qag/support/qag_support_event.dart';
import 'package:agora/bloc/qag/support/qag_support_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/qag/fake_device_id_helper.dart';
import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  const qagId = "qagId";

  group("Support QaG Event", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => QagSupportBloc(
        qagRepository: FakeQagSuccessRepository(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) => bloc.add(SupportQagEvent(qagId: qagId)),
      expect: () => [
        QagSupportLoadingState(),
        QagSupportSuccessState(),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when device id is null - should emit failure state",
      build: () => QagSupportBloc(
        qagRepository: FakeQagSuccessRepository(),
        deviceInfoHelper: FakeDeviceIdNullHelper(),
      ),
      act: (bloc) => bloc.add(SupportQagEvent(qagId: qagId)),
      expect: () => [
        QagSupportLoadingState(),
        QagSupportErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => QagSupportBloc(
        qagRepository: FakeQagFailureRepository(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) => bloc.add(SupportQagEvent(qagId: qagId)),
      expect: () => [
        QagSupportLoadingState(),
        QagSupportErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("Delete support QaG Event", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => QagSupportBloc(
        qagRepository: FakeQagSuccessRepository(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) => bloc.add(DeleteSupportQagEvent(qagId: qagId)),
      expect: () => [
        QagDeleteSupportLoadingState(),
        QagDeleteSupportSuccessState(),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when device id is null - should emit failure state",
      build: () => QagSupportBloc(
        qagRepository: FakeQagSuccessRepository(),
        deviceInfoHelper: FakeDeviceIdNullHelper(),
      ),
      act: (bloc) => bloc.add(DeleteSupportQagEvent(qagId: qagId)),
      expect: () => [
        QagDeleteSupportLoadingState(),
        QagDeleteSupportErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => QagSupportBloc(
        qagRepository: FakeQagFailureRepository(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) => bloc.add(DeleteSupportQagEvent(qagId: qagId)),
      expect: () => [
        QagDeleteSupportLoadingState(),
        QagDeleteSupportErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
