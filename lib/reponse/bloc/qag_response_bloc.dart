import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/qag/repository/qag_cache_repository.dart';
import 'package:agora/qag/repository/qag_repository.dart';
import 'package:agora/reponse/bloc/qag_response_event.dart';
import 'package:agora/reponse/bloc/qag_response_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagResponseBloc extends Bloc<FetchQagsResponseEvent, QagResponseState> {
  final QagResponseState previousState;
  final QagCacheRepository qagRepository;

  QagResponseBloc({
    required this.previousState,
    required this.qagRepository,
  }) : super(previousState) {
    on<FetchQagsResponseEvent>(_handleFetchQagsResponse);
  }

  factory QagResponseBloc.fromRepository({required QagCacheRepository qagRepository}) {
    if (qagRepository.qagResponseData is GetQagsResponseSucceedResponse) {
      final qagRepositoryResponse = qagRepository.qagResponseData as GetQagsResponseSucceedResponse;
      return QagResponseBloc(
        previousState: QagResponseState(
          status: AllPurposeStatus.success,
          incomingQagResponses: qagRepositoryResponse.qagResponsesIncoming,
          qagResponses: qagRepositoryResponse.qagResponses,
        ),
        qagRepository: qagRepository,
      );
    }
    return QagResponseBloc(
      previousState: QagResponseState.init(),
      qagRepository: qagRepository,
    );
  }

  Future<void> _handleFetchQagsResponse(
    FetchQagsResponseEvent event,
    Emitter<QagResponseState> emit,
  ) async {
    if (previousState.status != AllPurposeStatus.success || event.forceRefresh) {
      emit(state.clone(status: AllPurposeStatus.loading));
      final response = await qagRepository.fetchQagsResponse();
      if (response is GetQagsResponseSucceedResponse) {
        emit(
          state.clone(
            status: AllPurposeStatus.success,
            incomingQagResponses: response.qagResponsesIncoming,
            qagResponses: response.qagResponses,
          ),
        );
      } else if (response is GetQagsResponseFailedResponse) {
        emit(state.clone(status: AllPurposeStatus.error));
      }
    }
  }
}
