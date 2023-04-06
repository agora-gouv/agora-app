import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:equatable/equatable.dart';

class ConsultationQuestionsResponsesStockState extends Equatable {
  final List<ConsultationQuestionResponse> questionsResponses;

  ConsultationQuestionsResponsesStockState({required this.questionsResponses});

  @override
  List<Object?> get props => [questionsResponses];
}
