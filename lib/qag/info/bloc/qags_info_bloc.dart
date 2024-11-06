import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/qag/info/bloc/qags_info_event.dart';
import 'package:agora/qag/info/bloc/qags_info_state.dart';
import 'package:agora/qag/repository/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagsInfoBloc extends Bloc<QagsInfoEvent, QagsInfoState> {
  final QagRepository qagRepository;

  QagsInfoBloc({
    required this.qagRepository,
  }) : super(QagsInfoState.init()) {
    on<FetchQagsInfoEvent>(_handleFetchQagsInfo);
  }

  Future<void> _handleFetchQagsInfo(
    FetchQagsInfoEvent event,
    Emitter<QagsInfoState> emit,
  ) async {
    emit(state.clone(status: AllPurposeStatus.loading));
    final response = await qagRepository.getContentQag();
    if (response != null) {
      emit(
        state.clone(
          status: AllPurposeStatus.success,
          infoText: response.info,
          texteTotalQuestions: response.texteTotalQuestions,
        ),
      );
    } else {
      emit(state.clone(status: AllPurposeStatus.error));
    }
  }
}
