import 'package:agora/qag/count/bloc/qags_count_event.dart';
import 'package:agora/qag/count/bloc/qags_count_state.dart';
import 'package:agora/qag/repository/qag_repository.dart';
import 'package:agora/welcome/bloc/welcome_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagsCountBloc extends Bloc<QagsCountEvent, QagsCountState> {
  final QagRepository qagRepository;

  QagsCountBloc({
    required this.qagRepository,
  }) : super(QagsCountState.init()) {
    on<FetchQagsCountEvent>(_handleFetchQagsCount);
  }

  Future<void> _handleFetchQagsCount(
    FetchQagsCountEvent event,
    Emitter<QagsCountState> emit,
  ) async {
    emit(state.clone(status: AllPurposeStatus.loading));
    final response = await qagRepository.getQagsCount();
    if (response != null) {
      emit(state.clone(status: AllPurposeStatus.success, count: response));
    } else {
      emit(state.clone(status: AllPurposeStatus.error));
    }
  }
}
