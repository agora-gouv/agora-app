import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/domain/qag/qags_error_type.dart';
import 'package:equatable/equatable.dart';

abstract class QagState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QagInitialLoadingState extends QagState {}

abstract class QagWithItemState extends QagState {
  final List<QagViewModel> popularViewModels;
  final List<QagViewModel> latestViewModels;
  final List<QagViewModel> supportingViewModels;
  final String? errorCase;

  QagWithItemState({
    required this.popularViewModels,
    required this.latestViewModels,
    required this.supportingViewModels,
    required this.errorCase,
  });

  @override
  List<Object?> get props => [
        popularViewModels,
        latestViewModels,
        supportingViewModels,
        errorCase,
      ];
}

class QagLoadingState extends QagWithItemState {
  QagLoadingState({
    required super.popularViewModels,
    required super.latestViewModels,
    required super.supportingViewModels,
    required super.errorCase,
  });
}

class QagFetchedState extends QagWithItemState {
  QagFetchedState({
    required super.popularViewModels,
    required super.latestViewModels,
    required super.supportingViewModels,
    required super.errorCase,
  });
}

class QagErrorState extends QagState {
  final QagsErrorType errorType;

  QagErrorState({required this.errorType});

  @override
  List<Object> get props => [errorType];
}
