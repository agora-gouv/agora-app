import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationQuestionsResponsesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddConsultationQuestionsResponseEvent extends ConsultationQuestionsResponsesEvent {
  final ConsultationQuestionResponse questionResponse;

  AddConsultationQuestionsResponseEvent({required this.questionResponse});

  @override
  List<Object> get props => [questionResponse];
}

class RemoveConsultationQuestionsResponseEvent extends ConsultationQuestionsResponsesEvent {}
