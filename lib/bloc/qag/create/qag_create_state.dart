import 'package:equatable/equatable.dart';

abstract class CreateQagState extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateQagInitialState extends CreateQagState {}

class CreateQagLoadingState extends CreateQagState {}

class CreateQagSuccessState extends CreateQagState {
  final String qagId;

  CreateQagSuccessState({required this.qagId});

  @override
  List<Object> get props => [qagId];
}

class CreateQagErrorState extends CreateQagState {}
