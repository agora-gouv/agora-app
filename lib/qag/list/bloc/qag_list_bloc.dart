import 'package:agora/common/helper/semantics_helper.dart';
import 'package:agora/qag/domain/header_qag.dart';
import 'package:agora/qag/domain/qag.dart';
import 'package:agora/qag/domain/qag_list_extension.dart';
import 'package:agora/qag/list/bloc/qag_list_event.dart';
import 'package:agora/qag/list/bloc/qag_list_state.dart';
import 'package:agora/qag/repository/header_qag_repository.dart';
import 'package:agora/qag/repository/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagListBloc extends Bloc<QagListEvent, QagListState> {
  final QagRepository qagRepository;
  final HeaderQagStorageClient headerQagStorageClient;
  final SemanticsHelperWrapper semanticsHelperWrapper;

  QagListBloc({
    required this.qagRepository,
    required this.headerQagStorageClient,
    this.semanticsHelperWrapper = const SemanticsHelperWrapper(),
  }) : super(QagListLoadingState()) {
    on<FetchQagsListEvent>(_handleFetchQags);
    on<UpdateQagsListEvent>(_handleUpdateQags);
    on<UpdateQagListSupportEvent>(_handleUpdateQagSupport);
    on<CloseHeaderQagListEvent>(_handleCloseHeaderQag);
  }

  Future<void> _handleFetchQags(
    FetchQagsListEvent event,
    Emitter<QagListState> emit,
  ) async {
    emit(QagListLoadingState());

    final response = await qagRepository.fetchQagList(
      pageNumber: state.currentPage,
      thematiqueId: event.thematiqueId,
      filter: event.qagFilter,
    );

    if (response is GetQagListSucceedResponse) {
      emit(
        QagListSuccessState(
          qags: response.qags,
          header: await _getHeaderOrNullIfClosed(response.header),
          currentPage: state.currentPage,
          maxPage: response.maxPage,
          footerType: QagListFooterType.loaded,
        ),
      );
      if (event.thematiqueLabel != null) {
        semanticsHelperWrapper.announceThematicChosen(event.thematiqueLabel, response.qags.length);
      }
    } else {
      emit(QagListErrorState(currentPage: state.currentPage));
    }
  }

  Future<void> _handleUpdateQags(
    UpdateQagsListEvent event,
    Emitter<QagListState> emit,
  ) async {
    if (state is QagListSuccessState) {
      final loadedState = state as QagListSuccessState;

      emit(QagListSuccessState.copyWith(state: loadedState, footerType: QagListFooterType.loading));

      final response = await qagRepository.fetchQagList(
        pageNumber: state.currentPage + 1,
        thematiqueId: event.thematiqueId,
        filter: event.qagFilter,
      );

      if (response is GetQagListSucceedResponse) {
        emit(
          QagListSuccessState.copyWith(
            state: loadedState,
            qags: addQagsToList(loadedState.qags, response.qags),
            currentPage: state.currentPage + 1,
            maxPage: response.maxPage,
            footerType: QagListFooterType.loaded,
          ),
        );
      } else {
        emit(QagListSuccessState.copyWith(state: loadedState, footerType: QagListFooterType.error));
      }
    }
  }

  Future<void> _handleUpdateQagSupport(
    UpdateQagListSupportEvent event,
    Emitter<QagListState> emit,
  ) async {
    if (state is QagListSuccessState) {
      final loadedState = state as QagListSuccessState;
      final newQagList = loadedState.qags.updateQagSupportOrNull(event.qagSupport);

      if (newQagList != null) {
        emit(QagListSuccessState.copyWith(state: loadedState, qags: newQagList));
      }
    }
  }

  Future<void> _handleCloseHeaderQag(
    CloseHeaderQagListEvent event,
    Emitter<QagListState> emit,
  ) async {
    if (state is QagListSuccessState) {
      final loadedState = state as QagListSuccessState;
      headerQagStorageClient.closeHeader(headerId: event.headerId);
      emit(QagListSuccessState.copyWith(state: loadedState, header: null));
    }
  }

  Future<HeaderQag?> _getHeaderOrNullIfClosed(HeaderQag? header) async {
    if (header != null && !(await headerQagStorageClient.isHeaderClosed(headerId: header.id))) {
      return header;
    }
    return null;
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

enum QagListFooterType {
  loading,
  loaded,
  error,
}
