import 'package:equatable/equatable.dart';

abstract class SendConsultationQuestionsResponsesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendConsultationQuestionsResponsesInitialState extends SendConsultationQuestionsResponsesState {}

class SendConsultationQuestionsResponsesLoadingState extends SendConsultationQuestionsResponsesState {}

class SendConsultationQuestionsResponsesSuccessState extends SendConsultationQuestionsResponsesState {}

class SendConsultationQuestionsResponsesFailureState extends SendConsultationQuestionsResponsesState {}
