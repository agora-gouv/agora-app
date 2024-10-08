import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/qag/repository/presenter/qag_response_paginated_presenter.dart';
import 'package:agora/qag/repository/qag_repository.dart';
import 'package:agora/reponse/bloc/paginated/qag_response_paginated_event.dart';
import 'package:agora/reponse/bloc/paginated/qag_response_paginated_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagResponsePaginatedBloc extends Bloc<FetchQagsResponsePaginatedEvent, QagResponsePaginatedState> {
  final QagRepository qagRepository;

  QagResponsePaginatedBloc({
    required this.qagRepository,
  }) : super(QagResponsePaginatedState.init()) {
    on<FetchQagsResponsePaginatedEvent>(_handleFetchQagResponsePaginated);
  }

  Future<void> _handleFetchQagResponsePaginated(
    FetchQagsResponsePaginatedEvent event,
    Emitter<QagResponsePaginatedState> emit,
  ) async {
    emit(
      state.clone(
        status: AllPurposeStatus.loading,
        maxPage: event.pageNumber == 1 ? -1 : state.maxPage,
        currentPageNumber: event.pageNumber,
        qagResponseViewModels: event.pageNumber == 1 ? [] : state.qagResponseViewModels,
      ),
    );
    final response = await qagRepository.fetchQagsResponsePaginated(pageNumber: event.pageNumber);
    if (response is GetQagsResponsePaginatedSucceedResponse) {
      final viewModels = QagResponsePaginatedPresenter.presentQagResponsePaginated(
        paginatedQagsResponse: response.paginatedQagsResponse,
      );
      emit(
        state.clone(
          status: AllPurposeStatus.success,
          maxPage: response.maxPage,
          currentPageNumber: event.pageNumber,
          qagResponseViewModels: event.pageNumber == 1 ? viewModels : state.qagResponseViewModels + viewModels,
        ),
      );
    } else {
      emit(
        state.clone(
          status: AllPurposeStatus.error,
          maxPage: state.maxPage,
          currentPageNumber: event.pageNumber,
          qagResponseViewModels: state.qagResponseViewModels,
        ),
      );
    }
  }
}
