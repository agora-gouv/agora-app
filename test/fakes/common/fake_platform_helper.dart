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

  @override
  bool isWeb() {
    return false;
  }

  @override
  String getPlatformName() {
    return "android";
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

  @override
  bool isWeb() {
    return false;
  }

  @override
  String getPlatformName() {
    return "ios";
  }
}

class FakePlatformWebHelper extends PlatformHelper {
  @override
  bool isAndroid() {
    return false;
  }

  @override
  bool isIOS() {
    return false;
  }

  @override
  bool isWeb() {
    return true;
  }

  @override
  String getPlatformName() {
    return "web";
  }
}
