import 'package:equatable/equatable.dart';

abstract class DeeplinkState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeeplinkInitialState extends DeeplinkState {}

class DeeplinkLoadingState extends DeeplinkState {}

class ConsultationDeeplinkState extends DeeplinkState {
  final String consultationId;

  ConsultationDeeplinkState({required this.consultationId});

  @override
  List<Object?> get props => [consultationId];
}

class DeeplinkErrorState extends DeeplinkState {}
