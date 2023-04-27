import 'package:agora/bloc/login/login_bloc.dart';
import 'package:agora/bloc/login/login_event.dart';
import 'package:agora/bloc/login/login_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/login/fake_login_storage_client.dart';
import '../../fakes/login/fakes_login_repository.dart';
import '../../fakes/push_notification/fakes_push_notification_service.dart';
import '../../fakes/qag/fake_device_id_helper.dart';

void main() {
  group("check login event", () {
    blocTest(
      "when user is not yet login (userId not in stock) with deviceId is null - should emit error state",
      build: () => LoginBloc(
        repository: FakeLoginNoImportantRepository(),
        loginStorageClient: FakeLoginStorageClient(),
        deviceInfoHelper: FakeDeviceIdNullHelper(),
        pushNotificationService: FakePushNotificationService(),
      ),
      act: (bloc) => bloc.add(CheckLoginEvent()),
      expect: () => [
        LoginErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );

    final loginStorage1 = FakeLoginStorageClient();
    blocTest(
      "when user is not yet login (userId not in stock) with deviceId not null and repository success - should emit success state",
      build: () => LoginBloc(
        repository: FakeLoginSuccessRepository(),
        loginStorageClient: loginStorage1,
        deviceInfoHelper: FakeDeviceInfoHelper(),
        pushNotificationService: FakePushNotificationService(),
      ),
      act: (bloc) => bloc.add(CheckLoginEvent()),
      expect: () => [
        LoginSuccessState(),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () {
        expect(loginStorage1.userId, "userId");
      },
    );

    final loginStorage2 = FakeLoginStorageClient();
    blocTest(
      "when user is not yet login (userId not in stock) with deviceId not null and repository failed - should emit error state",
      build: () => LoginBloc(
        repository: FakeLoginFailureRepository(),
        loginStorageClient: loginStorage2,
        deviceInfoHelper: FakeDeviceInfoHelper(),
        pushNotificationService: FakePushNotificationService(),
      ),
      act: (bloc) => bloc.add(CheckLoginEvent()),
      expect: () => [
        LoginErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () {
        expect(loginStorage2.userId, null);
      },
    );

    final loginStorage3 = FakeLoginStorageClient();
    blocTest(
      "when user is already login (userId in stock) - should emit login success state",
      setUp: () => loginStorage3.save("userId"),
      build: () => LoginBloc(
        repository: FakeLoginNoImportantRepository(),
        loginStorageClient: loginStorage3,
        deviceInfoHelper: FakeDeviceInfoHelper(),
        pushNotificationService: FakePushNotificationService(),
      ),
      act: (bloc) => bloc.add(CheckLoginEvent()),
      expect: () => [
        LoginSuccessState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
