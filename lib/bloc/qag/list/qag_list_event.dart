import 'package:equatable/equatable.dart';

abstract class QagListEvent extends Equatable {}

class FetchQagsListEvent extends QagListEvent {
  @override
  List<Object?> get props => [];
}

class UpdateQagsListEvent extends QagListEvent {
  @override
  List<Object?> get props => [];
}
