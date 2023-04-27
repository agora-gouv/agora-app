import 'package:agora/bloc/login/login_event.dart';
import 'package:agora/bloc/login/login_state.dart';
import 'package:agora/common/helper/device_info_helper.dart';
import 'package:agora/infrastructure/login/login_repository.dart';
import 'package:agora/infrastructure/login/login_storage_client.dart';
import 'package:agora/push_notification/push_notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;
  final LoginStorageClient loginStorageClient;
  final DeviceInfoHelper deviceInfoHelper;
  final PushNotificationService pushNotificationService;

  LoginBloc({
    required this.repository,
    required this.loginStorageClient,
    required this.deviceInfoHelper,
    required this.pushNotificationService,
  }) : super(LoginInitialLoadingState()) {
    on<CheckLoginEvent>(_handleCheckLoginEvent);
  }

  Future<void> _handleCheckLoginEvent(CheckLoginEvent event, Emitter<LoginState> emit) async {
    final fcmToken = await pushNotificationService.getMessagingToken();

    final userId = await loginStorageClient.getUserId();
    if (userId == null) {
      final deviceId = await deviceInfoHelper.getDeviceId();
      if (deviceId == null) {
        emit(LoginErrorState());
        return;
      }

      final response = await repository.login(deviceId: deviceId, firebaseMessagingToken: fcmToken);
      if (response is LoginSucceedResponse) {
        loginStorageClient.save(response.userId);
        emit(LoginSuccessState());
      } else {
        emit(LoginErrorState());
      }
    } else {
      emit(LoginSuccessState());
    }
  }
}
