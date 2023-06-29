import 'package:agora/common/analytics/matomo_config.dart';
import 'package:agora/common/helper/flavor_helper.dart';
import 'package:agora/firebase_options_dev.dart';
import 'package:agora/firebase_options_prod.dart';
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

  static FirebaseOptions getFirebaseOptions() {
    if (GetIt.instance.isRegistered<FirebaseOptions>()) {
      return GetIt.instance.get<FirebaseOptions>();
    }

    FirebaseOptions firebaseOptions;
    switch (FlavorHelper.getFlavor()) {
      case AgoraFlavor.dev:
        firebaseOptions = DevFirebaseOptions.currentPlatform;
        break;
      case AgoraFlavor.prod:
        firebaseOptions = ProdFirebaseOptions.currentPlatform;
        break;
    }
    GetIt.instance.registerSingleton(firebaseOptions);
    return firebaseOptions;
  }
}
