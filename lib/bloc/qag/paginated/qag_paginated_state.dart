import 'package:agora/bloc/qag/paginated/qag_paginated_view_model.dart';
import 'package:equatable/equatable.dart';

abstract class QagPaginatedState extends Equatable {
  final List<QagPaginatedViewModel> qagViewModels;
  final int currentPageNumber;
  final int maxPage;

  QagPaginatedState({
    required this.qagViewModels,
    required this.currentPageNumber,
    required this.maxPage,
  });

  @override
  List<Object> get props => [qagViewModels, currentPageNumber, maxPage];
}

class QagPaginatedInitialState extends QagPaginatedState {
  QagPaginatedInitialState() : super(qagViewModels: [], currentPageNumber: -1, maxPage: -1);
}

class QagPaginatedLoadingState extends QagPaginatedState {
  QagPaginatedLoadingState({
    required super.qagViewModels,
    required super.currentPageNumber,
    required super.maxPage,
  });
}

class QagPaginatedFetchedState extends QagPaginatedState {
  QagPaginatedFetchedState({
    required super.qagViewModels,
    required super.currentPageNumber,
    required super.maxPage,
  });
}

class QagPaginatedErrorState extends QagPaginatedState {
  QagPaginatedErrorState({
    required super.qagViewModels,
    required super.currentPageNumber,
    required super.maxPage,
  });
}
