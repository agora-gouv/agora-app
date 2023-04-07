import 'package:equatable/equatable.dart';

abstract class ConsultationQuestionsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchConsultationQuestionsEvent extends ConsultationQuestionsEvent {
  final String consultationId;

  FetchConsultationQuestionsEvent({required this.consultationId});

  @override
  List<Object> get props => [consultationId];
}

class ConsultationPreviousQuestionEvent extends ConsultationQuestionsEvent {}

class ConsultationNextQuestionEvent extends ConsultationQuestionsEvent {}
