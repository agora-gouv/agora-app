import 'package:agora/domain/demographic/demographic_response.dart';
import 'package:equatable/equatable.dart';

class AddDemographicResponseStockEvent extends Equatable {
  final DemographicResponse response;

  AddDemographicResponseStockEvent({required this.response});

  @override
  List<Object> get props => [response];
}
