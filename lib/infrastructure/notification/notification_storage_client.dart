import 'package:shared_preferences/shared_preferences.dart';

// TODO use in next ticket
abstract class NotificationStorageClient {
  void save(bool isNotificationAccept);

  void delete();

  Future<bool?> isNotificationAccept();
}

class NotificationSharedPreferencesClient extends NotificationStorageClient {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final isNotificationAcceptKey = "isNotificationAccept";

  @override
  void save(bool isNotificationAccept) async {
    (await _prefs).setBool(isNotificationAcceptKey, isNotificationAccept);
  }

  @override
  void delete() async {
    (await _prefs).remove(isNotificationAcceptKey);
  }

  @override
  Future<bool?> isNotificationAccept() async {
    final preferences = await _prefs;
    await preferences
        .reload(); // force refresh see https://stackoverflow.com/questions/64961326/flutter-strange-behavior-of-shared-preferences
    return preferences.getBool(isNotificationAcceptKey);
  }
}
