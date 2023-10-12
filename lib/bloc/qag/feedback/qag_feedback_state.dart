import 'package:agora/bloc/qag/details/qag_details_view_model.dart';
import 'package:equatable/equatable.dart';

abstract class QagFeedbackState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QagFeedbackInitialState extends QagFeedbackState {}

class QagFeedbackLoadingState extends QagFeedbackState {}

class QagFeedbackSuccessState extends QagFeedbackState {
  final QagDetailsFeedbackViewModel viewModel;

  QagFeedbackSuccessState({required this.viewModel});

  @override
  List<Object?> get props => [viewModel];
}

class QagFeedbackErrorState extends QagFeedbackState {}
