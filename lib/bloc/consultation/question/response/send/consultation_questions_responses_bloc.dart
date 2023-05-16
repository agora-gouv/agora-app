import 'package:agora/bloc/consultation/question/response/send/consultation_questions_responses_event.dart';
import 'package:agora/bloc/consultation/question/response/send/consultation_questions_responses_state.dart';
import 'package:agora/common/helper/device_info_helper.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationQuestionsResponsesBloc
    extends Bloc<SendConsultationQuestionsResponsesEvent, SendConsultationQuestionsResponsesState> {
  final ConsultationRepository consultationRepository;
  final DeviceInfoHelper deviceInfoHelper;

  ConsultationQuestionsResponsesBloc({
    required this.consultationRepository,
    required this.deviceInfoHelper,
  }) : super(SendConsultationQuestionsResponsesInitialLoadingState()) {
    on<SendConsultationQuestionsResponsesEvent>(_handleSendConsultationQuestionsResponses);
  }

  Future<void> _handleSendConsultationQuestionsResponses(
    SendConsultationQuestionsResponsesEvent event,
    Emitter<SendConsultationQuestionsResponsesState> emit,
  ) async {
    final deviceId = await deviceInfoHelper.getDeviceId();
    if (deviceId == null) {
      emit(SendConsultationQuestionsResponsesFailureState());
      return;
    }
    final response = await consultationRepository.sendConsultationResponses(
      consultationId: event.consultationId,
      deviceId: deviceId,
      questionsResponses: event.questionsResponses,
    );
    if (response is SendConsultationResponsesSucceedResponse) {
      emit(
        SendConsultationQuestionsResponsesSuccessState(
          shouldDisplayDemographicInformation: response.shouldDisplayDemographicInformation,
        ),
      );
    } else {
      emit(SendConsultationQuestionsResponsesFailureState());
    }
  }
}
