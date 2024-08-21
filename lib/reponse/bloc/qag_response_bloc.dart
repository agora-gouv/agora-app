import 'package:agora/reponse/bloc/qag_response_event.dart';
import 'package:agora/reponse/bloc/qag_response_state.dart';
import 'package:agora/qag/repository/qag_repository.dart';
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
    emit(QagResponseInitialLoadingState());
    final response = await qagRepository.fetchQagsResponse();
    if (response is GetQagsResponseSucceedResponse) {
      emit(
        QagResponseFetchedState(
          incomingQagResponses: response.qagResponsesIncoming,
          qagResponses: response.qagResponses,
        ),
      );
    } else if (response is GetQagsResponseFailedResponse) {
      emit(QagResponseErrorState());
    }
  }
}
