import 'package:agora/bloc/notification/notification_bloc.dart';
import 'package:agora/bloc/notification/notification_event.dart';
import 'package:agora/bloc/notification/notification_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/common/fake_first_connection_storage_client.dart';
import '../../fakes/common/fake_permission_helper.dart';
import '../../fakes/common/fake_platform_helper.dart';
import '../../fakes/qag/fake_device_id_helper.dart';

void main() {
  group("Request notification permission event", () {
    final fakeFirstConnectionStorageClient = FakeFirstConnectionStorageClient();

    blocTest(
      "when is first connection with notification permission denied and ios platform - should emit auto ask state",
      setUp: () => fakeFirstConnectionStorageClient.save(true),
      build: () => NotificationBloc(
        firstConnectionStorageClient: fakeFirstConnectionStorageClient,
        permissionHelper: FakeNotificationIsDeniedHelper(),
        platformHelper: FakePlatformIOSHelper(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) => bloc.add(RequestNotificationPermissionEvent()),
      expect: () => [
        AutoAskNotificationConsentState(),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () {
        expect(fakeFirstConnectionStorageClient.isFirstConnectionStorage, false);
      },
    );

    blocTest(
      "when is first connection with notification permission denied and android platform SDK above or equals 33 - should emit auto ask state",
      setUp: () => fakeFirstConnectionStorageClient.save(true),
      build: () => NotificationBloc(
        firstConnectionStorageClient: fakeFirstConnectionStorageClient,
        permissionHelper: FakeNotificationIsDeniedHelper(),
        platformHelper: FakePlatformAndroidHelper(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) => bloc.add(RequestNotificationPermissionEvent()),
      expect: () => [
        AutoAskNotificationConsentState(),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () {
        expect(fakeFirstConnectionStorageClient.isFirstConnectionStorage, false);
      },
    );

    blocTest(
      "when is first connection with notification permission denied and android platform SDK below 33 - should emit ask state",
      setUp: () => fakeFirstConnectionStorageClient.save(true),
      build: () => NotificationBloc(
        firstConnectionStorageClient: fakeFirstConnectionStorageClient,
        permissionHelper: FakeNotificationIsDeniedHelper(),
        platformHelper: FakePlatformAndroidHelper(),
        deviceInfoHelper: FakeAndroidSdkBelow33Helper(),
      ),
      act: (bloc) => bloc.add(RequestNotificationPermissionEvent()),
      expect: () => [
        AskNotificationConsentState(),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () {
        expect(fakeFirstConnectionStorageClient.isFirstConnectionStorage, false);
      },
    );

    blocTest(
      "when is first connection with notification permission permanently denied - should emit ask state",
      setUp: () => fakeFirstConnectionStorageClient.save(true),
      build: () => NotificationBloc(
        firstConnectionStorageClient: fakeFirstConnectionStorageClient,
        permissionHelper: FakeNotificationIsPermanentlyDeniedHelper(),
        platformHelper: FakePlatformAndroidHelper(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) => bloc.add(RequestNotificationPermissionEvent()),
      expect: () => [
        AskNotificationConsentState(),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () {
        expect(fakeFirstConnectionStorageClient.isFirstConnectionStorage, false);
      },
    );
  });
}
