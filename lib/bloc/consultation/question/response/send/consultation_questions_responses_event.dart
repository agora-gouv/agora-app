import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:equatable/equatable.dart';

class SendConsultationQuestionsResponsesEvent extends Equatable {
  final String consultationId;
  final List<String> questionIdStack;
  final List<ConsultationQuestionResponses> questionsResponses;

  SendConsultationQuestionsResponsesEvent({
    required this.consultationId,
    required this.questionIdStack,
    required this.questionsResponses,
  });

  @override
  List<Object> get props => [consultationId, questionIdStack, questionsResponses];
}
