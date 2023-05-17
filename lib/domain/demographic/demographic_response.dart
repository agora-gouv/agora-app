import 'package:agora/domain/demographic/demographic_question_type.dart';
import 'package:equatable/equatable.dart';

class DemographicResponse extends Equatable {
  final DemographicQuestionType questionType;
  final String response;

  DemographicResponse({
    required this.questionType,
    required this.response,
  });

  @override
  List<Object> get props => [questionType, response];
}
