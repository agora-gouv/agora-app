import 'package:agora/common/storage/secure_storage_client.dart';
import 'package:agora/infrastructure/login/login_storage_client.dart';
import 'package:agora/infrastructure/notification/notification_first_request_permission_storage_client.dart';
import 'package:agora/infrastructure/onboarding/onboarding_storage_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static SecureStorageClient _getSecureStorageClient(SharedPreferences sharedPref) {
    if (GetIt.instance.isRegistered<FlutterSecureStorageClient>()) {
      return GetIt.instance.get<FlutterSecureStorageClient>();
    }
    final client = FlutterSecureStorageClient(
      secureStorage: FlutterSecureStorage(),
      sharedPref: sharedPref,
    );
    GetIt.instance.registerSingleton(client);
    return client;
  }

  static NotificationFirstRequestPermissionStorageClient getFirstConnectionStorageClient() {
    if (GetIt.instance.isRegistered<NotificationFirstRequestPermissionSharedPreferencesClient>()) {
      return GetIt.instance.get<NotificationFirstRequestPermissionSharedPreferencesClient>();
    }
    final storage = NotificationFirstRequestPermissionSharedPreferencesClient();
    GetIt.instance.registerSingleton(storage);
    return storage;
  }

  static LoginStorageClient getLoginStorageClient(SharedPreferences sharedPref) {
    if (GetIt.instance.isRegistered<LoginSharedPreferencesClient>()) {
      return GetIt.instance.get<LoginSharedPreferencesClient>();
    }
    final storage = LoginSharedPreferencesClient(secureStorageClient: _getSecureStorageClient(sharedPref));
    GetIt.instance.registerSingleton(storage);
    return storage;
  }

  static OnboardingStorageClient getOnboardingStorageClient() {
    if (GetIt.instance.isRegistered<OnboardingSharedPreferencesClient>()) {
      return GetIt.instance.get<OnboardingSharedPreferencesClient>();
    }
    final storage = OnboardingSharedPreferencesClient();
    GetIt.instance.registerSingleton(storage);
    return storage;
  }
}
