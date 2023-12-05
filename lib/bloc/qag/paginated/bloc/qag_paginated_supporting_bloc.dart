import 'package:agora/bloc/qag/paginated/bloc/qag_paginated_bloc.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_event.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_state.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_view_model.dart';
import 'package:agora/domain/qag/qag_paginated_filter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagPaginatedSupportingBloc extends QagPaginatedBloc {
  QagPaginatedSupportingBloc({required super.qagRepository}) : super(qagPaginatedFilter: QagPaginatedFilter.supporting);

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
        final updatedSupportingQag = supportingQagViewModelsCopy[updatedSupportingIndex];
        if (updatedSupportingQag.isAuthor) {
          supportingQagViewModelsCopy[updatedSupportingIndex] = QagPaginatedViewModel(
            id: updatedSupportingQag.id,
            thematique: updatedSupportingQag.thematique,
            title: updatedSupportingQag.title,
            username: updatedSupportingQag.username,
            date: updatedSupportingQag.date,
            supportCount: event.supportCount,
            isSupported: event.isSupported,
            isAuthor: updatedSupportingQag.isAuthor,
          );
        } else {
          supportingQagViewModelsCopy.removeAt(updatedSupportingIndex);
        }
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
