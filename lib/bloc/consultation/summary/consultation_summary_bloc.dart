import 'package:agora/bloc/consultation/summary/consultation_summary_event.dart';
import 'package:agora/bloc/consultation/summary/consultation_summary_state.dart';
import 'package:agora/common/helper/device_info_helper.dart';
import 'package:agora/infrastructure/consultation/presenter/consultation_summary_presenter.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationSummaryBloc extends Bloc<FetchConsultationSummaryEvent, ConsultationSummaryState> {
  final ConsultationRepository consultationRepository;
  final DeviceInfoHelper deviceInfoHelper;

  ConsultationSummaryBloc({
    required this.consultationRepository,
    required this.deviceInfoHelper,
  }) : super(ConsultationSummaryInitialLoadingState()) {
    on<FetchConsultationSummaryEvent>(_handleConsultationSummary);
  }

  Future<void> _handleConsultationSummary(
    FetchConsultationSummaryEvent event,
    Emitter<ConsultationSummaryState> emit,
  ) async {
    final deviceId = await deviceInfoHelper.getDeviceId();
    if (deviceId == null) {
      emit(ConsultationSummaryErrorState());
      return;
    }
    final response = await consultationRepository.fetchConsultationSummary(
      consultationId: event.consultationId,
      deviceId: deviceId,
    );
    if (response is GetConsultationSummarySucceedResponse) {
      final consultationSummaryViewModel = ConsultationSummaryPresenter.present(response.consultationSummary);
      emit(ConsultationSummaryFetchedState(consultationSummaryViewModel));
    } else {
      emit(ConsultationSummaryErrorState());
    }
  }
}
