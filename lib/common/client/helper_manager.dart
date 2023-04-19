import 'package:agora/common/helper/device_id_helper.dart';
import 'package:get_it/get_it.dart';

class HelperManager {
  static DeviceIdHelper getDeviceIdHelper() {
    if (GetIt.instance.isRegistered<UniqueDeviceIdHelper>()) {
      return GetIt.instance.get<UniqueDeviceIdHelper>();
    }
    final helper = UniqueDeviceIdHelper();
    GetIt.instance.registerSingleton(helper);
    return helper;
  }
}
