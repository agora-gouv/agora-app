import 'package:agora/common/analytics/matomo_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

class ConfigManager {
  static MatomoConfig getMatomoConfig() {
    if (GetIt.instance.isRegistered<MatomoConfig>()) {
      return GetIt.instance.get<MatomoConfig>();
    }
    final config = MatomoConfig();
    GetIt.instance.registerSingleton(config);
    return config;
  }

  static void setFirebaseOptions(FirebaseOptions firebaseOptions) {
    GetIt.instance.registerSingleton<FirebaseOptions>(firebaseOptions);
  }

  static FirebaseOptions getFirebaseOptions() {
    if (GetIt.instance.isRegistered<FirebaseOptions>()) {
      return GetIt.instance.get<FirebaseOptions>();
    }
    throw Exception("FirebaseOptions are not initialized");
  }
}
