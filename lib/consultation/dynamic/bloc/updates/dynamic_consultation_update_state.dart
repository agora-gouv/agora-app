import 'package:agora/consultation/dynamic/domain/dynamic_consultation.dart';
import 'package:equatable/equatable.dart';

sealed class DynamicConsultationUpdatesState extends Equatable {}

class DynamicConsultationUpdatesSuccessState extends DynamicConsultationUpdatesState {
  final DynamicConsultationUpdate update;

  DynamicConsultationUpdatesSuccessState(this.update);

  @override
  List<Object?> get props => [update];
}

class DynamicConsultationUpdatesErrorState extends DynamicConsultationUpdatesState {
  @override
  List<Object?> get props => [];
}

class DynamicConsultationUpdatesLoadingState extends DynamicConsultationUpdatesState {
  @override
  List<Object?> get props => [];
}
