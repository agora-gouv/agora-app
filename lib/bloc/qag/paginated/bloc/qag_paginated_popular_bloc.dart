import 'package:agora/bloc/qag/paginated/bloc/qag_paginated_bloc.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_event.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_state.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_view_model.dart';
import 'package:agora/domain/qag/qag_paginated_filter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagPaginatedPopularBloc extends QagPaginatedBloc {
  QagPaginatedPopularBloc({required super.qagRepository}) : super(qagPaginatedFilter: QagPaginatedFilter.popular);

  @override
  Future<void> handleUpdateQagsPaginated(
    UpdateQagsPaginatedEvent event,
    Emitter<QagPaginatedState> emit,
  ) async {
    if (state is QagPaginatedFetchedState) {
      final currentState = state as QagPaginatedFetchedState;

      final popularQagViewModelsCopy = [...currentState.qagViewModels];
      final updatedPopularIndex = popularQagViewModelsCopy.indexWhere((popular) => popular.id == event.qagId);

      if (updatedPopularIndex != -1) {
        final updatedPopular = popularQagViewModelsCopy[updatedPopularIndex];
        popularQagViewModelsCopy[updatedPopularIndex] = QagPaginatedViewModel(
          id: updatedPopular.id,
          thematique: updatedPopular.thematique,
          title: updatedPopular.title,
          username: updatedPopular.username,
          date: updatedPopular.date,
          supportCount: event.supportCount,
          isSupported: event.isSupported,
          isAuthor: updatedPopular.isAuthor,
        );
      }

      emit(
        QagPaginatedFetchedState(
          qagViewModels: popularQagViewModelsCopy,
          currentPageNumber: currentState.currentPageNumber,
          maxPage: currentState.maxPage,
        ),
      );
    }
  }
}
