import 'package:agora/bloc/qag/paginated/bloc/qag_paginated_bloc.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_event.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_state.dart';
import 'package:agora/domain/qag/qag_paginated_filter.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagPaginatedSupportingBloc extends QagPaginatedBloc {
  QagPaginatedSupportingBloc({required QagRepository qagRepository})
      : super(qagRepository: qagRepository, qagPaginatedFilter: QagPaginatedFilter.supporting);

  @override
  Future<void> handleUpdateQagsPaginated(
    UpdateQagsPaginatedEvent event,
    Emitter<QagPaginatedState> emit,
  ) async {
    if (state is QagPaginatedFetchedState) {
      final currentState = state as QagPaginatedFetchedState;

      final supportingQagViewModelsCopy = [...currentState.qagViewModels];
      final updatedSupportingIndex =
          supportingQagViewModelsCopy.indexWhere((supporting) => supporting.id == event.qagId);

      if (updatedSupportingIndex != -1) {
        supportingQagViewModelsCopy.removeAt(updatedSupportingIndex);
      }

      emit(
        QagPaginatedFetchedState(
          qagViewModels: supportingQagViewModelsCopy,
          currentPageNumber: currentState.currentPageNumber,
          maxPage: currentState.maxPage,
        ),
      );
    }
  }
}
