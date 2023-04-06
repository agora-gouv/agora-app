import 'package:equatable/equatable.dart';

class ConsultationQuestionResponse extends Equatable {
  final String questionId;
  final String responseId;

  ConsultationQuestionResponse({required this.questionId, required this.responseId});

  @override
  List<Object> get props => [questionId, responseId];
}
