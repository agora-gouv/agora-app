import 'package:shared_preferences/shared_preferences.dart';

abstract class FirstConnectionStorageClient {
  void save(bool isFirstConnection);

  Future<bool> isFirstConnection();
}

class FirstConnectionSharedPreferencesClient extends FirstConnectionStorageClient {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final isFirstConnectionKey = "isFirstConnectionKey";

  @override
  void save(bool isFirstConnection) async {
    (await _prefs).setBool(isFirstConnectionKey, isFirstConnection);
  }

  @override
  Future<bool> isFirstConnection() async {
    final preferences = await _prefs;
    await preferences.reload();

    final isFirstConnection = preferences.getBool(isFirstConnectionKey);
    if (isFirstConnection == null) {
      return true;
    } else {
      return isFirstConnection;
    }
  }
}
