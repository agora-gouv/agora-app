import 'package:agora/common/log/sentry_wrapper.dart';
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
  final SentryWrapper sentryWrapper;

  static const String firstRunKey = 'first_run';

  FlutterSecureStorageClient({
    required this.secureStorage,
    required this.sharedPref,
    required this.sentryWrapper,
  }) {
    final isFirstRun = sharedPref.getBool(firstRunKey) ?? true;
    if (isFirstRun) {
      try {
        secureStorage.deleteAll();
      } catch (exception, stacktrace) {
        sentryWrapper.captureException(exception, stacktrace, message: "Error while resetting secureStorage");
      }
      sharedPref.setBool(firstRunKey, false);
    }
  }

  @override
  Future<void> write({required String key, required String value}) async {
    try {
      await secureStorage.write(key: key, value: value);
    } catch (exception, stacktrace) {
      sentryWrapper.captureException(exception, stacktrace, message: "Error while saving $key to secureStorage");
      return;
    }
  }

  @override
  Future<String?> read({required String key}) async {
    try {
      return await secureStorage.read(key: key);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> delete({required String key}) async {
    try {
      return await secureStorage.delete(key: key);
    } catch (exception, stacktrace) {
      sentryWrapper.captureException(exception, stacktrace, message: "Error while deleting $key from secureStorage");
      return;
    }
  }
}
