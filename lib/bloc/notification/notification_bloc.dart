import 'package:agora/bloc/notification/notification_event.dart';
import 'package:agora/bloc/notification/notification_state.dart';
import 'package:agora/common/helper/device_info_helper.dart';
import 'package:agora/common/helper/permission_helper.dart';
import 'package:agora/common/helper/platform_helper.dart';
import 'package:agora/infrastructure/notification/notification_first_request_permission_storage_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Bloc<NotificationPermissionEvent, NotificationState> {
  final NotificationFirstRequestPermissionStorageClient notificationFirstRequestPermissionStorageClient;
  final PermissionHelper permissionHelper;
  final DeviceInfoHelper deviceInfoHelper;
  final PlatformHelper platformHelper;

  NotificationBloc({
    required this.notificationFirstRequestPermissionStorageClient,
    required this.permissionHelper,
    required this.platformHelper,
    required this.deviceInfoHelper,
  }) : super(NotificationInitialState()) {
    on<RequestNotificationPermissionEvent>(_handleFirstTimeAskNotificationPermission);
  }

  // IOS by default is permission.isDenied (have a pop up to ask permission).
  // Android by default is
  //  - permission.isGranted when release is < Android 13 (SDK 33) (doesn't have a pop up to ask permission).
  //  - permission.isDenied when release is >=  Android 13 (SDK 33) (have a pop up to ask permission).
  Future<void> _handleFirstTimeAskNotificationPermission(
    RequestNotificationPermissionEvent event,
    Emitter<NotificationState> emit,
  ) async {
    if (!kIsWeb) {
      final isFirstRequest = await notificationFirstRequestPermissionStorageClient.isFirstRequest();
      if (isFirstRequest) {
        notificationFirstRequestPermissionStorageClient.save(false);
        if (await permissionHelper.isDenied()) {
          if (platformHelper.isIOS()) {
            emit(AutoAskNotificationConsentState());
          } else if (platformHelper.isAndroid()) {
            final androidSdk = await deviceInfoHelper.getAndroidSdk();
            if (androidSdk >= 33) {
              emit(AutoAskNotificationConsentState());
            } else {
              emit(AskNotificationConsentState());
            }
          }
        } else if (await permissionHelper.isPermanentlyDenied()) {
          emit(AskNotificationConsentState());
        }
      }
    }
  }
}
