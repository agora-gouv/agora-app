import 'package:agora/bloc/qag/similar/qag_similar_event.dart';
import 'package:agora/bloc/qag/similar/qag_similar_state.dart';
import 'package:agora/bloc/qag/similar/qag_similar_view_model.dart';
import 'package:agora/infrastructure/qag/presenter/qag_similar_presenter.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagSimilarBloc extends Bloc<QagSimilarEvent, QagSimilarState> {
  final QagRepository qagRepository;

  QagSimilarBloc({required this.qagRepository}) : super(QagSimilarInitialState()) {
    on<GetQagSimilarEvent>(_handleGetQagSimilar);
    on<UpdateSimilarQagEvent>(_handleUpdateSimilarQag);
  }

  Future<void> _handleGetQagSimilar(
    GetQagSimilarEvent event,
    Emitter<QagSimilarState> emit,
  ) async {
    emit(QagSimilarLoadingState());
    final response = await qagRepository.getSimilarQags(title: event.title);
    if (response is QagSimilarSuccessResponse) {
      final viewModels = QagSimilarPresenter.present(response.similarQags);
      emit(QagSimilarSuccessState(similarQags: viewModels));
    } else {
      emit(QagSimilarErrorState());
    }
  }

  Future<void> _handleUpdateSimilarQag(
    UpdateSimilarQagEvent event,
    Emitter<QagSimilarState> emit,
  ) async {
    final currentState = state;
    if (currentState is QagSimilarSuccessState) {
      final similarQagsCopy = [...currentState.similarQags];
      final updateSimilarQagIndex = similarQagsCopy.indexWhere((similarQag) => similarQag.id == event.qagId);
      if (updateSimilarQagIndex != -1) {
        final updatedSimilarQag = similarQagsCopy[updateSimilarQagIndex];
        similarQagsCopy[updateSimilarQagIndex] = QagSimilarViewModel(
          id: updatedSimilarQag.id,
          thematique: updatedSimilarQag.thematique,
          title: updatedSimilarQag.title,
          description: updatedSimilarQag.description,
          username: updatedSimilarQag.username,
          date: updatedSimilarQag.date,
          supportCount: event.supportCount,
          isSupported: event.isSupported,
        );
      }
      emit(QagSimilarSuccessState(similarQags: similarQagsCopy));
    }
  }
}
