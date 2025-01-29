import 'package:agora/profil/demographic/domain/demographic_question_type.dart';

extension DemographicTypeExtension on DemographicQuestionType {
  String toTypeString() {
    return switch (this) {
      DemographicQuestionType.gender => "gender",
      DemographicQuestionType.yearOfBirth => "yearOfBirth",
      DemographicQuestionType.department => "department",
      DemographicQuestionType.cityType => "cityType",
      DemographicQuestionType.jobCategory => "jobCategory",
      DemographicQuestionType.voteFrequency => "voteFrequency",
      DemographicQuestionType.publicMeetingFrequency => "publicMeetingFrequency",
      DemographicQuestionType.consultationFrequency => "consultationFrequency",
      DemographicQuestionType.primaryDepartment => "primaryDepartment",
      DemographicQuestionType.secondaryDepartment => "secondaryDepartment"
    };
  }
}
