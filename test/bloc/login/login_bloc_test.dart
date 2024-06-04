import 'package:agora/login/bloc/login_bloc.dart';
import 'package:agora/login/bloc/login_event.dart';
import 'package:agora/login/bloc/login_state.dart';
import 'package:agora/login/domain/login_error_type.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/common/fake_app_version_helper.dart';
import '../../fakes/common/fake_jwt_helper.dart';
import '../../fakes/common/fake_platform_helper.dart';
import '../../fakes/common/fake_role_helper.dart';
import '../../fakes/login/fake_login_storage_client.dart';
import '../../fakes/login/fakes_login_repository.dart';
import '../../fakes/push_notification/fakes_push_notification_service.dart';
import '../../fakes/qag/fake_device_id_helper.dart';
import '../../fakes/welcome/fakes_welcome_repository.dart';

void main() {
  group("check login event - when signup (loginToken not stored)", () {
    final loginStorage1 = FakeLoginStorageClient();
    final jwtHelper1 = FakeJwtHelper();
    final roleHelper1 = FakeRoleHelper();

    blocTest(
      "when repository success - should emit success state",
      build: () => LoginBloc(
        loginRepository: FakeLoginSuccessRepository(),
        welcomeRepository: FakeWelcomeSuccessRepository(),
        loginStorageClient: loginStorage1,
        deviceInfoHelper: FakeDeviceInfoHelper(),
        pushNotificationService: FakePushNotificationService(),
        jwtHelper: jwtHelper1,
        roleHelper: roleHelper1,
        appVersionHelper: FakeAppVersionHelper(),
        platformHelper: FakePlatformAndroidHelper(),
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
      "when repository failed with timeout - should emit error state",
      build: () => LoginBloc(
        loginRepository: FakeLoginTimeoutFailureRepository(),
        welcomeRepository: FakeWelcomeSuccessRepository(),
        loginStorageClient: loginStorage2,
        deviceInfoHelper: FakeDeviceInfoHelper(),
        pushNotificationService: FakePushNotificationService(),
        jwtHelper: jwtHelper2,
        roleHelper: roleHelper2,
        appVersionHelper: FakeAppVersionHelper(),
        platformHelper: FakePlatformAndroidHelper(),
      ),
      act: (bloc) => bloc.add(CheckLoginEvent()),
      expect: () => [
        LoginLoadingState(),
        LoginErrorState(errorType: LoginErrorType.timeout),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () async {
        expect(await loginStorage2.getUserId(), null);
        expect(await loginStorage2.getLoginToken(), null);
        expect(jwtHelper2.getJwtToken(), null);
        expect(roleHelper2.isModerator(), null);
      },
    );

    final loginStorage3 = FakeLoginStorageClient();
    final jwtHelper3 = FakeJwtHelper();
    final roleHelper3 = FakeRoleHelper();
    blocTest(
      "when repository failed - should emit error state",
      build: () => LoginBloc(
        loginRepository: FakeLoginFailureRepository(),
        welcomeRepository: FakeWelcomeSuccessRepository(),
        loginStorageClient: loginStorage3,
        deviceInfoHelper: FakeDeviceInfoHelper(),
        pushNotificationService: FakePushNotificationService(),
        jwtHelper: jwtHelper3,
        roleHelper: roleHelper3,
        appVersionHelper: FakeAppVersionHelper(),
        platformHelper: FakePlatformAndroidHelper(),
      ),
      act: (bloc) => bloc.add(CheckLoginEvent()),
      expect: () => [
        LoginLoadingState(),
        LoginErrorState(errorType: LoginErrorType.generic),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () async {
        expect(await loginStorage3.getUserId(), null);
        expect(await loginStorage3.getLoginToken(), null);
        expect(jwtHelper3.getJwtToken(), null);
        expect(roleHelper3.isModerator(), null);
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
        loginRepository: FakeLoginSuccessRepository(),
        welcomeRepository: FakeWelcomeSuccessRepository(),
        loginStorageClient: signUpLoginStorage,
        deviceInfoHelper: FakeDeviceInfoHelper(),
        pushNotificationService: FakePushNotificationService(),
        jwtHelper: jwtHelper1,
        roleHelper: roleHelper1,
        appVersionHelper: FakeAppVersionHelper(),
        platformHelper: FakePlatformAndroidHelper(),
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
      "when repository failed with timeout - should emit error state",
      setUp: () => signUpLoginStorage2.save(userId: "userId", loginToken: "loginToken"),
      build: () => LoginBloc(
        loginRepository: FakeLoginTimeoutFailureRepository(),
        welcomeRepository: FakeWelcomeSuccessRepository(),
        loginStorageClient: signUpLoginStorage2,
        deviceInfoHelper: FakeDeviceInfoHelper(),
        pushNotificationService: FakePushNotificationService(),
        jwtHelper: jwtHelper2,
        roleHelper: roleHelper2,
        appVersionHelper: FakeAppVersionHelper(),
        platformHelper: FakePlatformAndroidHelper(),
      ),
      act: (bloc) => bloc.add(CheckLoginEvent()),
      expect: () => [
        LoginLoadingState(),
        LoginErrorState(errorType: LoginErrorType.timeout),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () {
        expect(jwtHelper2.getJwtToken(), null);
        expect(roleHelper2.isModerator(), null);
      },
    );

    final jwtHelper3 = FakeJwtHelper();
    final roleHelper3 = FakeRoleHelper();
    final signUpLoginStorage3 = FakeLoginStorageClient();
    blocTest(
      "when repository failed - should emit error state",
      setUp: () => signUpLoginStorage3.save(userId: "userId", loginToken: "loginToken"),
      build: () => LoginBloc(
        loginRepository: FakeLoginFailureRepository(),
        welcomeRepository: FakeWelcomeSuccessRepository(),
        loginStorageClient: signUpLoginStorage3,
        deviceInfoHelper: FakeDeviceInfoHelper(),
        pushNotificationService: FakePushNotificationService(),
        jwtHelper: jwtHelper3,
        roleHelper: roleHelper3,
        appVersionHelper: FakeAppVersionHelper(),
        platformHelper: FakePlatformAndroidHelper(),
      ),
      act: (bloc) => bloc.add(CheckLoginEvent()),
      expect: () => [
        LoginLoadingState(),
        LoginErrorState(errorType: LoginErrorType.generic),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () {
        expect(jwtHelper3.getJwtToken(), null);
        expect(roleHelper3.isModerator(), null);
      },
    );
  });
}
