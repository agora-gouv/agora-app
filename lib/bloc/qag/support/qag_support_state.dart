import 'package:equatable/equatable.dart';

abstract class QagSupportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QagSupportInitialState extends QagSupportState {}

class QagSupportLoadingState extends QagSupportState {}

class QagSupportSuccessState extends QagSupportState {
  final String qagId;

  QagSupportSuccessState({required this.qagId});

  @override
  List<Object> get props => [qagId];
}

class QagSupportErrorState extends QagSupportState {
  final String qagId;

  QagSupportErrorState({required this.qagId});

  @override
  List<Object> get props => [qagId];
}

class QagDeleteSupportLoadingState extends QagSupportState {}

class QagDeleteSupportSuccessState extends QagSupportState {
  final String qagId;

  QagDeleteSupportSuccessState({required this.qagId});

  @override
  List<Object> get props => [qagId];
}

class QagDeleteSupportErrorState extends QagSupportState {
  final String qagId;

  QagDeleteSupportErrorState({required this.qagId});

  @override
  List<Object> get props => [qagId];
}
