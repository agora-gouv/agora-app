import 'package:agora/consultation/dynamic/bloc/dynamic_consultation_events.dart';
import 'package:agora/consultation/dynamic/bloc/updates/dynamic_consultation_update_state.dart';
import 'package:agora/consultation/repository/consultation_repository.dart';
import 'package:agora/consultation/repository/consultation_responses.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DynamicConsultationUpdatesBloc
    extends Bloc<FetchDynamicConsultationUpdateEvent, DynamicConsultationUpdatesState> {
  final ConsultationRepository consultationRepository;

  DynamicConsultationUpdatesBloc(this.consultationRepository) : super(DynamicConsultationUpdatesLoadingState()) {
    on<FetchDynamicConsultationUpdateEvent>(_handleFetchDynamicConsultationUpdateEvent);
  }

  Future<void> _handleFetchDynamicConsultationUpdateEvent(
    FetchDynamicConsultationUpdateEvent event,
    Emitter<DynamicConsultationUpdatesState> emit,
  ) async {
    emit(DynamicConsultationUpdatesLoadingState());
    final DynamicConsultationUpdateResponse response = await consultationRepository.fetchDynamicConsultationUpdate(
      updateId: event.id,
      consultationId: event.consultationId,
    );
    if (response is DynamicConsultationUpdateSuccessResponse) {
      emit(
        DynamicConsultationUpdatesSuccessState(response.update),
      );
    } else {
      emit(DynamicConsultationUpdatesErrorState());
    }
  }
}
