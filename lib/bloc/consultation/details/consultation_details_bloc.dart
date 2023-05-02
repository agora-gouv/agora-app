import 'package:agora/bloc/consultation/details/consultation_details_event.dart';
import 'package:agora/bloc/consultation/details/consultation_details_state.dart';
import 'package:agora/common/helper/device_info_helper.dart';
import 'package:agora/infrastructure/consultation/presenter/consultation_details_presenter.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationDetailsBloc extends Bloc<FetchConsultationDetailsEvent, ConsultationDetailsState> {
  final ConsultationRepository consultationRepository;
  final DeviceInfoHelper deviceInfoHelper;

  ConsultationDetailsBloc({
    required this.consultationRepository,
    required this.deviceInfoHelper,
  }) : super(ConsultationDetailsInitialLoadingState()) {
    on<FetchConsultationDetailsEvent>(_handleConsultationDetails);
  }

  Future<void> _handleConsultationDetails(
    FetchConsultationDetailsEvent event,
    Emitter<ConsultationDetailsState> emit,
  ) async {
    final deviceId = await deviceInfoHelper.getDeviceId();
    if (deviceId == null) {
      emit(ConsultationDetailsErrorState());
      return;
    }
    final response = await consultationRepository.fetchConsultationDetails(
      consultationId: event.consultationId,
      deviceId: deviceId,
    );
    if (response is GetConsultationDetailsSucceedResponse) {
      final consultationDetailsViewModel = ConsultationDetailsPresenter.present(response.consultationDetails);
      emit(ConsultationDetailsFetchedState(consultationDetailsViewModel));
    } else {
      emit(ConsultationDetailsErrorState());
    }
  }
}
