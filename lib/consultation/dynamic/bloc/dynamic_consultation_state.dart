import 'package:agora/consultation/dynamic/domain/dynamic_consultation.dart';
import 'package:agora/referentiel/territoire.dart';
import 'package:equatable/equatable.dart';

sealed class DynamicConsultationState extends Equatable {}

class DynamicConsultationSuccessState extends DynamicConsultationState {
  final DynamicConsultation consultation;
  final List<Territoire> referentiel;

  DynamicConsultationSuccessState(this.consultation, this.referentiel);

  @override
  List<Object?> get props => [consultation, referentiel];
}

class DynamicConsultationErrorState extends DynamicConsultationState {
  @override
  List<Object?> get props => [];
}

class DynamicConsultationLoadingState extends DynamicConsultationState {
  @override
  List<Object?> get props => [];
}
