import 'package:agora/bloc/qag/list/qag_list_event.dart';
import 'package:agora/bloc/qag/list/qag_list_state.dart';
import 'package:agora/bloc/qag/qag_list_footer_type.dart';
import 'package:agora/domain/qag/qag.dart';
import 'package:agora/domain/qag/qag_list_extension.dart';
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
    on<UpdateQagListSupportEvent>(_handleUpdateQagSupport);
  }

  Future<void> _handleFetchQags(
    FetchQagsListEvent event,
    Emitter<QagListState> emit,
  ) async {
    emit(QagListInitialState());

    final response = await qagRepository.fetchQagList(
      pageNumber: state.currentPage,
      thematiqueId: event.thematiqueId,
      filter: qagFilter,
    );

    if (response is GetQagListSucceedResponse) {
      emit(
        QagListLoadedState(
          qags: response.qags,
          maxPage: response.maxPage,
          currentPage: state.currentPage,
          footerType: QagListFooterType.loaded,
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
          footerType: QagListFooterType.loading,
        ),
      );

      final response = await qagRepository.fetchQagList(
        pageNumber: state.currentPage + 1,
        thematiqueId: event.thematiqueId,
        filter: qagFilter,
      );

      if (response is GetQagListSucceedResponse) {
        final List<Qag> newList = addQagsToList(loadedState.qags, response.qags);
        emit(
          QagListLoadedState(
            qags: newList,
            maxPage: response.maxPage,
            currentPage: state.currentPage + 1,
            footerType: QagListFooterType.loaded,
          ),
        );
      } else {
        emit(
          QagListLoadedState(
            qags: loadedState.qags,
            maxPage: loadedState.maxPage,
            currentPage: state.currentPage,
            footerType: QagListFooterType.error,
          ),
        );
      }
    }
  }

  Future<void> _handleUpdateQagSupport(
    UpdateQagListSupportEvent event,
    Emitter<QagListState> emit,
  ) async {
    if (state is QagListLoadedState) {
      final loadedState = state as QagListLoadedState;
      final newQagList = loadedState.qags.updateQagSupportOrNull(event.qagSupport);

      if (newQagList != null) {
        emit(
          QagListLoadedState(
            qags: newQagList,
            currentPage: state.currentPage,
            maxPage: loadedState.maxPage,
            footerType: QagListFooterType.loaded,
          ),
        );
      }
    }
  }

  List<Qag> addQagsToList(List<Qag> oldList, List<Qag> newList) {
    final List<Qag> mergedQags = [...oldList];

    for (final qag in newList) {
      if (!mergedQags.any((oldQag) => oldQag.id == qag.id)) {
        mergedQags.add(qag);
      }
    }

    return mergedQags;
  }
}
