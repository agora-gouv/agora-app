import 'package:agora/bloc/demographic/get/demographic_information_event.dart';
import 'package:agora/bloc/demographic/get/demographic_information_state.dart';
import 'package:agora/common/helper/device_info_helper.dart';
import 'package:agora/infrastructure/demographic/demographic_information_presenter.dart';
import 'package:agora/infrastructure/demographic/demographic_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DemographicInformationBloc extends Bloc<GetDemographicInformationEvent, DemographicInformationState> {
  final DemographicRepository demographicRepository;
  final DeviceInfoHelper deviceInfoHelper;

  DemographicInformationBloc({
    required this.demographicRepository,
    required this.deviceInfoHelper,
  }) : super(GetDemographicInformationInitialLoadingState()) {
    on<GetDemographicInformationEvent>(_handleGetDemographicResponses);
  }

  Future<void> _handleGetDemographicResponses(
    GetDemographicInformationEvent event,
    Emitter<DemographicInformationState> emit,
  ) async {
    final deviceId = await deviceInfoHelper.getDeviceId();
    if (deviceId == null) {
      emit(GetDemographicInformationFailureState());
      return;
    }
    final response = await demographicRepository.getDemographicResponses(deviceId: deviceId);
    if (response is GetDemographicInformationSucceedResponse) {
      final viewModels = DemographicInformationPresenter.present(response.demographicInformations);
      emit(GetDemographicInformationSuccessState(demographicInformationViewModels: viewModels));
    } else {
      emit(GetDemographicInformationFailureState());
    }
  }
}
