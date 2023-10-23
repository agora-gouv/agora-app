import 'package:agora/common/helper/app_version_helper.dart';
import 'package:agora/common/helper/jwt_helper.dart';
import 'package:agora/common/helper/platform_helper.dart';
import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/infrastructure/login/login_repository.dart';
import 'package:agora/infrastructure/login/login_storage_client.dart';
import 'package:agora/push_notification/push_notification_service.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final LoginRepository repository;
  final LoginStorageClient loginStorageClient;
  final PushNotificationService pushNotificationService;
  final JwtHelper jwtHelper;
  final AppVersionHelper appVersionHelper;
  final PlatformHelper platformHelper;

  AuthInterceptor({
    required this.repository,
    required this.loginStorageClient,
    required this.pushNotificationService,
    required this.jwtHelper,
    required this.appVersionHelper,
    required this.platformHelper,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final jwtExpiration = HelperManager.getJwtHelper().getJwtExpirationEpochMilli();

    if (jwtExpiration != null) {
      final expirationDateTime = DateTime.fromMillisecondsSinceEpoch(jwtExpiration);

      if (DateTime.now().isAfter(expirationDateTime)) {
        final response = await login();

        if (response is LoginSucceedResponse) {
          HelperManager.getJwtHelper().setJwtExpiration(response.jwtExpirationEpochMilli);
          HelperManager.getJwtHelper().setJwtToken(response.jwtToken);
          options.headers["Authorization"] = "Bearer ${response.jwtToken}";
        }
      }
    } else {
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
    final fcmToken = await pushNotificationService.getMessagingToken();
    final loginToken = await loginStorageClient.getLoginToken();
    final buildNumber = await appVersionHelper.getBuildNumber();
    final version = await appVersionHelper.getVersion();
    final platformName = platformHelper.getPlatformName();

    return repository.login(
      firebaseMessagingToken: fcmToken,
      loginToken: loginToken ?? '',
      appVersion: version,
      buildNumber: buildNumber,
      platformName: platformName,
    );
  }
}
