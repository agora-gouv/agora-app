import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingStorageClient {
  void save(bool isFirstTime);

  Future<bool> isFirstTime();
}

class OnboardingSharedPreferencesClient extends OnboardingStorageClient {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final isFirstTimeKey = "isFirstTimeKey";

  @override
  void save(bool isFirstTime) async {
    (await _prefs).setBool(isFirstTimeKey, isFirstTime);
  }

  @override
  Future<bool> isFirstTime() async {
    final preferences = await _prefs;
    await preferences.reload();

    final isFirstConnection = preferences.getBool(isFirstTimeKey);
    if (isFirstConnection == null) {
      return true;
    } else {
      return isFirstConnection;
    }
  }
}
