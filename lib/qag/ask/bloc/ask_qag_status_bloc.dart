import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/qag/ask/bloc/ask_qag_status_event.dart';
import 'package:agora/qag/ask/bloc/ask_qag_status_state.dart';
import 'package:agora/qag/domain/qags_error_type.dart';
import 'package:agora/qag/repository/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optional/optional.dart';

class AskQagStatusBloc extends Bloc<AskQagStatusEvent, AskQagStatusState> {
  final AskQagStatusState previousState;
  final QagRepository qagRepository;

  AskQagStatusBloc({
    required this.previousState,
    required this.qagRepository,
  }) : super(previousState) {
    on<FetchAskQagStatusEvent>(_handleFetchAskQagStatus);
  }

  factory AskQagStatusBloc.fromRepositories({
    required QagRepository qagRepository,
  }) {
    if (qagRepository.askQagStatusData is AskQagStatusSucceedResponse) {
      final askQagStatusData = qagRepository.askQagStatusData as AskQagStatusSucceedResponse;
      return AskQagStatusBloc(
        previousState: AskQagStatusState(
          status: AllPurposeStatus.success,
          askQagError: askQagStatusData.askQagError,
          errorType: QagsErrorType.generic,
        ),
        qagRepository: qagRepository,
      );
    }
    return AskQagStatusBloc(
      previousState: AskQagStatusState.init(),
      qagRepository: qagRepository,
    );
  }

  Future<void> _handleFetchAskQagStatus(
    FetchAskQagStatusEvent event,
    Emitter<AskQagStatusState> emit,
  ) async {
    if (previousState.status != AllPurposeStatus.success) {
      final response = await qagRepository.fetchAskQagStatus();
      if (response is AskQagStatusSucceedResponse) {
        emit(
          state.clone(
            status: AllPurposeStatus.success,
            askQagErrorOptional: Optional.ofNullable(response.askQagError),
          ),
        );
      } else if (response is AskQagStatusFailedResponse) {
        emit(state.clone(status: AllPurposeStatus.error, errorType: response.errorType));
      }
    }
  }
}
