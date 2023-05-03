import 'package:agora/bloc/qag/feedback/qag_feedback_event.dart';
import 'package:agora/bloc/qag/feedback/qag_feedback_state.dart';
import 'package:agora/common/helper/device_info_helper.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagFeedbackBloc extends Bloc<QagFeedbackEvent, QagFeedbackState> {
  final QagRepository qagRepository;
  final DeviceInfoHelper deviceInfoHelper;

  QagFeedbackBloc({
    required this.qagRepository,
    required this.deviceInfoHelper,
  }) : super(QagFeedbackInitialState()) {
    on<QagFeedbackEvent>(_handleQagFeedback);
  }

  Future<void> _handleQagFeedback(
    QagFeedbackEvent event,
    Emitter<QagFeedbackState> emit,
  ) async {
    emit(QagFeedbackLoadingState());
    final deviceId = await deviceInfoHelper.getDeviceId();
    if (deviceId == null) {
      emit(QagFeedbackErrorState());
      return;
    }
    final response = await qagRepository.giveQagResponseFeedback(
      qagId: event.qagId,
      deviceId: deviceId,
      isHelpful: event.isHelpful,
    );
    if (response is QagFeedbackSuccessResponse) {
      emit(QagFeedbackSuccessState());
    } else {
      emit(QagFeedbackErrorState());
    }
  }
}
