import 'package:shared_preferences/shared_preferences.dart';

abstract class HeaderQagStorageClient {
  Future<bool> isHeaderClosed({required String headerId});

  Future<void> closeHeader({required String headerId});
}

class HeaderQagSharedPreferencesClient extends HeaderQagStorageClient {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final _closedHeaderQagPrefix = "closedHeaderQagId:";

  @override
  Future<bool> isHeaderClosed({required String headerId}) async {
    final preferences = await _prefs;
    await preferences.reload();

    return preferences.getBool(_closedHeaderQagPrefix + headerId) ?? false;
  }

  @override
  Future<void> closeHeader({required String headerId}) async {
    (await _prefs).setBool(_closedHeaderQagPrefix + headerId, true);
  }
}
