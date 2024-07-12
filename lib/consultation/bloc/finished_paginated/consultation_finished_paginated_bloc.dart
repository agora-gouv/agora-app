import 'package:agora/consultation/bloc/finished_paginated/consultation_finished_paginated_event.dart';
import 'package:agora/consultation/bloc/finished_paginated/consultation_finished_paginated_state.dart';
import 'package:agora/concertation/repository/concertation_repository.dart';
import 'package:agora/consultation/domain/consultation.dart';
import 'package:agora/consultation/repository/consultation_finished_paginated_presenter.dart';
import 'package:agora/consultation/repository/consultation_repository.dart';
import 'package:agora/consultation/pages/consultation_finished_paginated_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationPaginatedBloc extends Bloc<FetchConsultationPaginatedEvent, ConsultationPaginatedState> {
  final ConsultationRepository consultationRepository;
  final ConcertationRepository concertationRepository;

  ConsultationPaginatedBloc({
    required this.consultationRepository,
    required this.concertationRepository,
  }) : super(ConsultationFinishedPaginatedInitialState()) {
    on<FetchConsultationPaginatedEvent>(_handleFetchConsultationPaginated);
  }

  Future<void> _handleFetchConsultationPaginated(
    FetchConsultationPaginatedEvent event,
    Emitter<ConsultationPaginatedState> emit,
  ) async {
    emit(
      ConsultationFinishedPaginatedLoadingState(
        maxPage: event.pageNumber == 1 ? -1 : state.maxPage,
        currentPageNumber: event.pageNumber,
        consultationPaginatedViewModels: event.pageNumber == 1 ? [] : state.consultationPaginatedViewModels,
      ),
    );
    GetConsultationsFinishedPaginatedRepositoryResponse consultationResponse;
    List<Concertation> concertations = [];

    if (event.type == ConsultationPaginatedPageType.finished) {
      consultationResponse =
          await consultationRepository.fetchConsultationsFinishedPaginated(pageNumber: event.pageNumber);
      concertations = await concertationRepository.getConcertations();
    } else {
      consultationResponse =
          await consultationRepository.fetchConsultationsAnsweredPaginated(pageNumber: event.pageNumber);
    }
    if (consultationResponse is GetConsultationsPaginatedSucceedResponse) {
      final viewModels = ConsultationFinishedPaginatedPresenter.presentPaginatedConsultations(
        consultationResponse.consultationsPaginated,
        concertations,
      );
      emit(
        ConsultationPaginatedFetchedState(
          maxPage: consultationResponse.maxPage,
          currentPageNumber: event.pageNumber,
          consultationPaginatedViewModels:
              event.pageNumber == 1 ? viewModels : state.consultationPaginatedViewModels + viewModels,
        ),
      );
    } else {
      emit(
        ConsultationPaginatedErrorState(
          maxPage: state.maxPage,
          currentPageNumber: event.pageNumber,
          consultationPaginatedViewModels: state.consultationPaginatedViewModels,
        ),
      );
    }
  }
}
