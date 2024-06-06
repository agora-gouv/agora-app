import 'package:agora/bloc/consultation/consultation_event.dart';
import 'package:agora/bloc/consultation/consultation_state.dart';
import 'package:agora/concertation/repository/concertation_repository.dart';
import 'package:agora/infrastructure/consultation/consultation_presenter.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationBloc extends Bloc<FetchConsultationsEvent, ConsultationState> {
  final ConsultationRepository consultationRepository;
  final ConcertationRepository concertationRepository;

  ConsultationBloc({
    required this.consultationRepository,
    required this.concertationRepository,
  }) : super(ConsultationInitialLoadingState()) {
    on<FetchConsultationsEvent>(_handleConsultations);
  }

  Future<void> _handleConsultations(
    FetchConsultationsEvent event,
    Emitter<ConsultationState> emit,
  ) async {
    final response = await consultationRepository.fetchConsultations();
    if (response is GetConsultationsSucceedResponse) {
      final ongoingViewModels = ConsultationPresenter.presentOngoingConsultations(response.ongoingConsultations);
      final concertationResponse = await concertationRepository.getConcertations();
      final finishedConsultations = ConsultationPresenter.presentFinishedConsultations(
        ongoingConsultations: response.ongoingConsultations,
        finishedConsultations: response.finishedConsultations,
        concertations: concertationResponse,
      );
      final answeredViewModels = ConsultationPresenter.presentAnsweredConsultations(response.answeredConsultations);
      emit(
        ConsultationsFetchedState(
          ongoingViewModels: ongoingViewModels,
          finishedViewModels: finishedConsultations,
          answeredViewModels: answeredViewModels,
          shouldDisplayFinishedAllButton: response.finishedConsultations.isNotEmpty,
        ),
      );
    } else if (response is GetConsultationsFailedResponse) {
      emit(ConsultationErrorState(errorType: response.errorType));
    }
  }
}
