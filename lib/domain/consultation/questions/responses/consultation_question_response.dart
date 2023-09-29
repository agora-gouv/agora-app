import 'package:equatable/equatable.dart';

class ConsultationQuestionResponses extends Equatable {
  final String questionId;
  final List<String> responseIds;
  final String responseText;

  ConsultationQuestionResponses({
    required this.questionId,
    required this.responseIds,
    required this.responseText,
  });

  @override
  List<Object> get props => [questionId, responseIds, responseText];
}
