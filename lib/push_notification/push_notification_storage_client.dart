import 'package:shared_preferences/shared_preferences.dart';

abstract class PushNotificationStorageClient {
  void saveMessage(String jsonMessageData);

  Future<String?> getMessage();

  void clearMessage();
}

class PushNotificationSharedPreferencesClient extends PushNotificationStorageClient {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final notificationMessagesKey = "notificationMessages";

  @override
  void saveMessage(String jsonMessageData) async {
    (await _prefs).setString(notificationMessagesKey, jsonMessageData);
  }

  @override
  Future<String?> getMessage() async {
    final preferences = await _prefs;
    await preferences.reload();
    return preferences.getString(notificationMessagesKey);
  }

  @override
  void clearMessage() async {
    (await _prefs).remove(notificationMessagesKey);
  }
}
