import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/domain/qag/qags_error_type.dart';
import 'package:equatable/equatable.dart';

abstract class QagState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QagInitialLoadingState extends QagState {}

abstract class QagWithItem extends QagState {
  final List<QagResponseTypeViewModel> qagResponseViewModels;
  final List<QagViewModel> popularViewModels;
  final List<QagViewModel> latestViewModels;
  final List<QagViewModel> supportingViewModels;
  final String? errorCase;

  QagWithItem({
    required this.qagResponseViewModels,
    required this.popularViewModels,
    required this.latestViewModels,
    required this.supportingViewModels,
    required this.errorCase,
  });

  @override
  List<Object?> get props => [
        qagResponseViewModels,
        popularViewModels,
        latestViewModels,
        supportingViewModels,
        errorCase,
      ];
}

class QagLoadingState extends QagWithItem {
  QagLoadingState({
    required super.qagResponseViewModels,
    required super.popularViewModels,
    required super.latestViewModels,
    required super.supportingViewModels,
    required super.errorCase,
  });
}

class QagFetchedState extends QagWithItem {
  QagFetchedState({
    required super.qagResponseViewModels,
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
