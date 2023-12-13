import 'package:agora/bloc/qag/ask_qag/ask_qag_event.dart';
import 'package:agora/bloc/qag/ask_qag/ask_qag_state.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AskQagBloc extends Bloc<AskQagEvent, AskQagState> {
  final QagRepository qagRepository;

  AskQagBloc({required this.qagRepository}) : super(AskQagInitialLoadingState()) {
    on<FetchAskQagStatusEvent>(_handleFetchAskQagStatus);
  }

  Future<void> _handleFetchAskQagStatus(
    FetchAskQagStatusEvent event,
    Emitter<AskQagState> emit,
  ) async {
    final response = await qagRepository.fetchAskQagStatus();
    if (response is AskQagStatusSucceedResponse) {
      emit(QagAskFetchedState(askQagError: response.askQagError));
    } else if (response is AskQagStatusFailedResponse) {
      emit(AskQagErrorState(errorType: response.errorType));
    }
  }
}
