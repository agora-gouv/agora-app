import 'package:agora/domain/demographic/demographic_question_type.dart';
import 'package:agora/domain/demographic/demographic_response.dart';
import 'package:equatable/equatable.dart';

abstract class DemographicResponseStockEvent extends Equatable {}

class AddDemographicResponseStockEvent extends DemographicResponseStockEvent {
  final DemographicResponse response;

  AddDemographicResponseStockEvent({required this.response});

  @override
  List<Object> get props => [response];
}

class DeleteDemographicResponseStockEvent extends DemographicResponseStockEvent {
  final DemographicType demographicType;

  DeleteDemographicResponseStockEvent({required this.demographicType});

  @override
  List<Object> get props => [demographicType];
}
