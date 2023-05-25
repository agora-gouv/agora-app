import 'package:agora/bloc/qag/moderation/list/qag_moderation_list_event.dart';
import 'package:agora/bloc/qag/moderation/list/qag_moderation_list_state.dart';
import 'package:agora/infrastructure/qag/presenter/qag_moderation_list_presenter.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagModerationListBloc extends Bloc<FetchQagModerationListEvent, QagModerationListState> {
  final QagRepository qagRepository;

  QagModerationListBloc({required this.qagRepository}) : super(QagModerationListInitialState()) {
    on<FetchQagModerationListEvent>(_handleQagModerationList);
  }

  Future<void> _handleQagModerationList(
    FetchQagModerationListEvent event,
    Emitter<QagModerationListState> emit,
  ) async {
    emit(QagModerationListLoadingState());
    final response = await qagRepository.fetchQagModerationList();
    if (response is QagModerationListSuccessResponse) {
      final viewModel = QagModerationListPresenter.present(response.qagModerationList);
      emit(QagModerationListSuccessState(viewModel));
    } else {
      emit(QagModerationListErrorState());
    }
  }
}
