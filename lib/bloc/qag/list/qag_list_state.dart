import 'package:agora/domain/qag/qag.dart';
import 'package:equatable/equatable.dart';

abstract class QagListState extends Equatable {
  @override
  List<Object?> get props => [];
}


class QagListInitialState extends QagListState {}

class QagListLoadedState extends QagListState {
  final List<Qag> qags;


  QagListLoadedState({
    required this.qags,
  });
}

class QagListErrorState extends QagListState {}
