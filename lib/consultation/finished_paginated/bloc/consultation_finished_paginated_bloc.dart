import 'package:agora/concertation/repository/concertation_repository.dart';
import 'package:agora/consultation/domain/consultation.dart';
import 'package:agora/consultation/finished_paginated/bloc/consultation_finished_paginated_event.dart';
import 'package:agora/consultation/finished_paginated/bloc/consultation_finished_paginated_state.dart';
import 'package:agora/consultation/finished_paginated/pages/consultation_finished_paginated_page.dart';
import 'package:agora/consultation/repository/consultation_finished_paginated_presenter.dart';
import 'package:agora/consultation/repository/consultation_repository.dart';
import 'package:agora/consultation/repository/consultation_responses.dart';
import 'package:agora/profil/demographic/domain/demographic_question_type.dart';
import 'package:agora/profil/demographic/repository/demographic_repository.dart';
import 'package:agora/territorialisation/departement.dart';
import 'package:agora/territorialisation/pays.dart';
import 'package:agora/territorialisation/repository/referentiel_repository.dart';
import 'package:agora/territorialisation/territoire.dart';
import 'package:agora/territorialisation/territoire_helper.dart';
import 'package:agora/welcome/bloc/welcome_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optional/optional.dart';

class ConsultationPaginatedBloc extends Bloc<FetchConsultationPaginatedEvent, ConsultationPaginatedState> {
  final ConsultationRepository consultationRepository;
  final ConcertationRepository concertationRepository;
  final ReferentielRepository referentielRepository;
  final DemographicRepository demographicRepository;

  ConsultationPaginatedBloc({
    required this.consultationRepository,
    required this.concertationRepository,
    required this.referentielRepository,
    required this.demographicRepository,
  }) : super(ConsultationPaginatedState.init()) {
    on<FetchConsultationPaginatedEvent>(_handleFetchConsultationPaginated);
  }

  Future<void> _handleFetchConsultationPaginated(
    FetchConsultationPaginatedEvent event,
    Emitter<ConsultationPaginatedState> emit,
  ) async {
    emit(
      state.clone(
        maxPage: event.pageNumber == 1 ? -1 : state.maxPage,
        currentPageNumber: event.pageNumber,
        consultationsListState: ConsultationsListState(
          status: AllPurposeStatus.loading,
          consultationViewModels: event.pageNumber == 1 ? [] : state.consultationsListState.consultationViewModels,
        ),
        territoireState: state.territoireState.clone(
          status: state.territoireState.territoires.isEmpty ? AllPurposeStatus.loading : state.territoireState.status,
        ),
      ),
    );
    GetConsultationsFinishedPaginatedRepositoryResponse consultationResponse;
    List<Concertation> concertations = [];

    final referentielReponse = await referentielRepository.fetchReferentielRegionsEtDepartements();
    if (event.type == ConsultationPaginatedPageType.finished) {
      consultationResponse = await consultationRepository.fetchConsultationsFinishedPaginated(
        pageNumber: event.pageNumber,
        territoire: event.filtreTerritoire,
      );
      if (event.filtreTerritoire == null || event.filtreTerritoire == Pays(label: "National")) {
        concertations = await concertationRepository.fetchConcertations();
      }
    } else {
      consultationResponse =
          await consultationRepository.fetchConsultationsAnsweredPaginated(pageNumber: event.pageNumber);
    }
    if (consultationResponse is GetConsultationsPaginatedSucceedResponse) {
      final viewModels = ConsultationFinishedPaginatedPresenter.presentPaginatedConsultations(
        consultationResponse.consultationsPaginated,
        concertations,
        referentielReponse,
      );

      final profilResponse = await demographicRepository.getDemographicResponses();
      emit(
        state.clone(
          maxPage: consultationResponse.maxPage,
          currentPageNumber: event.pageNumber,
          consultationsListState: ConsultationsListState(
            status: AllPurposeStatus.success,
            consultationViewModels:
                event.pageNumber == 1 ? viewModels : state.consultationsListState.consultationViewModels + viewModels,
          ),
          territoireState: TerritoireState(
            status: AllPurposeStatus.success,
            territoires: _getTerritoiresFromProfil(profilResponse, referentielReponse),
          ),
          filtreTerritoireOptional: Optional.ofNullable(event.filtreTerritoire),
        ),
      );
    } else {
      emit(
        state.clone(
          currentPageNumber: event.pageNumber,
          consultationsListState: ConsultationsListState(
            status: AllPurposeStatus.error,
            consultationViewModels: state.consultationsListState.consultationViewModels,
          ),
          territoireState: TerritoireState(
            status: AllPurposeStatus.error,
            territoires: state.territoireState.territoires,
          ),
        ),
      );
    }
  }

  List<Territoire> _getTerritoiresFromProfil(
    GetDemographicInformationRepositoryResponse profilResponse,
    List<Territoire> referentiel,
  ) {
    List<Departement> departements = [];
    if (profilResponse is GetDemographicInformationSucceedResponse) {
      final premierDepartement = profilResponse.demographicInformations
          .where((info) => info.demographicType == DemographicQuestionType.primaryDepartment)
          .first
          .data;
      final secondDepartement = profilResponse.demographicInformations
          .where((info) => info.demographicType == DemographicQuestionType.secondaryDepartment)
          .first
          .data;
      departements = [premierDepartement, secondDepartement]
          .map((label) => label != null ? Departement(label: label) : null)
          .nonNulls
          .toList();
    }
    final regions =
        departements.map((departement) => getRegionFromDepartement(departement, referentiel)).toSet().toList();
    return [...regions, ...departements];
  }
}
