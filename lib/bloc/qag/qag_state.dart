import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:equatable/equatable.dart';

abstract class QagState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QagInitialLoadingState extends QagState {}

class QagFetchedState extends QagState {
  final List<QagResponseViewModel> viewModels;

  QagFetchedState(this.viewModels);

  @override
  List<Object> get props => [viewModels];
}

class QagErrorState extends QagState {}
