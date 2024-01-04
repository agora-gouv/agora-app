import 'package:agora/common/strings/demographic_strings.dart';

enum DemographicType {
  gender,
  yearOfBirth,
  department,
  cityType,
  jobCategory,
  voteFrequency,
  publicMeetingFrequency,
  consultationFrequency,
}

extension DemographicTypeMapper on String {
  DemographicType? toDemographicType() {
    switch (this) {
      case DemographicStrings.gender:
        return DemographicType.gender;
      case DemographicStrings.yearOfBirth:
        return DemographicType.yearOfBirth;
      case DemographicStrings.department:
        return DemographicType.department;
      case DemographicStrings.cityType:
        return DemographicType.cityType;
      case DemographicStrings.jobCategory:
        return DemographicType.jobCategory;
      case DemographicStrings.voteFrequency:
        return DemographicType.voteFrequency;
      case DemographicStrings.publicMeetingFrequency:
        return DemographicType.publicMeetingFrequency;
      case DemographicStrings.consultationFrequency:
        return DemographicType.consultationFrequency;
    }
    return null;
  }
}
