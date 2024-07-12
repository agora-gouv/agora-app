import 'package:agora/qag/ask/bloc/ask_qag_status_event.dart';
import 'package:agora/qag/ask/bloc/ask_qag_status_state.dart';
import 'package:agora/qag/repository/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AskQagStatusBloc extends Bloc<AskQagStatusEvent, AskQagStatusState> {
  final QagRepository qagRepository;

  AskQagStatusBloc({required this.qagRepository}) : super(AskQagInitialLoadingState()) {
    on<FetchAskQagStatusEvent>(_handleFetchAskQagStatus);
  }

  Future<void> _handleFetchAskQagStatus(
    FetchAskQagStatusEvent event,
    Emitter<AskQagStatusState> emit,
  ) async {
    final response = await qagRepository.fetchAskQagStatus();
    if (response is AskQagStatusSucceedResponse) {
      emit(AskQagStatusFetchedState(askQagError: response.askQagError));
    } else if (response is AskQagStatusFailedResponse) {
      emit(AskQagErrorState(errorType: response.errorType));
    }
  }
}
