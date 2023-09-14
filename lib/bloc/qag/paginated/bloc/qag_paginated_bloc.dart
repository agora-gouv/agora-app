import 'package:agora/bloc/qag/paginated/qag_paginated_event.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_state.dart';
import 'package:agora/domain/qag/qag_paginated_filter.dart';
import 'package:agora/infrastructure/qag/presenter/qag_paginated_presenter.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class QagPaginatedBloc extends Bloc<QagsPaginatedEvent, QagPaginatedState> {
  final QagRepository qagRepository;
  final QagPaginatedFilter qagPaginatedFilter;

  QagPaginatedBloc({
    required this.qagRepository,
    required this.qagPaginatedFilter,
  }) : super(QagPaginatedInitialState()) {
    on<FetchQagsPaginatedEvent>(_handleFetchQagPaginated);
    on<UpdateQagsPaginatedEvent>(handleUpdateQagsPaginated);
  }

  Future<void> _handleFetchQagPaginated(
    FetchQagsPaginatedEvent event,
    Emitter<QagPaginatedState> emit,
  ) async {
    emit(
      QagPaginatedLoadingState(
        maxPage: event.pageNumber == 1 ? -1 : state.maxPage,
        currentPageNumber: event.pageNumber,
        qagViewModels: event.pageNumber == 1 ? [] : state.qagViewModels,
      ),
    );
    final response = await qagRepository.fetchQagsPaginated(
      pageNumber: event.pageNumber,
      thematiqueId: event.thematiqueId,
      filter: qagPaginatedFilter,
      keywords: event.keywords,
    );
    if (response is GetQagsPaginatedSucceedResponse) {
      final viewModels = QagPaginatedPresenter.presentQagPaginated(response.paginatedQags);
      emit(
        QagPaginatedFetchedState(
          maxPage: response.maxPage,
          currentPageNumber: event.pageNumber,
          qagViewModels: event.pageNumber == 1 ? viewModels : state.qagViewModels + viewModels,
        ),
      );
    } else {
      emit(
        QagPaginatedErrorState(
          maxPage: state.maxPage,
          currentPageNumber: event.pageNumber,
          qagViewModels: state.qagViewModels,
        ),
      );
    }
  }

  Future<void> handleUpdateQagsPaginated(
    UpdateQagsPaginatedEvent event,
    Emitter<QagPaginatedState> emit,
  );
}
