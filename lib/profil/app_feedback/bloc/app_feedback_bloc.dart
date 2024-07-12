import 'package:agora/profil/app_feedback/bloc/app_feedback_event.dart';
import 'package:agora/profil/app_feedback/bloc/app_feedback_state.dart';
import 'package:agora/profil/app_feedback/repository/app_feedback_repository.dart';
import 'package:agora/common/helper/device_info_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppFeedbackBloc extends Bloc<AppFeedbackEvent, AppFeedbackState> {
  final AppFeedbackRepository repository;
  final DeviceInfoHelper deviceInfoHelper;

  AppFeedbackBloc({
    required this.repository,
    required this.deviceInfoHelper,
  }) : super(AppFeedbackState.initial) {
    on<SendAppFeedbackEvent>(_handleSendAppFeedbackEvent);
    on<ReinitAppFeedbackEvent>(_handleReinitAppFeedbackEvent);
    on<AppFeedbackMailSentEvent>(_handleAppFeedbackMailSentEvent);
  }

  Future<void> _handleSendAppFeedbackEvent(
    SendAppFeedbackEvent event,
    Emitter<AppFeedbackState> emit,
  ) async {
    final deviceInformations = await deviceInfoHelper.getDeviceInformations();
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
