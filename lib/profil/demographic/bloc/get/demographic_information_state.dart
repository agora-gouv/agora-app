import 'package:agora/profil/demographic/domain/demographic_information.dart';
import 'package:equatable/equatable.dart';

abstract class DemographicInformationState extends Equatable {
  @override
  List<Object> get props => [];
}

class GetDemographicInformationInitialLoadingState extends DemographicInformationState {}

class GetDemographicInformationSuccessState extends DemographicInformationState {
  final List<DemographicInformation> demographicInformationResponse;

  GetDemographicInformationSuccessState({required this.demographicInformationResponse});

  @override
  List<Object> get props => [demographicInformationResponse];
}

class GetDemographicInformationFailureState extends DemographicInformationState {}
