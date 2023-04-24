import 'package:equatable/equatable.dart';

class QagFeedbackEvent extends Equatable {
  final String qagId;
  final bool isHelpful;

  QagFeedbackEvent({required this.qagId, required this.isHelpful});

  @override
  List<Object> get props => [qagId, isHelpful];
}
