import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationQuestionsResponsesStockEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddConsultationChapterStockEvent extends ConsultationQuestionsResponsesStockEvent {
  final String consultationId;
  final String chapterId;

  AddConsultationChapterStockEvent({required this.consultationId, required this.chapterId});

  @override
  List<Object> get props => [consultationId, chapterId];
}

class AddConsultationQuestionsResponseStockEvent extends ConsultationQuestionsResponsesStockEvent {
  final String consultationId;
  final ConsultationQuestionResponses questionResponse;

  AddConsultationQuestionsResponseStockEvent({required this.consultationId, required this.questionResponse});

  @override
  List<Object> get props => [consultationId, questionResponse];
}

class RemoveConsultationQuestionEvent extends ConsultationQuestionsResponsesStockEvent {}

class RestoreSavingConsultationResponseEvent extends ConsultationQuestionsResponsesStockEvent {
  final String consultationId;

  RestoreSavingConsultationResponseEvent({required this.consultationId});

  @override
  List<Object> get props => [consultationId];
}

class DeleteSavingConsultationResponseEvent extends ConsultationQuestionsResponsesStockEvent {
  final String consultationId;

  DeleteSavingConsultationResponseEvent({required this.consultationId});

  @override
  List<Object> get props => [consultationId];
}
