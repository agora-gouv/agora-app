import 'dart:io';

import 'package:agora/common/helper/app_version_helper.dart';
import 'package:device_info_plus/device_info_plus.dart';

abstract class UserAgentBuilder {
  Future<String?> getUserAgent();
}

class UserAgentBuilderImpl extends UserAgentBuilder {
  final AppVersionHelper appVersionHelper;

  UserAgentBuilderImpl({required this.appVersionHelper});

  @override
  Future<String?> getUserAgent() async {
    final appVersion = await appVersionHelper.getVersion();
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      return "Android: fr.agora.gouv/$appVersion Android/${androidInfo.version.release}";
    } else if (Platform.isIOS) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      return "iOS: fr.agora.gouv/$appVersion iOS/${iosInfo.systemVersion}";
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
