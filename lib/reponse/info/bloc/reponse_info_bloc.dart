import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/qag/repository/qag_repository.dart';
import 'package:agora/reponse/info/bloc/reponse_info_event.dart';
import 'package:agora/reponse/info/bloc/reponse_info_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReponseInfoBloc extends Bloc<ReponseInfoEvent, ReponseInfoState> {
  final QagRepository qagRepository;

  ReponseInfoBloc({
    required this.qagRepository,
  }) : super(ReponseInfoState.init()) {
    on<FetchReponseInfoEvent>(_handleFetchReponseInfo);
  }

  Future<void> _handleFetchReponseInfo(
    FetchReponseInfoEvent event,
    Emitter<ReponseInfoState> emit,
  ) async {
    emit(state.clone(status: AllPurposeStatus.loading));
    final response = await qagRepository.getContentReponseQag();
    if (response != null) {
      emit(state.clone(status: AllPurposeStatus.success, infoText: response));
    } else {
      emit(state.clone(status: AllPurposeStatus.error));
    }
  }
}
