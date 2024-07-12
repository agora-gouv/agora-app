import 'package:agora/qag/domain/qag_support.dart';
import 'package:equatable/equatable.dart';

abstract class QagListEvent extends Equatable {}

class FetchQagsListEvent extends QagListEvent {
  final String? thematiqueId;
  final String? thematiqueLabel;

  FetchQagsListEvent({
    required this.thematiqueId,
    required this.thematiqueLabel,
  });

  @override
  List<Object?> get props => [thematiqueId];
}

class UpdateQagListSupportEvent extends QagListEvent {
  final QagSupport qagSupport;

  UpdateQagListSupportEvent({
    required this.qagSupport,
  });

  @override
  List<Object?> get props => [qagSupport];
}

class UpdateQagsListEvent extends QagListEvent {
  final String? thematiqueId;

  UpdateQagsListEvent({
    required this.thematiqueId,
  });

  @override
  List<Object?> get props => [thematiqueId];
}

class CloseHeaderQagListEvent extends QagListEvent {
  final String headerId;

  CloseHeaderQagListEvent({
    required this.headerId,
  });

  @override
  List<Object?> get props => [headerId];
}
