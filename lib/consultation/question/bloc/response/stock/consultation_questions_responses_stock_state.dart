import 'package:agora/consultation/question/domain/consultation_question_response.dart';
import 'package:equatable/equatable.dart';

class ConsultationQuestionsResponsesStockState extends Equatable {
  final List<String> questionIdStack;
  final List<ConsultationQuestionResponses> questionsResponses;
  final String? currentQuestionId;
  final bool shouldPop;

  ConsultationQuestionsResponsesStockState({
    required this.questionIdStack,
    required this.questionsResponses,
    required this.currentQuestionId,
    this.shouldPop = false,
  });

  @override
  List<Object?> get props => [
        questionIdStack,
        questionsResponses,
        currentQuestionId,
        shouldPop,
      ];
}
