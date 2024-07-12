import 'package:agora/qag/details/bloc/delete/qag_delete_event.dart';
import 'package:agora/qag/details/bloc/delete/qag_delete_state.dart';
import 'package:agora/qag/repository/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagDeleteBloc extends Bloc<DeleteQagEvent, QagDeleteState> {
  final QagRepository qagRepository;

  QagDeleteBloc({required this.qagRepository}) : super(QagDeleteInitialState()) {
    on<DeleteQagEvent>(_handleDeleteQag);
  }

  Future<void> _handleDeleteQag(
    DeleteQagEvent event,
    Emitter<QagDeleteState> emit,
  ) async {
    emit(QagDeleteLoadingState());
    final response = await qagRepository.deleteQag(qagId: event.qagId);
    if (response is DeleteQagSucceedResponse) {
      emit(QagDeleteSuccessState());
    } else {
      emit(QagDeleteErrorState());
    }
  }
}
