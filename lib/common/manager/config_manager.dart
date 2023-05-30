import 'package:agora/common/analytics/matomo_config.dart';
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
}
