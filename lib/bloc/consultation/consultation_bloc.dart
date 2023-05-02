import 'package:agora/bloc/consultation/consultation_event.dart';
import 'package:agora/bloc/consultation/consultation_state.dart';
import 'package:agora/common/helper/device_info_helper.dart';
import 'package:agora/infrastructure/consultation/consultation_presenter.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationBloc extends Bloc<FetchConsultationsEvent, ConsultationState> {
  final ConsultationRepository consultationRepository;
  final DeviceInfoHelper deviceInfoHelper;

  ConsultationBloc({
    required this.consultationRepository,
    required this.deviceInfoHelper,
  }) : super(ConsultationInitialLoadingState()) {
    on<FetchConsultationsEvent>(_handleConsultations);
  }

  Future<void> _handleConsultations(
    FetchConsultationsEvent event,
    Emitter<ConsultationState> emit,
  ) async {
    final deviceId = await deviceInfoHelper.getDeviceId();
    if (deviceId == null) {
      emit(ConsultationErrorState());
      return;
    }
    final response = await consultationRepository.fetchConsultations(deviceId: deviceId);
    if (response is GetConsultationsSucceedResponse) {
      final consultationsViewModel = ConsultationPresenter.present(response.consultations);
      emit(ConsultationsFetchedState(consultationsViewModel));
    } else {
      emit(ConsultationErrorState());
    }
  }
}
