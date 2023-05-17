import 'package:agora/domain/demographic/demographic_question_type.dart';
import 'package:equatable/equatable.dart';

class DemographicInformation extends Equatable {
  final DemographicType demographicType;
  final String? data;

  DemographicInformation({
    required this.demographicType,
    required this.data,
  });

  @override
  List<Object?> get props => [demographicType, data];
}
