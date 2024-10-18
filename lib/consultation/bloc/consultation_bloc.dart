import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/concertation/repository/concertation_repository.dart';
import 'package:agora/consultation/bloc/consultation_event.dart';
import 'package:agora/consultation/bloc/consultation_state.dart';
import 'package:agora/consultation/repository/consultation_presenter.dart';
import 'package:agora/consultation/repository/consultation_repository.dart';
import 'package:agora/consultation/repository/consultation_responses.dart';
import 'package:agora/referentiel/repository/referentiel_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optional/optional.dart';

class ConsultationBloc extends Bloc<FetchConsultationsEvent, ConsultationState> {
  // final ConsultationState previousState;
  final ConsultationRepository consultationRepository;
  final ConcertationRepository concertationRepository;
  final ReferentielRepository referentielRepository;

  ConsultationBloc({
    // required this.previousState,
    required this.consultationRepository,
    required this.concertationRepository,
    required this.referentielRepository,
  }) : super(ConsultationState.init(AllPurposeStatus.notLoaded)) {
    on<FetchConsultationsEvent>(_handleConsultations);
  }

  // factory ConsultationBloc.fromRepositories({
  //   required ConsultationRepository consultationRepository,
  //   required ConcertationRepository concertationRepository,
  //   required ReferentielRepository referentielRepository,
  // }) {
  //   if (consultationRepository.isFetchConsultationDataCached) {
  //     final previousState = ConsultationState(
  //       status: AllPurposeStatus.success,
  //       ongoingViewModels: ongoingViewModels,
  //       finishedViewModels: finishedViewModels,
  //       answeredViewModels: answeredViewModels,
  //       shouldDisplayFinishedAllButton: shouldDisplayFinishedAllButton,
  //     );
  //     return ConsultationBloc(
  //       previousState: previousState,
  //       consultationRepository: consultationRepository,
  //       concertationRepository: concertationRepository,
  //       referentielRepository: referentielRepository,
  //     );
  //   }
  // }

  Future<void> _handleConsultations(
    FetchConsultationsEvent event,
    Emitter<ConsultationState> emit,
  ) async {
    emit(state.clone(status: AllPurposeStatus.loading));
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
        state.clone(
          status: AllPurposeStatus.success,
          ongoingViewModels: ongoingViewModels,
          finishedViewModels: finishedConsultations,
          answeredViewModels: answeredViewModels,
          shouldDisplayFinishedAllButton: consultationsResponse.finishedConsultations.isNotEmpty,
        ),
      );
    } else if (consultationsResponse is GetConsultationsFailedResponse) {
      emit(
        state.clone(
          status: AllPurposeStatus.error,
          errorTypeOptional: Optional.ofNullable(
            consultationsResponse.errorType,
          ),
        ),
      );
    }
  }
}
