import 'package:equatable/equatable.dart';

class ConsultationQuestionResponse extends Equatable {
  final String questionId;
  final List<String> responseIds;
  final String responseText;

  ConsultationQuestionResponse({
    required this.questionId,
    required this.responseIds,
    required this.responseText,
  });

  @override
  List<Object> get props => [questionId, responseIds, responseText];
}
