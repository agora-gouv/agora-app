import 'dart:io';

import 'package:agora/common/log/log.dart';
import 'package:flutter/foundation.dart';

abstract class PlatformHelper {
  bool isIOS();
  bool isAndroid();
  bool isWeb();
  String getPlatformName();
}

class PlatformImplHelper extends PlatformHelper {
  @override
  bool isAndroid() {
    try {
      return Platform.isAndroid;
    } catch (e) {
      return false;
    }
  }

  @override
  bool isIOS() {
    try {
      return Platform.isIOS;
    } catch (e) {
      return false;
    }
  }

  @override
  bool isWeb() {
    return kIsWeb;
  }

  @override
  String getPlatformName() {
    if (isAndroid()) {
      return "android";
    } else if (isIOS()) {
      return "ios";
    } else if (isWeb()) {
      return "web";
    }
    throw Exception("Platform not supported");
  }
}

class PlatformStaticHelper {
  static bool isAndroid() {
    try {
      return Platform.isAndroid;
    } catch (e) {
      Log.error("not Android platform", e);
      return false;
    }
  }

  static bool isIOS() {
    try {
      return Platform.isIOS;
    } catch (e) {
      Log.error("not IOS platform", e);
      return false;
    }
  }

  static bool isWeb() {
    return kIsWeb;
  }
}
