import 'package:agora/concertation/repository/concertation_repository.dart';
import 'package:agora/consultation/bloc/consultation_event.dart';
import 'package:agora/consultation/bloc/consultation_state.dart';
import 'package:agora/consultation/repository/consultation_presenter.dart';
import 'package:agora/consultation/repository/consultation_repository.dart';
import 'package:agora/consultation/repository/consultation_responses.dart';
import 'package:agora/territorialisation/repository/referentiel_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationBloc extends Bloc<FetchConsultationsEvent, ConsultationState> {
  final ConsultationRepository consultationRepository;
  final ConcertationRepository concertationRepository;
  final ReferentielRepository referentielRepository;

  ConsultationBloc({
    required this.consultationRepository,
    required this.concertationRepository,
    required this.referentielRepository,
  }) : super(ConsultationInitialLoadingState()) {
    on<FetchConsultationsEvent>(_handleConsultations);
  }

  Future<void> _handleConsultations(
    FetchConsultationsEvent event,
    Emitter<ConsultationState> emit,
  ) async {
    emit(ConsultationInitialLoadingState());
    final referentielResponse = await referentielRepository.fetchReferentielRegionsEtDepartements();
    final consultationsResponse = await consultationRepository.fetchConsultations();

    if (consultationsResponse is GetConsultationsSucceedResponse) {
      final ongoingViewModels = ConsultationPresenter.presentOngoingConsultations(
        consultationsResponse.ongoingConsultations,
        referentielResponse,
      );
      final concertationResponse = await concertationRepository.fetchConcertations();
      final finishedConsultations = ConsultationPresenter.presentFinishedConsultations(
        ongoingConsultations: consultationsResponse.ongoingConsultations,
        finishedConsultations: consultationsResponse.finishedConsultations,
        concertations: concertationResponse,
        referentiel: referentielResponse,
      );
      final answeredViewModels = ConsultationPresenter.presentAnsweredConsultations(
        consultationsResponse.answeredConsultations,
        referentielResponse,
      );
      emit(
        ConsultationsFetchedState(
          ongoingViewModels: ongoingViewModels,
          finishedViewModels: finishedConsultations,
          answeredViewModels: answeredViewModels,
          shouldDisplayFinishedAllButton: consultationsResponse.finishedConsultations.isNotEmpty,
        ),
      );
    } else if (consultationsResponse is GetConsultationsFailedResponse) {
      emit(ConsultationErrorState(errorType: consultationsResponse.errorType));
    }
  }
}
