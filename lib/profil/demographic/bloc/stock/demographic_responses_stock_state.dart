import 'package:agora/profil/demographic/domain/demographic_response.dart';
import 'package:equatable/equatable.dart';

class DemographicResponsesStockState extends Equatable {
  final List<DemographicResponse> responses;

  DemographicResponsesStockState({required this.responses});

  @override
  List<Object> get props => [responses];
}
