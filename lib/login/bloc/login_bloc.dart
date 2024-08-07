import 'package:agora/common/helper/app_version_helper.dart';
import 'package:agora/common/helper/device_info_helper.dart';
import 'package:agora/common/helper/jwt_helper.dart';
import 'package:agora/common/helper/platform_helper.dart';
import 'package:agora/common/helper/role_helper.dart';
import 'package:agora/login/bloc/login_event.dart';
import 'package:agora/login/bloc/login_state.dart';
import 'package:agora/login/repository/login_repository.dart';
import 'package:agora/login/repository/login_storage_client.dart';
import 'package:agora/push_notification/push_notification_service.dart';
import 'package:agora/welcome/repository/welcome_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;
  final LoginStorageClient loginStorageClient;
  final DeviceInfoHelper deviceInfoHelper;
  final PushNotificationService pushNotificationService;
  final JwtHelper jwtHelper;
  final RoleHelper roleHelper;
  final AppVersionHelper appVersionHelper;
  final PlatformHelper platformHelper;
  final WelcomeRepository welcomeRepository;

  LoginBloc({
    required this.loginRepository,
    required this.loginStorageClient,
    required this.deviceInfoHelper,
    required this.pushNotificationService,
    required this.jwtHelper,
    required this.roleHelper,
    required this.appVersionHelper,
    required this.platformHelper,
    required this.welcomeRepository,
  }) : super(LoginInitialState()) {
    on<CheckLoginEvent>(_handleCheckLoginEvent);
  }

  Future<void> _handleCheckLoginEvent(CheckLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    final fcmToken = await pushNotificationService.getMessagingToken();
    final loginToken = await loginStorageClient.getLoginToken();
    final version = await appVersionHelper.getVersion();
    final buildNumber = await appVersionHelper.getBuildNumber();
    final platformName = platformHelper.getPlatformName();
    if (loginToken != null) {
      emit(
        await _login(
          loginToken: loginToken,
          fcmToken: fcmToken,
          appVersion: version,
          buildNumber: buildNumber,
          platformName: platformName,
        ),
      );
      await welcomeRepository.getWelcomeALaUne();
    } else {
      emit(
        await _signup(
          fcmToken: fcmToken,
          appVersion: version,
          buildNumber: buildNumber,
          platformName: platformName,
        ),
      );
    }
  }

  Future<LoginState> _login({
    required String loginToken,
    required String fcmToken,
    required String appVersion,
    required String buildNumber,
    required String platformName,
  }) async {
    final response = await loginRepository.login(
      firebaseMessagingToken: fcmToken,
      loginToken: loginToken,
      appVersion: appVersion,
      buildNumber: buildNumber,
      platformName: platformName,
    );
    if (response is LoginSucceedResponse) {
      jwtHelper.setJwtToken(response.jwtToken);
      roleHelper.setIsModerator(response.isModerator);
      jwtHelper.setJwtExpiration(response.jwtExpirationEpochMilli);
      return LoginSuccessState();
    } else {
      final errorResponse = response as LoginFailedResponse;
      return LoginErrorState(errorType: errorResponse.errorType);
    }
  }

  Future<LoginState> _signup({
    required String fcmToken,
    required String appVersion,
    required String buildNumber,
    required String platformName,
  }) async {
    final response = await loginRepository.signup(
      firebaseMessagingToken: fcmToken,
      appVersion: appVersion,
      buildNumber: buildNumber,
      platformName: platformName,
    );
    if (response is SignupSucceedResponse) {
      loginStorageClient.save(userId: response.userId, loginToken: response.loginToken);
      jwtHelper.setJwtToken(response.jwtToken);
      jwtHelper.setJwtExpiration(response.jwtExpirationEpochMilli);
      roleHelper.setIsModerator(response.isModerator);
      return LoginSuccessState();
    } else {
      final errorResponse = response as SignupFailedResponse;
      return LoginErrorState(errorType: errorResponse.errorType);
    }
  }
}
