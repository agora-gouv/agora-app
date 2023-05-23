import 'package:shared_preferences/shared_preferences.dart';

abstract class LoginStorageClient {
  void save(String loginToken);

  Future<String?> getLoginToken();
}

class LoginSharedPreferencesClient extends LoginStorageClient {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final loginTokenKey = "loginTokenKey";

  @override
  void save(String loginToken) async {
    (await _prefs).setString(loginTokenKey, loginToken);
  }

  @override
  Future<String?> getLoginToken() async {
    final preferences = await _prefs;
    await preferences.reload();
    return preferences.getString(loginTokenKey);
  }
}
