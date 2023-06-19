import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationQuestionsResponsesStockEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddConsultationChapterStockEvent extends ConsultationQuestionsResponsesStockEvent {
  final String chapterId;

  AddConsultationChapterStockEvent({required this.chapterId});

  @override
  List<Object> get props => [chapterId];
}

class AddConsultationQuestionsResponseStockEvent extends ConsultationQuestionsResponsesStockEvent {
  final ConsultationQuestionResponses questionResponse;

  AddConsultationQuestionsResponseStockEvent({required this.questionResponse});

  @override
  List<Object> get props => [questionResponse];
}

class RemoveConsultationQuestionEvent extends ConsultationQuestionsResponsesStockEvent {}
