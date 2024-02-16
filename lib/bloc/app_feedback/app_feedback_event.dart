import 'package:agora/domain/feedback/feedback.dart';
import 'package:equatable/equatable.dart';

abstract class AppFeedbackEvent extends Equatable {}

class SendAppFeedbackEvent extends AppFeedbackEvent {
  final AppFeedback feedback;

  SendAppFeedbackEvent(this.feedback);

  @override
  List<Object?> get props => [feedback];
}

class ReinitAppFeedbackEvent extends AppFeedbackEvent {
  @override
  List<Object?> get props => [];
}

class AppFeedbackMailSentEvent extends AppFeedbackEvent {
  @override
  List<Object?> get props => [];
}
