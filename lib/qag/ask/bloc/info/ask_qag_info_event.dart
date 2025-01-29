import 'package:equatable/equatable.dart';

abstract class AskQagInfoEvent extends Equatable {
  const AskQagInfoEvent();
}

class FetchInfoAskQagEvent extends AskQagInfoEvent {
  const FetchInfoAskQagEvent();

  @override
  List<Object?> get props => [];
}
