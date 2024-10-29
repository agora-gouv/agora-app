import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/qag/repository/presenter/qag_response_paginated_presenter.dart';
import 'package:agora/qag/repository/qag_repository.dart';
import 'package:agora/reponse/bloc/paginated/qag_response_paginated_event.dart';
import 'package:agora/reponse/bloc/paginated/qag_response_paginated_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagResponsePaginatedBloc extends Bloc<FetchQagsResponsePaginatedEvent, QagResponsePaginatedState> {
  final QagResponsePaginatedState previousState;
  final QagRepository qagRepository;

  QagResponsePaginatedBloc({
    required this.previousState,
    required this.qagRepository,
  }) : super(previousState) {
    on<FetchQagsResponsePaginatedEvent>(_handleFetchQagResponsePaginated);
  }

  factory QagResponsePaginatedBloc.fromRepository({required QagRepository qagRepository}) {
    if (qagRepository.qagsResponsePaginatedRepositoryData is GetQagsResponsePaginatedSucceedResponse) {
      final qagRepositoryResponse =
          qagRepository.qagsResponsePaginatedRepositoryData as GetQagsResponsePaginatedSucceedResponse;
      return QagResponsePaginatedBloc(
        previousState: QagResponsePaginatedState(
          status: AllPurposeStatus.success,
          maxPage: qagRepositoryResponse.maxPage,
          currentPageNumber: 1,
          qagResponseViewModels: QagResponsePaginatedPresenter.presentQagResponsePaginated(
            paginatedQagsResponse: qagRepositoryResponse.paginatedQagsResponse,
          ),
        ),
        qagRepository: qagRepository,
      );
    }
    return QagResponsePaginatedBloc(
      previousState: QagResponsePaginatedState.init(),
      qagRepository: qagRepository,
    );
  }

  Future<void> _handleFetchQagResponsePaginated(
    FetchQagsResponsePaginatedEvent event,
    Emitter<QagResponsePaginatedState> emit,
  ) async {
    if (previousState.status != AllPurposeStatus.success) {
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
}
