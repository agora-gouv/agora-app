import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/concertation/repository/concertation_cache_repository.dart';
import 'package:agora/consultation/bloc/consultation_event.dart';
import 'package:agora/consultation/bloc/consultation_state.dart';
import 'package:agora/consultation/domain/consultation.dart';
import 'package:agora/consultation/repository/consultation_cache_repository.dart';
import 'package:agora/consultation/repository/consultation_presenter.dart';
import 'package:agora/consultation/repository/consultation_responses.dart';
import 'package:agora/referentiel/repository/referentiel_cache_repository.dart';
import 'package:agora/referentiel/territoire.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optional/optional.dart';

class ConsultationBloc extends Bloc<FetchConsultationsEvent, ConsultationState> {
  final ConsultationState previousState;
  final ConsultationCacheRepository consultationRepository;
  final ConcertationCacheRepository concertationRepository;
  final ReferentielCacheRepository referentielRepository;

  ConsultationBloc({
    required this.previousState,
    required this.consultationRepository,
    required this.concertationRepository,
    required this.referentielRepository,
  }) : super(previousState) {
    on<FetchConsultationsEvent>(_handleConsultations);
  }

  factory ConsultationBloc.fromRepositories({
    required ConsultationCacheRepository consultationRepository,
    required ConcertationCacheRepository concertationRepository,
    required ReferentielCacheRepository referentielRepository,
  }) {
    if (consultationRepository.isCacheSuccess &&
        concertationRepository.isCacheSuccess &&
        referentielRepository.isCacheSuccess) {
      final successState = _getSuccessState(
        consultationRepository.consultationsData as GetConsultationsSucceedResponse,
        concertationRepository.concertationData,
        referentielRepository.referentielData,
      );
      return ConsultationBloc(
        previousState: successState,
        consultationRepository: consultationRepository,
        concertationRepository: concertationRepository,
        referentielRepository: referentielRepository,
      );
    }
    return ConsultationBloc(
      previousState: ConsultationState.init(AllPurposeStatus.notLoaded),
      consultationRepository: consultationRepository,
      concertationRepository: concertationRepository,
      referentielRepository: referentielRepository,
    );
  }

  Future<void> _handleConsultations(
    FetchConsultationsEvent event,
    Emitter<ConsultationState> emit,
  ) async {
    if (previousState.status != AllPurposeStatus.success || event.forceRefresh) {
      emit(state.clone(status: AllPurposeStatus.loading));
      final referentielResponse = await referentielRepository.fetchReferentielRegionsEtDepartements();
      final consultationsResponse = await consultationRepository.fetchConsultations(true);

      if (consultationsResponse is GetConsultationsSucceedResponse) {
        final concertationResponse = await concertationRepository.fetchConcertations();
        final successState = _getSuccessState(consultationsResponse, concertationResponse, referentielResponse);
        emit(
          state.clone(
            status: AllPurposeStatus.success,
            ongoingViewModels: successState.ongoingViewModels,
            finishedViewModels: successState.finishedViewModels,
            answeredViewModels: successState.answeredViewModels,
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
}

ConsultationState _getSuccessState(
  GetConsultationsSucceedResponse consultationsResponse,
  List<Concertation> concertationResponse,
  List<Territoire> referentielResponse,
) {
  final ongoingViewModels = ConsultationPresenter.presentOngoingConsultations(
    consultationsResponse.ongoingConsultations,
    referentielResponse,
  );
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
  return ConsultationState(
    status: AllPurposeStatus.success,
    ongoingViewModels: ongoingViewModels,
    finishedViewModels: finishedConsultations,
    answeredViewModels: answeredViewModels,
    shouldDisplayFinishedAllButton: consultationsResponse.finishedConsultations.isNotEmpty,
  );
}
