import 'package:agora/common/helper/platform_helper.dart';
import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/manager/service_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/infrastructure/login/login_repository.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final jwtExpiration = HelperManager.getJwtHelper().getJwtExpirationEpochMilli();
    final expirationDateTime = DateTime.fromMillisecondsSinceEpoch(jwtExpiration!);

    if (DateTime.now().isAfter(expirationDateTime)) {
      final response = await login();

      if (response is LoginSucceedResponse) {
        HelperManager.getJwtHelper().setJwtExpiration(response.jwtExpirationEpochMilli);
        HelperManager.getJwtHelper().setJwtToken(response.jwtToken);
        options.headers["Authorization"] = "Bearer ${response.jwtToken}";
      }
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    return handler.next(err);
  }

  Future<LoginRepositoryResponse> login() async {
    final login = RepositoryManager.getLoginRepository();
    final fcmToken = await ServiceManager.getPushNotificationService().getMessagingToken();
    final loginToken = await StorageManager.getLoginStorageClient().getLoginToken();
    final buildNumber = await HelperManager.getAppVersionHelper().getBuildNumber();
    final version = await HelperManager.getAppVersionHelper().getVersion();
    final platformName = PlatformImplHelper().getPlatformName();

    return login.login(
      firebaseMessagingToken: fcmToken,
      loginToken: loginToken ?? '',
      appVersion: version,
      buildNumber: buildNumber,
      platformName: platformName,
    );
  }
}
