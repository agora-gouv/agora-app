import 'dart:io';

import 'package:agora/common/helper/app_version_helper.dart';

abstract class UserAgentBuilder {
  Future<String?> getUserAgent();
}

class UserAgentBuilderImpl extends UserAgentBuilder {
  final AppVersionHelper appVersionHelper;

  UserAgentBuilderImpl({required this.appVersionHelper});

  @override
  Future<String?> getUserAgent() async {
    final versionInfos = appVersionHelper;
    if (Platform.isAndroid) {
      return "Android: fr.agora.gouv/${versionInfos.getVersion()} Android/${versionInfos.getAndroidVersion()}";
    } else if (Platform.isIOS) {
      return "iOS: fr.agora.gouv/${versionInfos.getVersion()} iOS/${versionInfos.getIosVersion()}";
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