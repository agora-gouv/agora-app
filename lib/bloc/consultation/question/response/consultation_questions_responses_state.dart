import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:equatable/equatable.dart';

class ConsultationQuestionsResponsesState extends Equatable {
  final List<ConsultationQuestionResponse> questionsResponses;

  ConsultationQuestionsResponsesState({required this.questionsResponses});

  @override
  List<Object?> get props => [questionsResponses];
}
