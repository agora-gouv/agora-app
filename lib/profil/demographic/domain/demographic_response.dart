import 'package:agora/profil/demographic/domain/demographic_question_type.dart';
import 'package:equatable/equatable.dart';

class DemographicResponse extends Equatable {
  final DemographicQuestionType demographicType;
  final String response;

  DemographicResponse({
    required this.demographicType,
    required this.response,
  });

  @override
  List<Object> get props => [demographicType, response];
}
