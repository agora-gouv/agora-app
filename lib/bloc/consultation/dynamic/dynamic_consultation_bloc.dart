import 'package:agora/bloc/consultation/dynamic/dynamic_consultation_events.dart';
import 'package:agora/bloc/consultation/dynamic/dynamic_consultation_state.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DynamicConsultationBloc extends Bloc<FetchDynamicConsultationEvent, DynamicConsultationState> {
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
