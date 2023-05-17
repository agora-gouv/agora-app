import 'package:agora/domain/demographic/demographic_question_type.dart';

extension DemographicQuestionTypeExtension on DemographicQuestionType {
  String toTypeString() {
    switch (this) {
      case DemographicQuestionType.gender:
        return "gender";
      case DemographicQuestionType.yearOfBirth:
        return "yearOfBirth";
      case DemographicQuestionType.department:
        return "department";
      case DemographicQuestionType.cityType:
        return "cityType";
      case DemographicQuestionType.jobCategory:
        return "jobCategory";
      case DemographicQuestionType.voteFrequency:
        return "voteFrequency";
      case DemographicQuestionType.publicMeetingFrequency:
        return "publicMeetingFrequency";
      case DemographicQuestionType.consultationFrequency:
        return "consultationFrequency";
    }
  }
}
