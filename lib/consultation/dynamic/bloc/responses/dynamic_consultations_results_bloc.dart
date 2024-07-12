import 'package:agora/consultation/dynamic/bloc/dynamic_consultation_events.dart';
import 'package:agora/consultation/dynamic/bloc/responses/dynamic_consultation_results_state.dart';
import 'package:agora/consultation/repository/consultation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DynamicConsultationResultsBloc
    extends Bloc<FetchDynamicConsultationResultsEvent, DynamicConsultationResultsState> {
  final ConsultationRepository consultationRepository;

  DynamicConsultationResultsBloc(this.consultationRepository) : super(DynamicConsultationResultsLoadingState()) {
    on<FetchDynamicConsultationResultsEvent>(_handleFetchDynamicConsultationResultsEvent);
  }

  Future<void> _handleFetchDynamicConsultationResultsEvent(
    FetchDynamicConsultationResultsEvent event,
    Emitter<DynamicConsultationResultsState> emit,
  ) async {
    emit(DynamicConsultationResultsLoadingState());
    final response = await consultationRepository.fetchDynamicConsultationResults(consultationId: event.id);
    if (response is DynamicConsultationsResultsSuccessResponse) {
      emit(
        DynamicConsultationResultsSuccessState(
          participantCount: response.participantCount,
          results: response.results,
          title: response.title,
          coverUrl: response.coverUrl,
        ),
      );
    } else {
      emit(DynamicConsultationResultsErrorState());
    }
  }
}
