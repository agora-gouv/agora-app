import 'package:agora/reponse/bloc/paginated/qag_response_paginated_view_model.dart';
import 'package:equatable/equatable.dart';

sealed class QagResponsePaginatedState extends Equatable {
  final List<QagResponsePaginatedViewModel> qagResponseViewModels;
  final int currentPageNumber;
  final int maxPage;

  QagResponsePaginatedState({
    required this.qagResponseViewModels,
    required this.currentPageNumber,
    required this.maxPage,
  });

  @override
  List<Object> get props => [qagResponseViewModels, currentPageNumber, maxPage];
}

class QagResponsePaginatedInitialState extends QagResponsePaginatedState {
  QagResponsePaginatedInitialState() : super(qagResponseViewModels: [], currentPageNumber: -1, maxPage: -1);
}

class QagResponsePaginatedLoadingState extends QagResponsePaginatedState {
  QagResponsePaginatedLoadingState({
    required super.qagResponseViewModels,
    required super.currentPageNumber,
    required super.maxPage,
  });
}

class QagResponsePaginatedFetchedState extends QagResponsePaginatedState {
  QagResponsePaginatedFetchedState({
    required super.qagResponseViewModels,
    required super.currentPageNumber,
    required super.maxPage,
  });
}

class QagResponsePaginatedErrorState extends QagResponsePaginatedState {
  QagResponsePaginatedErrorState({
    required super.qagResponseViewModels,
    required super.currentPageNumber,
    required super.maxPage,
  });
}
