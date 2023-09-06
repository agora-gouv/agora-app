import 'package:agora/bloc/qag/qag_event.dart';
import 'package:agora/bloc/qag/qag_state.dart';
import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/infrastructure/qag/presenter/qag_presenter.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagBloc extends Bloc<QagsEvent, QagState> {
  final QagRepository qagRepository;

  QagBloc({required this.qagRepository}) : super(QagInitialLoadingState()) {
    on<FetchQagsEvent>(_handleFetchQags);
    on<UpdateQagsEvent>(_handleUpdateQags);
  }

  Future<void> _handleFetchQags(
    FetchQagsEvent event,
    Emitter<QagState> emit,
  ) async {
    if (state is QagFetchedState) {
      emit(
        QagLoadingState(
          popularViewModels: [],
          latestViewModels: [],
          supportingViewModels: [],
          errorCase: null,
        ),
      );
    }
    final response = await qagRepository.fetchQags(thematiqueId: event.thematiqueId);
    if (response is GetQagsSucceedResponse) {
      final qagPopularViewModels = QagPresenter.presentQag(response.qagPopular);
      final qagLatestViewModels = QagPresenter.presentQag(response.qagLatest);
      final qagSupportingViewModels = QagPresenter.presentQag(response.qagSupporting);
      emit(
        QagFetchedState(
          popularViewModels: qagPopularViewModels,
          latestViewModels: qagLatestViewModels,
          supportingViewModels: qagSupportingViewModels,
          errorCase: response.errorCase,
        ),
      );
    } else if (response is GetQagsFailedResponse) {
      emit(QagErrorState(errorType: response.errorType));
    }
  }

  Future<void> _handleUpdateQags(
    UpdateQagsEvent event,
    Emitter<QagState> emit,
  ) async {
    if (state is QagFetchedState) {
      final currentState = state as QagFetchedState;

      final popularViewModelsCopy = [...currentState.popularViewModels];
      final latestViewModelsCopy = [...currentState.latestViewModels];
      final supportingViewModelsCopy = [...currentState.supportingViewModels];

      final updatedPopularIndex = popularViewModelsCopy.indexWhere((popular) => popular.id == event.qagId);
      final updatedLatestIndex = latestViewModelsCopy.indexWhere((latest) => latest.id == event.qagId);
      final updatedSupportingIndex = supportingViewModelsCopy.indexWhere((supporting) => supporting.id == event.qagId);

      if (updatedPopularIndex != -1) {
        final updatedPopular = popularViewModelsCopy[updatedPopularIndex];
        popularViewModelsCopy[updatedPopularIndex] = QagViewModel(
          id: updatedPopular.id,
          thematique: updatedPopular.thematique,
          title: updatedPopular.title,
          username: updatedPopular.username,
          date: updatedPopular.date,
          supportCount: event.supportCount,
          isSupported: event.isSupported,
        );
      }
      if (updatedLatestIndex != -1) {
        final updatedLatest = latestViewModelsCopy[updatedLatestIndex];
        latestViewModelsCopy[updatedLatestIndex] = QagViewModel(
          id: updatedLatest.id,
          thematique: updatedLatest.thematique,
          title: updatedLatest.title,
          username: updatedLatest.username,
          date: updatedLatest.date,
          supportCount: event.supportCount,
          isSupported: event.isSupported,
        );
      }
      if (event.isSupported) {
        if (updatedSupportingIndex == -1) {
          supportingViewModelsCopy.insert(
            0,
            QagViewModel(
              id: event.qagId,
              thematique: event.thematique,
              title: event.title,
              username: event.username,
              date: event.date,
              supportCount: event.supportCount,
              isSupported: event.isSupported,
            ),
          );
        } else {
          supportingViewModelsCopy[updatedSupportingIndex] = QagViewModel(
            id: event.qagId,
            thematique: event.thematique,
            title: event.title,
            username: event.username,
            date: event.date,
            supportCount: event.supportCount,
            isSupported: event.isSupported,
          );
        }
      } else {
        // Not supported
        if (updatedSupportingIndex != -1) {
          supportingViewModelsCopy.removeAt(updatedSupportingIndex);
        }
      }
      if (supportingViewModelsCopy.length > 10) {
        supportingViewModelsCopy.sublist(0, 10);
      }

      emit(
        QagFetchedState(
          popularViewModels: popularViewModelsCopy,
          latestViewModels: latestViewModelsCopy,
          supportingViewModels: supportingViewModelsCopy,
          errorCase: currentState.errorCase,
        ),
      );
    }
  }
}
