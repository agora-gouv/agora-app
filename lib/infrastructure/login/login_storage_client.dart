import 'package:shared_preferences/shared_preferences.dart';

abstract class LoginStorageClient {
  void save(String userId);

  Future<String?> getUserId();
}

class LoginSharedPreferencesClient extends LoginStorageClient {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final userIdKey = "userIdKey";

  @override
  void save(String userId) async {
    (await _prefs).setString(userIdKey, userId);
  }

  @override
  Future<String?> getUserId() async {
    final preferences = await _prefs;
    await preferences.reload();
    return preferences.getString(userIdKey);
  }
}
