import 'package:agora/bloc/notification/permission/notification_permission_bloc.dart';
import 'package:agora/bloc/notification/permission/notification_permission_event.dart';
import 'package:agora/bloc/notification/permission/notification_permission_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/common/fake_platform_helper.dart';
import '../../fakes/notification/fake_notification_first_request_permission_storage_client.dart';
import '../../fakes/notification/fake_permission_helper.dart';
import '../../fakes/qag/fake_device_id_helper.dart';

void main() {
  group("Request notification permission event", () {
    final fakeNotificationFirstRequestPermissionStorageClient = FakeNotificationFirstRequestPermissionStorageClient();

    blocTest(
      "when is first connection with notification permission denied and ios platform - should emit auto ask state",
      setUp: () => fakeNotificationFirstRequestPermissionStorageClient.save(true),
      build: () => NotificationPermissionBloc(
        notificationFirstRequestPermissionStorageClient: fakeNotificationFirstRequestPermissionStorageClient,
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
        expect(fakeNotificationFirstRequestPermissionStorageClient.isFirstConnectionStorage, false);
      },
    );

    blocTest(
      "when is first connection with notification permission denied and android platform SDK above or equals 33 - should emit auto ask state",
      setUp: () => fakeNotificationFirstRequestPermissionStorageClient.save(true),
      build: () => NotificationPermissionBloc(
        notificationFirstRequestPermissionStorageClient: fakeNotificationFirstRequestPermissionStorageClient,
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
        expect(fakeNotificationFirstRequestPermissionStorageClient.isFirstConnectionStorage, false);
      },
    );

    blocTest(
      "when is first connection with notification permission denied and android platform SDK below 33 - should emit ask state",
      setUp: () => fakeNotificationFirstRequestPermissionStorageClient.save(true),
      build: () => NotificationPermissionBloc(
        notificationFirstRequestPermissionStorageClient: fakeNotificationFirstRequestPermissionStorageClient,
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
        expect(fakeNotificationFirstRequestPermissionStorageClient.isFirstConnectionStorage, false);
      },
    );

    blocTest(
      "when is first connection with notification permission permanently denied - should emit ask state",
      setUp: () => fakeNotificationFirstRequestPermissionStorageClient.save(true),
      build: () => NotificationPermissionBloc(
        notificationFirstRequestPermissionStorageClient: fakeNotificationFirstRequestPermissionStorageClient,
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
        expect(fakeNotificationFirstRequestPermissionStorageClient.isFirstConnectionStorage, false);
      },
    );
  });
}
