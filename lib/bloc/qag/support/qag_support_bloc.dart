import 'package:agora/bloc/qag/support/qag_support_event.dart';
import 'package:agora/bloc/qag/support/qag_support_state.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
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
      emit(QagSupportSuccessState());
    } else {
      emit(QagSupportErrorState());
    }
  }

  Future<void> _handleDeleteQagSupport(
    DeleteSupportQagEvent event,
    Emitter<QagSupportState> emit,
  ) async {
    emit(QagDeleteSupportLoadingState());
    final response = await qagRepository.deleteSupportQag(qagId: event.qagId);
    if (response is DeleteSupportQagSucceedResponse) {
      emit(QagDeleteSupportSuccessState());
    } else {
      emit(QagDeleteSupportErrorState());
    }
  }
}
