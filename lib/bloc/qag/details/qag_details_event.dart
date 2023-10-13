import 'package:equatable/equatable.dart';

abstract class QagDetailsEvent extends Equatable {}

class FetchQagDetailsEvent extends QagDetailsEvent {
  final String qagId;

  FetchQagDetailsEvent({required this.qagId});

  @override
  List<Object> get props => [qagId];
}

class SendFeedbackEvent extends QagDetailsEvent {
  final String qagId;
  final bool isHelpful;

  SendFeedbackEvent({required this.qagId, required this.isHelpful});

  @override
  List<Object> get props => [qagId, isHelpful];
}