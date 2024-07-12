import 'package:agora/consultation/bloc/finished_paginated/consultation_finished_paginated_view_model.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationPaginatedState extends Equatable {
  final List<ConsultationPaginatedViewModel> consultationPaginatedViewModels;
  final int currentPageNumber;
  final int maxPage;

  ConsultationPaginatedState({
    required this.consultationPaginatedViewModels,
    required this.currentPageNumber,
    required this.maxPage,
  });

  @override
  List<Object> get props => [consultationPaginatedViewModels, currentPageNumber, maxPage];
}

class ConsultationFinishedPaginatedInitialState extends ConsultationPaginatedState {
  ConsultationFinishedPaginatedInitialState()
      : super(consultationPaginatedViewModels: [], currentPageNumber: -1, maxPage: -1);
}

class ConsultationFinishedPaginatedLoadingState extends ConsultationPaginatedState {
  ConsultationFinishedPaginatedLoadingState({
    required super.consultationPaginatedViewModels,
    required super.currentPageNumber,
    required super.maxPage,
  });
}

class ConsultationPaginatedFetchedState extends ConsultationPaginatedState {
  ConsultationPaginatedFetchedState({
    required super.consultationPaginatedViewModels,
    required super.currentPageNumber,
    required super.maxPage,
  });
}

class ConsultationPaginatedErrorState extends ConsultationPaginatedState {
  ConsultationPaginatedErrorState({
    required super.consultationPaginatedViewModels,
    required super.currentPageNumber,
    required super.maxPage,
  });
}
