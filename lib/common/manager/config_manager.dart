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

    final FirebaseOptions firebaseOptions = switch (FlavorHelper.getFlavor()) {
      AgoraFlavor.dev => DevFirebaseOptions.currentPlatform,
      AgoraFlavor.sandbox => DevFirebaseOptions.currentPlatform,
      AgoraFlavor.prod => ProdFirebaseOptions.currentPlatform,
    };

    GetIt.instance.registerSingleton(firebaseOptions);
    return firebaseOptions;
  }
}
