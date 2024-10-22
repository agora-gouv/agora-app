import 'package:agora/referentiel/territoire.dart';
import 'package:equatable/equatable.dart';

abstract class TerritoireInfoEvent extends Equatable {
  const TerritoireInfoEvent();

  @override
  List<Object> get props => [];
}

class GetTerritoireInfoEvent extends TerritoireInfoEvent {
  const GetTerritoireInfoEvent();
}

class SendTerritoireInfoEvent extends TerritoireInfoEvent {
  final List<Territoire> departementsSuivis;
  final List<Territoire> regionsSuivies;

  const SendTerritoireInfoEvent({required this.departementsSuivis, required this.regionsSuivies});

  @override
  List<Object> get props => [departementsSuivis, regionsSuivies];
}
