import 'package:agora/bloc/consultation/dynamic/dynamic_consultation_events.dart';
import 'package:agora/bloc/consultation/dynamic/dynamic_consultation_state.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DynamicConsultationBloc extends Bloc<DynamicConsultationEvent, DynamicConsultationState> {
  final ConsultationRepository consultationRepository;

  DynamicConsultationBloc(this.consultationRepository) : super(DynamicConsultationLoadingState()) {
    on<FetchDynamicConsultationEvent>(_handleFetchDynamicConsultationEvent);
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
}

class DynamicConsultationFeedbackBloc extends Bloc<DynamicConsultationEvent, void> {
  final ConsultationRepository consultationRepository;

  DynamicConsultationFeedbackBloc(this.consultationRepository) : super(DynamicConsultationLoadingState()) {
    on<SendConsultationUpdateFeedbackEvent>(_handleSendConsultationUpdateFeedbackEvent);
    on<DeleteConsultationUpdateFeedbackEvent>(_handleDeleteConsultationUpdateFeedbackEvent);
  }

  Future<void> _handleSendConsultationUpdateFeedbackEvent(
    SendConsultationUpdateFeedbackEvent event,
    Emitter<void> emit,
  ) async {
    consultationRepository.sendConsultationUpdateFeedback(event.updateId, event.consultationId, event.isPositive);
  }

  Future<void> _handleDeleteConsultationUpdateFeedbackEvent(
    DeleteConsultationUpdateFeedbackEvent event,
    Emitter<void> emit,
  ) async {
    consultationRepository.deleteConsultationUpdateFeedback(event.updateId, event.consultationId);
  }
}
