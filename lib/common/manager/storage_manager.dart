import 'package:agora/common/storage/first_connection_storage_client.dart';
import 'package:agora/infrastructure/login/login_storage_client.dart';
import 'package:agora/infrastructure/notification/notification_storage_client.dart';
import 'package:get_it/get_it.dart';

class StorageManager {
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

  static LoginStorageClient getLoginStorageClient() {
    if (GetIt.instance.isRegistered<LoginSharedPreferencesClient>()) {
      return GetIt.instance.get<LoginSharedPreferencesClient>();
    }
    final storage = LoginSharedPreferencesClient();
    GetIt.instance.registerSingleton(storage);
    return storage;
  }
}
