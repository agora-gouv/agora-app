import 'package:agora/bloc/consultation/finished_paginated/consultation_finished_paginated_event.dart';
import 'package:agora/bloc/consultation/finished_paginated/consultation_finished_paginated_state.dart';
import 'package:agora/infrastructure/consultation/presenter/consultation_finished_paginated_presenter.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationFinishedPaginatedBloc
    extends Bloc<FetchConsultationFinishedPaginatedEvent, ConsultationFinishedPaginatedState> {
  final ConsultationRepository consultationRepository;

  ConsultationFinishedPaginatedBloc({
    required this.consultationRepository,
  }) : super(ConsultationFinishedPaginatedInitialState()) {
    on<FetchConsultationFinishedPaginatedEvent>(_handleFetchConsultationFinishedPaginated);
  }

  Future<void> _handleFetchConsultationFinishedPaginated(
    FetchConsultationFinishedPaginatedEvent event,
    Emitter<ConsultationFinishedPaginatedState> emit,
  ) async {
    emit(
      ConsultationFinishedPaginatedLoadingState(
        maxPage: event.pageNumber == 1 ? -1 : state.maxPage,
        currentPageNumber: event.pageNumber,
        consultationFinishedViewModels: event.pageNumber == 1 ? [] : state.consultationFinishedViewModels,
      ),
    );
    final response = await consultationRepository.fetchConsultationsFinishedPaginated(pageNumber: event.pageNumber);
    if (response is GetConsultationsFinishedPaginatedSucceedResponse) {
      final viewModels = ConsultationFinishedPaginatedPresenter.presentFinishedConsultations(
        response.finishedConsultationsPaginated,
      );
      emit(
        ConsultationFinishedPaginatedFetchedState(
          maxPage: response.maxPage,
          currentPageNumber: event.pageNumber,
          consultationFinishedViewModels:
              event.pageNumber == 1 ? viewModels : state.consultationFinishedViewModels + viewModels,
        ),
      );
    } else {
      emit(
        ConsultationFinishedPaginatedErrorState(
          maxPage: state.maxPage,
          currentPageNumber: event.pageNumber,
          consultationFinishedViewModels: state.consultationFinishedViewModels,
        ),
      );
    }
  }
}
