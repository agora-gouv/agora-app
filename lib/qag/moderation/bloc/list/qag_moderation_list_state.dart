import 'package:agora/qag/moderation/bloc/list/qag_moderation_list_view_model.dart';
import 'package:equatable/equatable.dart';

abstract class QagModerationListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QagModerationListInitialState extends QagModerationListState {}

class QagModerationListLoadingState extends QagModerationListState {}

class QagModerationListSuccessState extends QagModerationListState {
  final QagModerationListViewModel viewModel;

  QagModerationListSuccessState(this.viewModel);

  @override
  List<Object?> get props => [viewModel];
}

class QagModerationListErrorState extends QagModerationListState {}
