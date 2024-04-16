import 'package:equatable/equatable.dart';

abstract class QagDetailsEvent extends Equatable {}

class FetchQagDetailsEvent extends QagDetailsEvent {
  final String qagId;

  FetchQagDetailsEvent({required this.qagId});

  @override
  List<Object> get props => [qagId];
}

class SendFeedbackQagDetailsEvent extends QagDetailsEvent {
  final String qagId;
  final bool isHelpful;

  SendFeedbackQagDetailsEvent({required this.qagId, required this.isHelpful});

  @override
  List<Object> get props => [qagId, isHelpful];
}

class EditFeedbackQagDetailsEvent extends QagDetailsEvent {
  final bool previousUserResponse;

  EditFeedbackQagDetailsEvent({required this.previousUserResponse});

  @override
  List<Object?> get props => [previousUserResponse];
}