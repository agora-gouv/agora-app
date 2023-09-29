import 'package:equatable/equatable.dart';

abstract class SendDemographicResponsesState extends Equatable {
  @override
  List<Object> get props => [];
}

class SendDemographicResponsesInitialLoadingState extends SendDemographicResponsesState {}

class SendDemographicResponsesSuccessState extends SendDemographicResponsesState {}

class SendDemographicResponsesFailureState extends SendDemographicResponsesState {}
