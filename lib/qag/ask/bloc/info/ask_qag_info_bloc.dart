import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/qag/ask/bloc/info/ask_qag_info_event.dart';
import 'package:agora/qag/ask/bloc/info/ask_qag_info_state.dart';
import 'package:agora/qag/repository/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AskQagInfoBloc extends Bloc<AskQagInfoEvent, AskQagInfoState> {
  final QagRepository qagRepository;

  AskQagInfoBloc({required this.qagRepository}) : super(AskQagInfoState.init()) {
    on<FetchInfoAskQagEvent>(_handleFetchInfoAskQag);
  }

  Future<void> _handleFetchInfoAskQag(
    FetchInfoAskQagEvent event,
    Emitter<AskQagInfoState> emit,
  ) async {
    emit(state.clone(status: AllPurposeStatus.loading));
    final response = await qagRepository.getContentAskQag();
    if (response != null) {
      emit(state.clone(status: AllPurposeStatus.success, regles: response));
    } else {
      emit(state.clone(status: AllPurposeStatus.error));
    }
  }
}
