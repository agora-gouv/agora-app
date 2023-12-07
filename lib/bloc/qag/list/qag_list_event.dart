import 'package:agora/domain/qag/qag_support.dart';
import 'package:equatable/equatable.dart';

abstract class QagListEvent extends Equatable {}

class FetchQagsListEvent extends QagListEvent {
  final String? thematiqueId;

  FetchQagsListEvent({required this.thematiqueId});

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
