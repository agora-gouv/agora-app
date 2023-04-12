import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationQuestionsResponsesStockEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddConsultationQuestionsResponseStockEvent extends ConsultationQuestionsResponsesStockEvent {
  final ConsultationQuestionResponses questionResponse;

  AddConsultationQuestionsResponseStockEvent({required this.questionResponse});

  @override
  List<Object> get props => [questionResponse];
}
