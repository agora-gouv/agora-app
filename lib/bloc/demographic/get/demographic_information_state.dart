import 'package:agora/bloc/demographic/get/demographic_information_view_model.dart';
import 'package:equatable/equatable.dart';

abstract class DemographicInformationState extends Equatable {
  @override
  List<Object> get props => [];
}

class GetDemographicInformationInitialLoadingState extends DemographicInformationState {}

class GetDemographicInformationSuccessState extends DemographicInformationState {
  final List<DemographicInformationViewModel> demographicInformationViewModels;

  GetDemographicInformationSuccessState({required this.demographicInformationViewModels});

  @override
  List<Object> get props => [demographicInformationViewModels];
}

class GetDemographicInformationFailureState extends DemographicInformationState {}
