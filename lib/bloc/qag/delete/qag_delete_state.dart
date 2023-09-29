import 'package:equatable/equatable.dart';

abstract class QagDeleteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QagDeleteInitialState extends QagDeleteState {}

class QagDeleteLoadingState extends QagDeleteState {}

class QagDeleteSuccessState extends QagDeleteState {}

class QagDeleteErrorState extends QagDeleteState {}
