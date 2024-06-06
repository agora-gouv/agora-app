import 'package:agora/app_feedback/bloc/app_feedback_bloc.dart';
import 'package:agora/app_feedback/bloc/app_feedback_event.dart';
import 'package:agora/app_feedback/bloc/app_feedback_state.dart';
import 'package:agora/app_feedback/repository/app_feedback_repository.dart';
import 'package:agora/domain/feedback/device_informations.dart';
import 'package:agora/domain/feedback/feedback.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/qag/fake_device_id_helper.dart';

void main() {
  final bug = AppFeedback(
    type: AppFeedbackType.bug,
    description: 'description',
  );
  final comment = AppFeedback(
    type: AppFeedbackType.comment,
    description: 'description',
  );
  final feature = AppFeedback(
    type: AppFeedbackType.feature,
    description: 'description',
  );
  final deviceInfo = DeviceInformation(appVersion: 'appVersion', model: 'model', osVersion: 'osVersion');

  group('SendAppFeedbackEvent', () {
    blocTest(
      'when repository succeed - should emit success state - for bug',
      build: () => AppFeedbackBloc(
        repository: _FakeAppFeedbackRepository(true, bug, deviceInfo),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) {
        return bloc.add(SendAppFeedbackEvent(bug));
      },
      expect: () => [
        AppFeedbackState.loading,
        AppFeedbackState.success,
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      'when repository succeed - should emit success state - for feature',
      build: () => AppFeedbackBloc(
        repository: _FakeAppFeedbackRepository(true, feature, deviceInfo),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) {
        return bloc.add(SendAppFeedbackEvent(feature));
      },
      expect: () => [
        AppFeedbackState.loading,
        AppFeedbackState.success,
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      'when repository succeed - should emit success state - for comment',
      build: () => AppFeedbackBloc(
        repository: _FakeAppFeedbackRepository(true, comment, deviceInfo),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) {
        return bloc.add(SendAppFeedbackEvent(comment));
      },
      expect: () => [
        AppFeedbackState.loading,
        AppFeedbackState.success,
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      'when repository fails - should emit error state',
      build: () => AppFeedbackBloc(
        repository: _FakeAppFeedbackRepository(false, comment, deviceInfo),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) {
        return bloc.add(SendAppFeedbackEvent(comment));
      },
      expect: () => [
        AppFeedbackState.loading,
        AppFeedbackState.error,
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  blocTest(
    'ReinitAppFeedbackEvent',
    build: () => AppFeedbackBloc(
      repository: _FakeAppFeedbackRepository(true, bug, deviceInfo),
      deviceInfoHelper: FakeDeviceInfoHelper(),
    ),
    act: (bloc) async {
      bloc.add(SendAppFeedbackEvent(bug));
      await Future.delayed(Duration(milliseconds: 10));
      bloc.add(ReinitAppFeedbackEvent());
    },
    expect: () => [
      AppFeedbackState.loading,
      AppFeedbackState.success,
      AppFeedbackState.initial,
    ],
    wait: const Duration(milliseconds: 15),
  );

  blocTest(
    'ReinitAppFeedbackEvent',
    build: () => AppFeedbackBloc(
      repository: _FakeAppFeedbackRepository(true, bug, deviceInfo),
      deviceInfoHelper: FakeDeviceInfoHelper(),
    ),
    act: (bloc) {
      bloc.add(AppFeedbackMailSentEvent());
    },
    expect: () => [
      AppFeedbackState.success,
    ],
    wait: const Duration(milliseconds: 5),
  );
}

class _FakeAppFeedbackRepository extends AppFeedbackRepository {
  final bool success;
  final AppFeedback expectedAppFeedback;
  final DeviceInformation? expectedDeviceInfo;

  _FakeAppFeedbackRepository(this.success, this.expectedAppFeedback, this.expectedDeviceInfo);

  @override
  Future<bool> sendFeedback(AppFeedback feedback, DeviceInformation deviceInformations) async {
    return success && feedback == expectedAppFeedback && deviceInformations == expectedDeviceInfo;
  }
}
