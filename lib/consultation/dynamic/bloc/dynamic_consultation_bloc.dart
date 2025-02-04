import 'package:agora/consultation/dynamic/bloc/dynamic_consultation_events.dart';
import 'package:agora/consultation/dynamic/bloc/dynamic_consultation_state.dart';
import 'package:agora/consultation/question/repository/consultation_question_storage_client.dart';
import 'package:agora/consultation/repository/consultation_repository.dart';
import 'package:agora/consultation/repository/consultation_responses.dart';
import 'package:agora/referentiel/repository/referentiel_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DynamicConsultationBloc extends Bloc<DynamicConsultationEvent, DynamicConsultationState> {
  final ConsultationRepository consultationRepository;
  final ReferentielRepository referentielRepository;
  final ConsultationQuestionStorageClient storageClient;

  DynamicConsultationBloc({
    required this.consultationRepository,
    required this.referentielRepository,
    required this.storageClient,
  }) : super(DynamicConsultationLoadingState()) {
    on<FetchDynamicConsultationEvent>(_handleFetchDynamicConsultationEvent);
    on<DeleteConsultationResponsesEvent>(_handleDeleteConsultationResponsesEvent);
  }

  Future<void> _handleFetchDynamicConsultationEvent(
    FetchDynamicConsultationEvent event,
    Emitter<DynamicConsultationState> emit,
  ) async {
    final response = await consultationRepository.getDynamicConsultation(event.id);
    final referentiel = await referentielRepository.fetchReferentielRegionsEtDepartements();
    if (response is DynamicConsultationSuccessResponse && referentiel.isNotEmpty) {
      emit(DynamicConsultationSuccessState(response.consultation, referentiel));
    } else {
      emit(DynamicConsultationErrorState());
    }
  }

  Future<void> _handleDeleteConsultationResponsesEvent(
    DeleteConsultationResponsesEvent event,
    Emitter<DynamicConsultationState> emit,
  ) async {
    await storageClient.clear(event.consultationId);
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
