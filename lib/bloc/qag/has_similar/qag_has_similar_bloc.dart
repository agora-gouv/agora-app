import 'package:agora/bloc/qag/has_similar/qag_has_similar_event.dart';
import 'package:agora/bloc/qag/has_similar/qag_has_similar_state.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagHasSimilarBloc extends Bloc<QagHasSimilarEvent, QagHasSimilarState> {
  final QagRepository qagRepository;

  QagHasSimilarBloc({required this.qagRepository}) : super(QagHasSimilarInitialState()) {
    on<QagHasSimilarEvent>(_handleQagHasSimilar);
  }

  Future<void> _handleQagHasSimilar(
    QagHasSimilarEvent event,
    Emitter<QagHasSimilarState> emit,
  ) async {
    emit(QagHasSimilarLoadingState());
    final response = await qagRepository.hasSimilarQag(title: event.title);
    if (response is QagHasSimilarSuccessResponse) {
      emit(QagHasSimilarSuccessState(hasSimilar: response.hasSimilar));
    } else {
      emit(QagHasSimilarErrorState());
    }
  }
}
