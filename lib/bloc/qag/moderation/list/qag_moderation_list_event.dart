import 'package:equatable/equatable.dart';

abstract class QagModerationListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchQagModerationListEvent extends QagModerationListEvent {}

class RemoveFromQagModerationListEvent extends QagModerationListEvent {
  final String qagId;

  RemoveFromQagModerationListEvent({required this.qagId});

  @override
  List<Object> get props => [qagId];
}
