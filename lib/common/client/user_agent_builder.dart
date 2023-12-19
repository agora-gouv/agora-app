import 'dart:io';

import 'package:agora/common/helper/app_version_helper.dart';
import 'package:flutter/foundation.dart';

abstract class UserAgentBuilder {
  Future<String?> getUserAgent();
}

class UserAgentBuilderImpl extends UserAgentBuilder {
  final AppVersionHelper appVersionHelper;

  UserAgentBuilderImpl({required this.appVersionHelper});

  @override
  Future<String?> getUserAgent() async {
    final versionInfos = appVersionHelper;
    if (kIsWeb) {
      return "Web: fr.agora.gouv/${await versionInfos.getVersion()}";
    } else if (Platform.isAndroid) {
      return "Android: fr.agora.gouv/${await versionInfos.getVersion()} Android/${await versionInfos.getAndroidVersion()}";
    } else if (Platform.isIOS) {
      return "iOS: fr.agora.gouv/${await versionInfos.getVersion()} iOS/${await versionInfos.getIosVersion()}";
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
