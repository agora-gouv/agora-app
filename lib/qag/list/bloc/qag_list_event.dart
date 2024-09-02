import 'package:agora/qag/domain/qag_support.dart';
import 'package:agora/qag/domain/qas_list_filter.dart';
import 'package:equatable/equatable.dart';

abstract class QagListEvent extends Equatable {}

class FetchQagsListEvent extends QagListEvent {
  final String? thematiqueId;
  final String? thematiqueLabel;
  final QagListFilter qagFilter;

  FetchQagsListEvent({
    required this.thematiqueId,
    required this.thematiqueLabel,
    required this.qagFilter,
  });

  @override
  List<Object?> get props => [thematiqueId, thematiqueLabel, qagFilter];
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
  final QagListFilter qagFilter;

  UpdateQagsListEvent({
    required this.thematiqueId,
    required this.qagFilter,
  });

  @override
  List<Object?> get props => [thematiqueId, qagFilter];
}

class CloseHeaderQagListEvent extends QagListEvent {
  final String headerId;

  CloseHeaderQagListEvent({
    required this.headerId,
  });

  @override
  List<Object?> get props => [headerId];
}
