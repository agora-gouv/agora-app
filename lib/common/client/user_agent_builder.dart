import 'dart:io';

import 'package:agora/common/helper/app_version_helper.dart';
import 'package:device_info_plus/device_info_plus.dart';

class UserAgentBuilder {
  final AppVersionHelper appVersionHelper;

  UserAgentBuilder({required this.appVersionHelper});

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
