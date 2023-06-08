import 'package:agora/bloc/login/login_bloc.dart';
import 'package:agora/bloc/login/login_event.dart';
import 'package:agora/bloc/login/login_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/common/fake_jwt_helper.dart';
import '../../fakes/common/fake_role_helper.dart';
import '../../fakes/login/fake_login_storage_client.dart';
import '../../fakes/login/fakes_login_repository.dart';
import '../../fakes/push_notification/fakes_push_notification_service.dart';
import '../../fakes/qag/fake_device_id_helper.dart';

void main() {
  group("check login event - when signup (loginToken not stored)", () {
    final loginStorage1 = FakeLoginStorageClient();
    final jwtHelper1 = FakeJwtHelper();
    final roleHelper1 = FakeRoleHelper();
    blocTest(
      "when repository success - should emit success state",
      build: () => LoginBloc(
        repository: FakeLoginSuccessRepository(),
        loginStorageClient: loginStorage1,
        deviceInfoHelper: FakeDeviceInfoHelper(),
        pushNotificationService: FakePushNotificationService(),
        jwtHelper: jwtHelper1,
        roleHelper: roleHelper1,
      ),
      act: (bloc) => bloc.add(CheckLoginEvent()),
      expect: () => [
        LoginLoadingState(),
        LoginSuccessState(),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () async {
        expect(await loginStorage1.getUserId(), "userId");
        expect(await loginStorage1.getLoginToken(), "loginToken");
        expect(jwtHelper1.getJwtToken(), "jwtToken");
        expect(roleHelper1.isModerator(), true);
      },
    );

    final loginStorage2 = FakeLoginStorageClient();
    final jwtHelper2 = FakeJwtHelper();
    final roleHelper2 = FakeRoleHelper();
    blocTest(
      "when repository failed - should emit error state",
      build: () => LoginBloc(
        repository: FakeLoginFailureRepository(),
        loginStorageClient: loginStorage2,
        deviceInfoHelper: FakeDeviceInfoHelper(),
        pushNotificationService: FakePushNotificationService(),
        jwtHelper: jwtHelper2,
        roleHelper: roleHelper2,
      ),
      act: (bloc) => bloc.add(CheckLoginEvent()),
      expect: () => [
        LoginLoadingState(),
        LoginErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () async {
        expect(await loginStorage2.getUserId(), null);
        expect(await loginStorage2.getLoginToken(), null);
        expect(jwtHelper2.getJwtToken(), null);
        expect(roleHelper2.isModerator(), null);
      },
    );
  });

  group("check login event - when login (loginToken in storage)", () {
    final jwtHelper1 = FakeJwtHelper();
    final roleHelper1 = FakeRoleHelper();
    final signUpLoginStorage = FakeLoginStorageClient();
    blocTest(
      "when repository success - should emit login success state",
      setUp: () => signUpLoginStorage.save(userId: "userId", loginToken: "loginToken"),
      build: () => LoginBloc(
        repository: FakeLoginSuccessRepository(),
        loginStorageClient: signUpLoginStorage,
        deviceInfoHelper: FakeDeviceInfoHelper(),
        pushNotificationService: FakePushNotificationService(),
        jwtHelper: jwtHelper1,
        roleHelper: roleHelper1,
      ),
      act: (bloc) => bloc.add(CheckLoginEvent()),
      expect: () => [
        LoginLoadingState(),
        LoginSuccessState(),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () {
        expect(jwtHelper1.getJwtToken(), "jwtToken");
        expect(roleHelper1.isModerator(), false);
      },
    );

    final jwtHelper2 = FakeJwtHelper();
    final roleHelper2 = FakeRoleHelper();
    final signUpLoginStorage2 = FakeLoginStorageClient();
    blocTest(
      "when repository failed - should emit error state",
      setUp: () => signUpLoginStorage2.save(userId: "userId", loginToken: "loginToken"),
      build: () => LoginBloc(
        repository: FakeLoginFailureRepository(),
        loginStorageClient: signUpLoginStorage2,
        deviceInfoHelper: FakeDeviceInfoHelper(),
        pushNotificationService: FakePushNotificationService(),
        jwtHelper: jwtHelper2,
        roleHelper: roleHelper2,
      ),
      act: (bloc) => bloc.add(CheckLoginEvent()),
      expect: () => [
        LoginLoadingState(),
        LoginErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () {
        expect(jwtHelper2.getJwtToken(), null);
        expect(roleHelper2.isModerator(), null);
      },
    );
  });
}
