import 'package:agora/common/storage/first_connection_storage_client.dart';
import 'package:agora/common/storage/secure_storage_client.dart';
import 'package:agora/infrastructure/login/login_storage_client.dart';
import 'package:agora/infrastructure/notification/notification_storage_client.dart';
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

  static FirstConnectionStorageClient getFirstConnectionStorageClient() {
    if (GetIt.instance.isRegistered<FirstConnectionSharedPreferencesClient>()) {
      return GetIt.instance.get<FirstConnectionSharedPreferencesClient>();
    }
    final storage = FirstConnectionSharedPreferencesClient();
    GetIt.instance.registerSingleton(storage);
    return storage;
  }

  static NotificationStorageClient getNotificationStorageClient() {
    if (GetIt.instance.isRegistered<NotificationSharedPreferencesClient>()) {
      return GetIt.instance.get<NotificationSharedPreferencesClient>();
    }
    final storage = NotificationSharedPreferencesClient();
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
}
