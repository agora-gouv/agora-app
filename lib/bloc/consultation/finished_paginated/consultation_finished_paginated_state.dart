import 'package:agora/bloc/consultation/finished_paginated/consultation_finished_paginated_view_model.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationFinishedPaginatedState extends Equatable {
  final List<ConsultationFinishedPaginatedViewModel> consultationFinishedViewModels;
  final int currentPageNumber;
  final int maxPage;

  ConsultationFinishedPaginatedState({
    required this.consultationFinishedViewModels,
    required this.currentPageNumber,
    required this.maxPage,
  });

  @override
  List<Object> get props => [consultationFinishedViewModels, currentPageNumber, maxPage];
}

class ConsultationFinishedPaginatedInitialState extends ConsultationFinishedPaginatedState {
  ConsultationFinishedPaginatedInitialState()
      : super(consultationFinishedViewModels: [], currentPageNumber: -1, maxPage: -1);
}

class ConsultationFinishedPaginatedLoadingState extends ConsultationFinishedPaginatedState {
  ConsultationFinishedPaginatedLoadingState({
    required super.consultationFinishedViewModels,
    required super.currentPageNumber,
    required super.maxPage,
  });
}

class ConsultationFinishedPaginatedFetchedState extends ConsultationFinishedPaginatedState {
  ConsultationFinishedPaginatedFetchedState({
    required super.consultationFinishedViewModels,
    required super.currentPageNumber,
    required super.maxPage,
  });
}

class ConsultationFinishedPaginatedErrorState extends ConsultationFinishedPaginatedState {
  ConsultationFinishedPaginatedErrorState({
    required super.consultationFinishedViewModels,
    required super.currentPageNumber,
    required super.maxPage,
  });
}
