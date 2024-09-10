import 'package:agora/qag/details/bloc/support/qag_support_event.dart';
import 'package:agora/qag/details/bloc/support/qag_support_state.dart';
import 'package:agora/qag/repository/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagSupportBloc extends Bloc<QagSupportEvent, QagSupportState> {
  final QagRepository qagRepository;

  QagSupportBloc({required this.qagRepository}) : super(QagSupportInitialState()) {
    on<SupportQagEvent>(_handleQagSupport);
    on<DeleteSupportQagEvent>(_handleDeleteQagSupport);
  }

  Future<void> _handleQagSupport(
    SupportQagEvent event,
    Emitter<QagSupportState> emit,
  ) async {
    emit(QagSupportLoadingState());
    final response = await qagRepository.supportQag(qagId: event.qagId);
    if (response is SupportQagSucceedResponse) {
      emit(
        QagSupportSuccessState(
          qagId: event.qagId,
          supportCount: event.supportCount + 1,
          isSupported: !event.isSupported,
        ),
      );
    } else {
      emit(QagSupportErrorState(qagId: event.qagId));
    }
  }

  Future<void> _handleDeleteQagSupport(
    DeleteSupportQagEvent event,
    Emitter<QagSupportState> emit,
  ) async {
    emit(QagSupportLoadingState());
    final response = await qagRepository.deleteSupportQag(qagId: event.qagId);
    if (response is DeleteSupportQagSucceedResponse) {
      emit(
        QagSupportSuccessState(
          qagId: event.qagId,
          supportCount: event.supportCount - 1,
          isSupported: !event.isSupported,
        ),
      );
    } else {
      emit(QagSupportErrorState(qagId: event.qagId));
    }
  }
}
