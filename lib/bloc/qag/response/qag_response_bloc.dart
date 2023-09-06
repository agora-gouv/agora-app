import 'package:agora/bloc/qag/response/qag_response_event.dart';
import 'package:agora/bloc/qag/response/qag_response_state.dart';
import 'package:agora/infrastructure/qag/presenter/qag_response_presenter.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagResponseBloc extends Bloc<FetchQagsResponseEvent, QagResponseState> {
  final QagRepository qagRepository;

  QagResponseBloc({required this.qagRepository}) : super(QagResponseInitialLoadingState()) {
    on<FetchQagsResponseEvent>(_handleFetchQagsResponse);
  }

  Future<void> _handleFetchQagsResponse(
    FetchQagsResponseEvent event,
    Emitter<QagResponseState> emit,
  ) async {
    final response = await qagRepository.fetchQagsResponse();
    if (response is GetQagsResponseSucceedResponse) {
      final qagResponseViewModels = QagResponsePresenter.presentQagResponse(
        incomingQagResponses: response.qagResponsesIncoming,
        qagResponses: response.qagResponses,
      );
      emit(QagResponseFetchedState(qagResponseViewModels: qagResponseViewModels));
    } else if (response is GetQagsResponseFailedResponse) {
      emit(QagResponseErrorState());
    }
  }
}
