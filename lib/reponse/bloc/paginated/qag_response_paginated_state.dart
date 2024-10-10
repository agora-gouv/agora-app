import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/reponse/bloc/paginated/qag_response_paginated_view_model.dart';
import 'package:equatable/equatable.dart';

class QagResponsePaginatedState extends Equatable {
  final AllPurposeStatus status;
  final List<QagResponsePaginatedViewModel> qagResponseViewModels;
  final int currentPageNumber;
  final int maxPage;

  QagResponsePaginatedState({
    required this.status,
    required this.qagResponseViewModels,
    required this.currentPageNumber,
    required this.maxPage,
  });

  QagResponsePaginatedState.init()
      : status = AllPurposeStatus.notLoaded,
        qagResponseViewModels = [],
        currentPageNumber = -1,
        maxPage = -1;

  QagResponsePaginatedState clone({
    AllPurposeStatus? status,
    List<QagResponsePaginatedViewModel>? qagResponseViewModels,
    int? currentPageNumber,
    int? maxPage,
  }) {
    return QagResponsePaginatedState(
      status: status ?? this.status,
      qagResponseViewModels: qagResponseViewModels ?? this.qagResponseViewModels,
      currentPageNumber: currentPageNumber ?? this.currentPageNumber,
      maxPage: maxPage ?? this.maxPage,
    );
  }

  @override
  List<Object> get props => [status, qagResponseViewModels, currentPageNumber, maxPage];
}
