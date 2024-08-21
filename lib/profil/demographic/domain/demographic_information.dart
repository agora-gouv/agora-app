import 'package:agora/profil/demographic/domain/demographic_question_type.dart';
import 'package:equatable/equatable.dart';

class DemographicInformation extends Equatable {
  final DemographicQuestionType demographicType;
  final String? data;

  DemographicInformation({
    required this.demographicType,
    required this.data,
  });

  @override
  List<Object?> get props => [demographicType, data];
}
