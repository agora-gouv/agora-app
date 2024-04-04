import 'package:agora/bloc/consultation/finished_paginated/consultation_finished_paginated_event.dart';
import 'package:agora/bloc/consultation/finished_paginated/consultation_finished_paginated_state.dart';
import 'package:agora/infrastructure/consultation/presenter/consultation_finished_paginated_presenter.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';
import 'package:agora/pages/consultation/finished_paginated/consultation_finished_paginated_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationPaginatedBloc extends Bloc<FetchConsultationPaginatedEvent, ConsultationPaginatedState> {
  final ConsultationRepository consultationRepository;

  ConsultationPaginatedBloc({
    required this.consultationRepository,
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
    final response = await switch (event.type) {
      ConsultationPaginatedPageType.finished =>
        consultationRepository.fetchConsultationsFinishedPaginated(pageNumber: event.pageNumber),
      ConsultationPaginatedPageType.answered =>
        consultationRepository.fetchConsultationsAnsweredPaginated(pageNumber: event.pageNumber),
    };
    if (response is GetConsultationsPaginatedSucceedResponse) {
      final viewModels = ConsultationFinishedPaginatedPresenter.presentPaginatedConsultations(
        response.consultationsPaginated,
      );
      emit(
        ConsultationPaginatedFetchedState(
          maxPage: response.maxPage,
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
