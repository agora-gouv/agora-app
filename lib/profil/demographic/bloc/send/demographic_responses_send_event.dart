import 'package:agora/profil/demographic/domain/demographic_response.dart';
import 'package:equatable/equatable.dart';

class SendDemographicResponsesEvent extends Equatable {
  final List<DemographicResponse> demographicResponses;

  SendDemographicResponsesEvent({required this.demographicResponses});

  @override
  List<Object> get props => [demographicResponses];
}
