import 'package:equatable/equatable.dart';

abstract class SendConsultationQuestionsResponsesState extends Equatable {
  @override
  List<Object> get props => [];
}

class SendConsultationQuestionsResponsesInitialLoadingState extends SendConsultationQuestionsResponsesState {}

class SendConsultationQuestionsResponsesSuccessState extends SendConsultationQuestionsResponsesState {
  final bool shouldDisplayDemographicInformation;

  SendConsultationQuestionsResponsesSuccessState({required this.shouldDisplayDemographicInformation});

  @override
  List<Object> get props => [shouldDisplayDemographicInformation];
}

class SendConsultationQuestionsResponsesFailureState extends SendConsultationQuestionsResponsesState {}
