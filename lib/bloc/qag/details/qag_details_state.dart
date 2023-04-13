import 'package:agora/bloc/qag/details/qag_details_view_model.dart';
import 'package:equatable/equatable.dart';

abstract class QagDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QagDetailsInitialLoadingState extends QagDetailsState {}

class QagDetailsFetchedState extends QagDetailsState {
  final QagDetailsViewModel viewModel;

  QagDetailsFetchedState(this.viewModel);

  @override
  List<Object> get props => [viewModel];
}

class QagDetailsErrorState extends QagDetailsState {}
