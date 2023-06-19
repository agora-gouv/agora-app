import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:equatable/equatable.dart';

class ConsultationQuestionsResponsesStockState extends Equatable {
  final List<String> questionsStack;
  final List<ConsultationQuestionResponses> questionsResponses;

  ConsultationQuestionsResponsesStockState({required this.questionsStack, required this.questionsResponses});

  @override
  List<Object> get props => [questionsStack, questionsResponses];
}
