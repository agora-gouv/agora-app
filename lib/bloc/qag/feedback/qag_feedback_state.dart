import 'package:equatable/equatable.dart';

abstract class QagFeedbackState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QagFeedbackInitialState extends QagFeedbackState {}

class QagFeedbackLoadingState extends QagFeedbackState {}

class QagFeedbackSuccessState extends QagFeedbackState {}

class QagFeedbackErrorState extends QagFeedbackState {}
