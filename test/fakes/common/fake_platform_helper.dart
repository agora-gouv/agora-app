import 'package:agora/common/helper/platform_helper.dart';

class FakePlatformAndroidHelper extends PlatformHelper {
  @override
  bool isAndroid() {
    return true;
  }

  @override
  bool isIOS() {
    return false;
  }
}

class FakePlatformIOSHelper extends PlatformHelper {
  @override
  bool isAndroid() {
    return false;
  }

  @override
  bool isIOS() {
    return true;
  }
}
