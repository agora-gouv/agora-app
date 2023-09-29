import 'package:shared_preferences/shared_preferences.dart';

abstract class ProfileDemographicStorageClient {
  void save(bool isFirstDisplay);

  Future<bool> isFirstDisplay();
}

class ProfileDemographicSharedPreferencesClient extends ProfileDemographicStorageClient {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final isFirstTimeDisplayKey = "isFirstTimeDisplayKey";

  @override
  void save(bool isFirstDisplay) async {
    (await _prefs).setBool(isFirstTimeDisplayKey, isFirstDisplay);
  }

  @override
  Future<bool> isFirstDisplay() async {
    final preferences = await _prefs;
    await preferences.reload();

    final isFirstDisplay = preferences.getBool(isFirstTimeDisplayKey);
    if (isFirstDisplay == null) {
      return true;
    } else {
      return isFirstDisplay;
    }
  }
}
