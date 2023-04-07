import 'package:equatable/equatable.dart';

abstract class SendConsultationQuestionsResponsesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendConsultationQuestionsResponsesInitialLoadingState extends SendConsultationQuestionsResponsesState {}

class SendConsultationQuestionsResponsesSuccessState extends SendConsultationQuestionsResponsesState {}

class SendConsultationQuestionsResponsesFailureState extends SendConsultationQuestionsResponsesState {}
