import 'dart:io';

abstract class PlatformHelper {
  bool isIOS();

  bool isAndroid();
}

class PlatformImplHelper extends PlatformHelper {
  @override
  bool isAndroid() {
    return Platform.isAndroid;
  }

  @override
  bool isIOS() {
    return Platform.isIOS;
  }
}
