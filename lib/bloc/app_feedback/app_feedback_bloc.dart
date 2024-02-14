import 'package:agora/bloc/app_feedback/app_feedback_event.dart';
import 'package:agora/bloc/app_feedback/app_feedback_state.dart';
import 'package:agora/common/helper/device_info_helper.dart';
import 'package:agora/infrastructure/app_feedback/repository/app_feedback_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppFeedbackBloc extends Bloc<AppFeedbackEvent, AppFeedbackState> {
  final AppFeedbackRepository repository;
  final DeviceInfoHelper deviceInfoPluginHelper;

  AppFeedbackBloc({
    required this.repository,
    required this.deviceInfoPluginHelper,
  }) : super(AppFeedbackState.initial) {
    on<SendAppFeedbackEvent>(_handleSendAppFeedbackEvent);
    on<ReinitAppFeedbackEvent>(_handleReinitAppFeedbackEvent);
    on<AppFeedbackMailSentEvent>(_handleAppFeedbackMailSentEvent);
  }

  Future<void> _handleSendAppFeedbackEvent(
    SendAppFeedbackEvent event,
    Emitter<AppFeedbackState> emit,
  ) async {
    final deviceInformations = await deviceInfoPluginHelper.getDeviceInformations();
    emit(AppFeedbackState.loading);
    final success = await repository.sendFeedback(event.feedback, deviceInformations);
    if (success) {
      emit(AppFeedbackState.success);
    } else {
      emit(AppFeedbackState.error);
    }
  }

  Future<void> _handleReinitAppFeedbackEvent(
    ReinitAppFeedbackEvent event,
    Emitter<AppFeedbackState> emit,
  ) async {
    emit(AppFeedbackState.initial);
  }

  Future<void> _handleAppFeedbackMailSentEvent(
      AppFeedbackMailSentEvent event,
    Emitter<AppFeedbackState> emit,
  ) async {
    emit(AppFeedbackState.success);
  }
}
