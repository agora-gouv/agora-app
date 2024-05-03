import 'dart:io';

import 'package:agora/common/helper/app_version_helper.dart';
import 'package:agora/common/helper/device_info_helper.dart';
import 'package:agora/common/helper/flavor_helper.dart';
import 'package:flutter/foundation.dart';

abstract class UserAgentBuilder {
  Future<String?> getUserAgent();
}

class UserAgentBuilderImpl extends UserAgentBuilder {
  final AppVersionHelper appVersionHelper;
  final DeviceInfoHelper deviceInfoHelper;

  UserAgentBuilderImpl({required this.appVersionHelper, required this.deviceInfoHelper});

  @override
  Future<String?> getUserAgent() async {
    final emulatorSuffix = switch (await deviceInfoHelper.isPhysicalDevice()) {
      false => "-emulator",
      true => "",
    };
    final flavorInfo = switch (FlavorHelper.getFlavor()) {
      AgoraFlavor.local => ".local",
      AgoraFlavor.sandbox => ".sandbox",
      AgoraFlavor.dev => ".dev",
      AgoraFlavor.prod => "",
    };
    final versionInfo = appVersionHelper;

    if (kIsWeb) {
      return "Web$emulatorSuffix: fr.agora.gouv$flavorInfo/${await versionInfo.getVersion()}, ${await deviceInfoHelper.getDeviceSystemData()}";
    } else if (Platform.isAndroid) {
      return "Android$emulatorSuffix: fr.agora.gouv$flavorInfo/${await versionInfo.getVersion()}, ${await deviceInfoHelper.getDeviceSystemData()}";
    } else if (Platform.isIOS) {
      return "iOS$emulatorSuffix: fr.agora.gouv$flavorInfo/${await versionInfo.getVersion()}, ${await deviceInfoHelper.getDeviceSystemData()}";
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
