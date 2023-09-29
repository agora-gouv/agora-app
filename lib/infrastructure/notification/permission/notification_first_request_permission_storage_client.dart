import 'package:shared_preferences/shared_preferences.dart';

abstract class NotificationFirstRequestPermissionStorageClient {
  void save(bool isFirstRequest);

  Future<bool> isFirstRequest();
}

class NotificationFirstRequestPermissionSharedPreferencesClient
    extends NotificationFirstRequestPermissionStorageClient {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final isNotificationFirstRequestKey = "isNotificationFirstRequestKey";

  @override
  void save(bool isFirstRequest) async {
    (await _prefs).setBool(isNotificationFirstRequestKey, isFirstRequest);
  }

  @override
  Future<bool> isFirstRequest() async {
    final preferences = await _prefs;
    await preferences.reload();

    final isFirstConnection = preferences.getBool(isNotificationFirstRequestKey);
    if (isFirstConnection == null) {
      return true;
    } else {
      return isFirstConnection;
    }
  }
}
