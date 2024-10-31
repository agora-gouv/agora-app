import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/common/helper/semantics_helper.dart';
import 'package:agora/qag/domain/header_qag.dart';
import 'package:agora/qag/domain/qag.dart';
import 'package:agora/qag/domain/qag_list_extension.dart';
import 'package:agora/qag/list/bloc/qag_list_event.dart';
import 'package:agora/qag/list/bloc/qag_list_state.dart';
import 'package:agora/qag/repository/header_qag_repository.dart';
import 'package:agora/qag/repository/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optional/optional.dart';

class QagListBloc extends Bloc<QagListEvent, QagListState> {
  final QagListState previousState;
  final QagRepository qagRepository;
  final HeaderQagStorageClient headerQagStorageClient;
  final SemanticsHelperWrapper semanticsHelperWrapper;

  QagListBloc({
    required this.previousState,
    required this.qagRepository,
    required this.headerQagStorageClient,
    this.semanticsHelperWrapper = const SemanticsHelperWrapper(),
  }) : super(previousState) {
    on<FetchQagsListEvent>(_handleFetchQags);
    on<UpdateQagsListEvent>(_handleUpdateQags);
    on<UpdateQagListSupportEvent>(_handleUpdateQagSupport);
    on<CloseHeaderQagListEvent>(_handleCloseHeaderQag);
  }

  factory QagListBloc.fromRepositories({
    required QagRepository qagRepository,
    required HeaderQagStorageClient headerQagStorageClient,
    SemanticsHelperWrapper semanticsHelperWrapper = const SemanticsHelperWrapper(),
  }) {
    if (qagRepository.qagsListData is GetQagListSucceedResponse) {
      final qagsListData = qagRepository.qagsListData as GetQagListSucceedResponse;
      return QagListBloc(
        previousState: QagListState(
          status: AllPurposeStatus.success,
          qags: qagsListData.qags,
          header: null,
          currentPage: 1,
          maxPage: qagsListData.maxPage,
          footerType: QagListFooterType.loaded,
        ),
        qagRepository: qagRepository,
        headerQagStorageClient: headerQagStorageClient,
        semanticsHelperWrapper: semanticsHelperWrapper,
      );
    }
    return QagListBloc(
      previousState: QagListState.init(),
      qagRepository: qagRepository,
      headerQagStorageClient: headerQagStorageClient,
      semanticsHelperWrapper: semanticsHelperWrapper,
    );
  }

  Future<void> _handleFetchQags(
    FetchQagsListEvent event,
    Emitter<QagListState> emit,
  ) async {
    if (state.status != AllPurposeStatus.success) {
      emit(state.clone(status: AllPurposeStatus.loading));

      final response = await qagRepository.fetchQagList(
        pageNumber: state.currentPage,
        thematiqueId: event.thematiqueId,
        filter: event.qagFilter,
      );

      if (response is GetQagListSucceedResponse) {
        emit(
          QagListState(
            status: AllPurposeStatus.success,
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
        emit(state.clone(status: AllPurposeStatus.error, currentPage: state.currentPage));
      }
    }
  }

  Future<void> _handleUpdateQags(
    UpdateQagsListEvent event,
    Emitter<QagListState> emit,
  ) async {
    if (state.status == AllPurposeStatus.success) {
      emit(state.clone(footerType: QagListFooterType.loading));

      final response = await qagRepository.fetchQagList(
        pageNumber: state.currentPage + 1,
        thematiqueId: event.thematiqueId,
        filter: event.qagFilter,
      );

      if (response is GetQagListSucceedResponse) {
        emit(
          state.clone(
            status: AllPurposeStatus.success,
            qags: addQagsToList(state.qags, response.qags),
            currentPage: state.currentPage + 1,
            maxPage: response.maxPage,
            footerType: QagListFooterType.loaded,
          ),
        );
      } else {
        emit(state.clone(status: state.status, footerType: QagListFooterType.error));
      }
    }
  }

  Future<void> _handleUpdateQagSupport(
    UpdateQagListSupportEvent event,
    Emitter<QagListState> emit,
  ) async {
    if (state.status == AllPurposeStatus.success) {
      final newQagList = state.qags.updateQagSupportOrNull(event.qagSupport);

      if (newQagList != null) {
        emit(state.clone(status: AllPurposeStatus.success, qags: newQagList));
      }
    }
  }

  Future<void> _handleCloseHeaderQag(
    CloseHeaderQagListEvent event,
    Emitter<QagListState> emit,
  ) async {
    if (state.status == AllPurposeStatus.success) {
      headerQagStorageClient.closeHeader(headerId: event.headerId);
      emit(state.clone(status: AllPurposeStatus.success, headerOptional: Optional.ofNullable(null)));
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
