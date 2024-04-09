import 'dart:io';

import 'package:agora/common/helper/app_version_helper.dart';
import 'package:agora/common/helper/flavor_helper.dart';
import 'package:flutter/foundation.dart';

abstract class UserAgentBuilder {
  Future<String?> getUserAgent();
}

class UserAgentBuilderImpl extends UserAgentBuilder {
  final AppVersionHelper appVersionHelper;

  UserAgentBuilderImpl({required this.appVersionHelper});

  @override
  Future<String?> getUserAgent() async {
    final flavorInfo = switch (FlavorHelper.getFlavor()) {
      AgoraFlavor.sandbox => ".sandbox",
      AgoraFlavor.dev => ".dev",
      AgoraFlavor.prod => "",
    };
    final versionInfo = appVersionHelper;

    if (kIsWeb) {
      return "Web: fr.agora.gouv$flavorInfo/${await versionInfo.getVersion()}";
    } else if (Platform.isAndroid) {
      return "Android: fr.agora.gouv$flavorInfo/${await versionInfo.getVersion()} Android/${await versionInfo.getAndroidVersion()}";
    } else if (Platform.isIOS) {
      return "iOS: fr.agora.gouv$flavorInfo/${await versionInfo.getVersion()} iOS/${await versionInfo.getIosVersion()}";
    } else {
      return null;
    }
  }
}

class FakeUserAgentBuilder extends UserAgentBuilder {
  @override
  Future<String?> getUserAgent() async {
    return null;
  }
}
