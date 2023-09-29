import 'package:agora/bloc/qag/paginated/bloc/qag_paginated_bloc.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_event.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_state.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_view_model.dart';
import 'package:agora/domain/qag/qag_paginated_filter.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagPaginatedLatestBloc extends QagPaginatedBloc {
  QagPaginatedLatestBloc({required QagRepository qagRepository})
      : super(qagRepository: qagRepository, qagPaginatedFilter: QagPaginatedFilter.latest);

  @override
  Future<void> handleUpdateQagsPaginated(
    UpdateQagsPaginatedEvent event,
    Emitter<QagPaginatedState> emit,
  ) async {
    if (state is QagPaginatedFetchedState) {
      final currentState = state as QagPaginatedFetchedState;

      final latestQagViewModelsCopy = [...currentState.qagViewModels];
      final updatedLatestIndex = latestQagViewModelsCopy.indexWhere((latest) => latest.id == event.qagId);

      if (updatedLatestIndex != -1) {
        final updatedLatest = latestQagViewModelsCopy[updatedLatestIndex];
        latestQagViewModelsCopy[updatedLatestIndex] = QagPaginatedViewModel(
          id: updatedLatest.id,
          thematique: updatedLatest.thematique,
          title: updatedLatest.title,
          username: updatedLatest.username,
          date: updatedLatest.date,
          supportCount: event.supportCount,
          isSupported: event.isSupported,
          isAuthor: updatedLatest.isAuthor,
        );
      }

      emit(
        QagPaginatedFetchedState(
          qagViewModels: latestQagViewModelsCopy,
          currentPageNumber: currentState.currentPageNumber,
          maxPage: currentState.maxPage,
        ),
      );
    }
  }
}
