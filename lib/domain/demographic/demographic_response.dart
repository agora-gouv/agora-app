import 'package:agora/domain/demographic/demographic_question_type.dart';
import 'package:equatable/equatable.dart';

class DemographicResponse extends Equatable {
  final DemographicType demographicType;
  final String response;

  DemographicResponse({
    required this.demographicType,
    required this.response,
  });

  @override
  List<Object> get props => [demographicType, response];
}
