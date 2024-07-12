import 'package:agora/consultation/question/domain/consultation_question_response.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationQuestionsResponsesStockEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddConsultationChapterStockEvent extends ConsultationQuestionsResponsesStockEvent {
  final String consultationId;
  final String chapterId;
  final String? nextQuestionId;

  AddConsultationChapterStockEvent({
    required this.consultationId,
    required this.chapterId,
    required this.nextQuestionId,
  });

  @override
  List<Object?> get props => [consultationId, chapterId, nextQuestionId];
}

class AddConsultationQuestionsResponseStockEvent extends ConsultationQuestionsResponsesStockEvent {
  final String consultationId;
  final ConsultationQuestionResponses questionResponse;
  final String? nextQuestionId;

  AddConsultationQuestionsResponseStockEvent({
    required this.consultationId,
    required this.questionResponse,
    required this.nextQuestionId,
  });

  @override
  List<Object?> get props => [consultationId, questionResponse, nextQuestionId];
}

class RemoveConsultationQuestionEvent extends ConsultationQuestionsResponsesStockEvent {}

class RestoreSavingConsultationResponseEvent extends ConsultationQuestionsResponsesStockEvent {
  final String consultationId;

  RestoreSavingConsultationResponseEvent({required this.consultationId});

  @override
  List<Object> get props => [consultationId];
}

class ResetToLastQuestionEvent extends ConsultationQuestionsResponsesStockEvent {
  final String consultationId;

  ResetToLastQuestionEvent({required this.consultationId});

  @override
  List<Object> get props => [consultationId];
}
