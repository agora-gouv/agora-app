import 'package:agora/bloc/consultation/summary/consultation_summary_event.dart';
import 'package:agora/bloc/consultation/summary/consultation_summary_state.dart';
import 'package:agora/infrastructure/consultation/presenter/consultation_summary_presenter.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationSummaryBloc extends Bloc<FetchConsultationSummaryEvent, ConsultationSummaryState> {
  final ConsultationRepository consultationRepository;

  ConsultationSummaryBloc({required this.consultationRepository}) : super(ConsultationSummaryInitialLoadingState()) {
    on<FetchConsultationSummaryEvent>(_handleConsultationSummary);
  }

  Future<void> _handleConsultationSummary(
    FetchConsultationSummaryEvent event,
    Emitter<ConsultationSummaryState> emit,
  ) async {
    final response = await consultationRepository.fetchConsultationSummary(consultationId: event.consultationId);
    if (response is GetConsultationSummarySucceedResponse) {
      final consultationSummaryViewModel = ConsultationSummaryPresenter.present(response.consultationSummary);
      emit(ConsultationSummaryFetchedState(consultationSummaryViewModel));
    } else {
      emit(ConsultationSummaryErrorState());
    }
  }
}
