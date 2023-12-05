import 'package:agora/bloc/qag/list/qag_list_event.dart';
import 'package:agora/bloc/qag/list/qag_list_state.dart';
import 'package:agora/domain/qag/qag.dart';
import 'package:agora/domain/qag/qas_list_filter.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagListBloc extends Bloc<QagListEvent, QagListState> {
  final QagRepository qagRepository;
  final QagListFilter qagFilter;

  QagListBloc({
    required this.qagRepository,
    required this.qagFilter,
  }) : super(QagListInitialState()) {
    on<FetchQagsListEvent>(_handleFetchQags);
    on<UpdateQagsListEvent>(_handleUpdateQags);
  }

  Future<void> _handleFetchQags(
    FetchQagsListEvent event,
    Emitter<QagListState> emit,
  ) async {
    emit(QagListInitialState());

    final response = await qagRepository.fetchQagList(
      pageNumber: state.currentPage,
      thematiqueId: null,
      filter: qagFilter,
    );

    if (response is GetQagListSucceedResponse) {
      emit(
        QagListLoadedState(
          qags: response.qags,
          maxPage: response.maxPage,
          currentPage: state.currentPage,
          isLoadingMore: false,
        ),
      );
    } else {
      emit(QagListErrorState(currentPage: state.currentPage));
    }
  }

  Future<void> _handleUpdateQags(
    UpdateQagsListEvent event,
    Emitter<QagListState> emit,
  ) async {
    if (state is QagListLoadedState) {
      final loadedState = state as QagListLoadedState;

      emit(
        QagListLoadedState(
          currentPage: state.currentPage,
          qags: loadedState.qags,
          maxPage: loadedState.maxPage,
          isLoadingMore: true,
        ),
      );

      final response = await qagRepository.fetchQagList(
        pageNumber: state.currentPage + 1,
        thematiqueId: null,
        filter: qagFilter,
      );

      if (response is GetQagListSucceedResponse) {
        final List<Qag> newList = addQagsToList(loadedState.qags, response.qags);
        emit(
          QagListLoadedState(
            qags: newList,
            maxPage: response.maxPage,
            currentPage: state.currentPage + 1,
            isLoadingMore: false,
          ),
        );
      } else {
        emit(QagListErrorState(currentPage: state.currentPage));
      }
    }
  }

  List<Qag> addQagsToList(List<Qag> newList, List<Qag> oldList) {
    final List<String> existingIds = [];

    for (Qag qag in newList) {
      existingIds.add(qag.id);
    }

    for (Qag qag in oldList) {
      if (!existingIds.contains(qag.id)) {
        newList.add(qag);
        existingIds.add(qag.id);
      }
    }

    return newList;
  }
}
