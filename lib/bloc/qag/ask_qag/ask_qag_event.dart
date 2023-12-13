import 'package:equatable/equatable.dart';

abstract class AskQagEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAskQagStatusEvent extends AskQagEvent {
  FetchAskQagStatusEvent();

  @override
  List<Object?> get props => [];
}
