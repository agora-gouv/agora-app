import 'package:equatable/equatable.dart';

abstract class CreateQagState extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateQagInitialState extends CreateQagState {}

class CreateQagLoadingState extends CreateQagState {}

class CreateQagSuccessState extends CreateQagState {}

class CreateQagErrorState extends CreateQagState {}
