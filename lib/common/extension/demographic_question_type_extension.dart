import 'package:agora/domain/demographic/demographic_question_type.dart';

extension DemographicTypeExtension on DemographicType {
  String toTypeString() {
    switch (this) {
      case DemographicType.gender:
        return "gender";
      case DemographicType.yearOfBirth:
        return "yearOfBirth";
      case DemographicType.department:
        return "department";
      case DemographicType.cityType:
        return "cityType";
      case DemographicType.jobCategory:
        return "jobCategory";
      case DemographicType.voteFrequency:
        return "voteFrequency";
      case DemographicType.publicMeetingFrequency:
        return "publicMeetingFrequency";
      case DemographicType.consultationFrequency:
        return "consultationFrequency";
    }
  }
}
