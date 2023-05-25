import 'package:agora/bloc/qag/moderation/moderate/qag_moderate_event.dart';
import 'package:agora/bloc/qag/moderation/moderate/qag_moderate_state.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagModerateBloc extends Bloc<QagModerateEvent, QagModerateState> {
  final QagRepository qagRepository;

  QagModerateBloc({required this.qagRepository}) : super(QagModerateInitialState()) {
    on<QagModerateEvent>(_handleQagModerateAccept);
  }

  Future<void> _handleQagModerateAccept(
    QagModerateEvent event,
    Emitter<QagModerateState> emit,
  ) async {
    emit(QagModerateLoadingState(qagId: event.qagId, isAccept: event.isAccept));
    await Future.delayed(Duration(seconds: 1));
    final response = await qagRepository.moderateQag(
      qagId: event.qagId,
      isAccepted: event.isAccept,
    );
    if (response is ModerateQagSuccessResponse) {
      emit(QagModerateSuccessState(qagId: event.qagId));
    } else {
      emit(QagModerateErrorState(qagId: event.qagId));
    }
  }
}
