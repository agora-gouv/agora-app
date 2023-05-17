import 'package:agora/bloc/demographic/send/demographic_responses_send_event.dart';
import 'package:agora/bloc/demographic/send/demographic_responses_send_state.dart';
import 'package:agora/common/helper/device_info_helper.dart';
import 'package:agora/infrastructure/demographic/demographic_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendDemographicResponsesBloc extends Bloc<SendDemographicResponsesEvent, SendDemographicResponsesState> {
  final DemographicRepository demographicRepository;
  final DeviceInfoHelper deviceInfoHelper;

  SendDemographicResponsesBloc({
    required this.demographicRepository,
    required this.deviceInfoHelper,
  }) : super(SendDemographicResponsesInitialLoadingState()) {
    on<SendDemographicResponsesEvent>(_handleSendDemographicResponses);
  }

  Future<void> _handleSendDemographicResponses(
    SendDemographicResponsesEvent event,
    Emitter<SendDemographicResponsesState> emit,
  ) async {
    final deviceId = await deviceInfoHelper.getDeviceId();
    if (deviceId == null) {
      emit(SendDemographicResponsesFailureState());
      return;
    }
    final response = await demographicRepository.sendDemographicResponses(
      deviceId: deviceId,
      demographicResponses: event.demographicResponses,
    );
    if (response is SendDemographicResponsesSucceedResponse) {
      emit(SendDemographicResponsesSuccessState());
    } else {
      emit(SendDemographicResponsesFailureState());
    }
  }
}
