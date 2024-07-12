import 'package:equatable/equatable.dart';

abstract class ParticipationCharterState extends Equatable {
  @override
  List<Object> get props => [];
}

class GetParticipationCharterLoadingState extends ParticipationCharterState {}

class GetParticipationCharterLoadedState extends ParticipationCharterState {
  final String extraText;

  GetParticipationCharterLoadedState({required this.extraText});
}

class GetParticipationCharterFailureState extends ParticipationCharterState {}
