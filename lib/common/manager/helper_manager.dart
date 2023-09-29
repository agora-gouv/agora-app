import 'package:agora/common/helper/app_version_helper.dart';
import 'package:agora/common/helper/device_info_helper.dart';
import 'package:agora/common/helper/jwt_helper.dart';
import 'package:agora/common/helper/permission_helper.dart';
import 'package:agora/common/helper/platform_helper.dart';
import 'package:agora/common/helper/role_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class HelperManager {
  static DeviceInfoHelper getDeviceInfoHelper() {
    if (GetIt.instance.isRegistered<DeviceInfoPluginHelper>()) {
      return GetIt.instance.get<DeviceInfoPluginHelper>();
    }
    final helper = DeviceInfoPluginHelper();
    GetIt.instance.registerSingleton(helper);
    return helper;
  }

  static PlatformHelper getPlatformHelper() {
    if (GetIt.instance.isRegistered<PlatformImplHelper>()) {
      return GetIt.instance.get<PlatformImplHelper>();
    }
    final helper = PlatformImplHelper();
    GetIt.instance.registerSingleton(helper);
    return helper;
  }

  static PermissionHelper getPermissionHelper() {
    if (kIsWeb) {
      if (GetIt.instance.isRegistered<NotImportantPermissionImplHelper>()) {
        return GetIt.instance.get<NotImportantPermissionImplHelper>();
      }
      final helper = NotImportantPermissionImplHelper();
      GetIt.instance.registerSingleton(helper);
      return helper;
    } else {
      if (GetIt.instance.isRegistered<PermissionImplHelper>()) {
        return GetIt.instance.get<PermissionImplHelper>();
      }
      final helper = PermissionImplHelper();
      GetIt.instance.registerSingleton(helper);
      return helper;
    }
  }

  static JwtHelper getJwtHelper() {
    if (GetIt.instance.isRegistered<JwtHelperImpl>()) {
      return GetIt.instance.get<JwtHelperImpl>();
    }
    final helper = JwtHelperImpl();
    GetIt.instance.registerSingleton(helper);
    return helper;
  }

  static RoleHelper getRoleHelper() {
    if (GetIt.instance.isRegistered<RoleHelperImpl>()) {
      return GetIt.instance.get<RoleHelperImpl>();
    }
    final helper = RoleHelperImpl();
    GetIt.instance.registerSingleton(helper);
    return helper;
  }

  static AppVersionHelper getAppVersionHelper() {
    if (GetIt.instance.isRegistered<AppVersionHelperImpl>()) {
      return GetIt.instance.get<AppVersionHelperImpl>();
    }
    final helper = AppVersionHelperImpl();
    GetIt.instance.registerSingleton(helper);
    return helper;
  }
}
