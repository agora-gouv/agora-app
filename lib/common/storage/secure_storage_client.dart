import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SecureStorageClient {
  Future<void> write({required String key, required String value});

  Future<String?> read({required String key});

  Future<void> delete({required String key});
}

class FlutterSecureStorageClient extends SecureStorageClient {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPref;

  static const String firstRunKey = 'first_run';

  FlutterSecureStorageClient({required this.secureStorage, required this.sharedPref}) {
    final isFirstRun = sharedPref.getBool(firstRunKey) ?? true;
    if (isFirstRun) {
      secureStorage.deleteAll();
      sharedPref.setBool(firstRunKey, false);
    }
  }

  @override
  Future<void> write({required String key, required String value}) async {
    await secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> read({required String key}) async {
    return await secureStorage.read(key: key);
  }

  @override
  Future<void> delete({required String key}) async {
    return await secureStorage.delete(key: key);
  }
}
