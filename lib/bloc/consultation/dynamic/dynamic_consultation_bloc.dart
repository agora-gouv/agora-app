import 'package:agora/bloc/consultation/dynamic/dynamic_consultation_events.dart';
import 'package:agora/bloc/consultation/dynamic/dynamic_consultation_state.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DynamicConsultationBloc extends Bloc<DynamicConsultationEvent, DynamicConsultationState> {
  final ConsultationRepository consultationRepository;

  DynamicConsultationBloc(this.consultationRepository) : super(DynamicConsultationLoadingState()) {
    on<FetchDynamicConsultationEvent>(_handleFetchDynamicConsultationEvent);
    on<SendConsultationUpdateFeedbackEvent>(_handleSendConsultationUpdateFeedbackEvent);
  }

  Future<void> _handleFetchDynamicConsultationEvent(
    FetchDynamicConsultationEvent event,
    Emitter<DynamicConsultationState> emit,
  ) async {
    final response = await consultationRepository.getDynamicConsultation(event.id);
    if (response is DynamicConsultationSuccessResponse) {
      emit(DynamicConsultationSuccessState(response.consultation));
    } else {
      emit(DynamicConsultationErrorState());
    }
  }

  Future<void> _handleSendConsultationUpdateFeedbackEvent(
    SendConsultationUpdateFeedbackEvent event,
    Emitter<DynamicConsultationState> emit,
  ) async {
    consultationRepository.sendConsultationUpdateFeedback(event.updateId, event.consultationId, event.isPositive);
  }
}
