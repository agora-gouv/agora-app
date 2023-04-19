import 'package:equatable/equatable.dart';

abstract class QagSupportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QagSupportInitialState extends QagSupportState {}

class QagSupportLoadingState extends QagSupportState {}

class QagSupportSuccessState extends QagSupportState {}

class QagSupportErrorState extends QagSupportState {}

class QagDeleteSupportLoadingState extends QagSupportState {}

class QagDeleteSupportSuccessState extends QagSupportState {}

class QagDeleteSupportErrorState extends QagSupportState {}
