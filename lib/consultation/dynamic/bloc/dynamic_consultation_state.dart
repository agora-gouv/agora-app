import 'package:agora/consultation/dynamic/domain/dynamic_consultation.dart';
import 'package:equatable/equatable.dart';

sealed class DynamicConsultationState extends Equatable {}

class DynamicConsultationSuccessState extends DynamicConsultationState {
  final DynamicConsultation consultation;

  DynamicConsultationSuccessState(this.consultation);

  @override
  List<Object?> get props => [consultation];
}

class DynamicConsultationErrorState extends DynamicConsultationState {
  @override
  List<Object?> get props => [];
}

class DynamicConsultationLoadingState extends DynamicConsultationState {
  @override
  List<Object?> get props => [];
}
