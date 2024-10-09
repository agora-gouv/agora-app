import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/profil/demographic/bloc/get/demographic_information_view_model.dart';
import 'package:agora/profil/demographic/domain/demographic_information.dart';
import 'package:agora/profil/demographic/domain/demographic_question_type.dart';
import 'package:agora/profil/demographic/domain/department.dart';

class DemographicInformationPresenter {
  static List<DemographicInformationViewModel> present(List<DemographicInformation> demographicInformations) {
    return demographicInformations.map((demographicInformation) {
      return DemographicInformationViewModel(
        demographicType: _buildTypeString(demographicInformation.demographicType),
        data: _buildData(demographicInformation.demographicType, demographicInformation.data),
      );
    }).toList();
  }

  static String _buildTypeString(DemographicQuestionType demographicType) {
    return switch (demographicType) {
      DemographicQuestionType.gender => DemographicStrings.gender,
      DemographicQuestionType.yearOfBirth => DemographicStrings.yearOfBirth,
      DemographicQuestionType.department => DemographicStrings.department,
      DemographicQuestionType.cityType => DemographicStrings.cityType,
      DemographicQuestionType.jobCategory => DemographicStrings.jobCategory,
      DemographicQuestionType.voteFrequency => DemographicStrings.voteFrequency,
      DemographicQuestionType.publicMeetingFrequency => DemographicStrings.publicMeetingFrequency,
      DemographicQuestionType.consultationFrequency => DemographicStrings.consultationFrequency,
      DemographicQuestionType.primaryDepartment => DemographicStrings.primaryDepartment,
      DemographicQuestionType.secondaryDepartment => DemographicStrings.secondaryDepartment
    };
  }

  static String _buildData(DemographicQuestionType demographicType, String? data) {
    return switch (demographicType) {
      DemographicQuestionType.gender => _buildGenderData(data),
      DemographicQuestionType.yearOfBirth => _buildYearOfBirthData(data),
      DemographicQuestionType.department => _buildDepartmentData(data),
      DemographicQuestionType.cityType => _buildCityTypeData(data),
      DemographicQuestionType.jobCategory => _buildJobCategoryData(data),
      DemographicQuestionType.voteFrequency ||
      DemographicQuestionType.publicMeetingFrequency ||
      DemographicQuestionType.consultationFrequency =>
        _buildFrequencyData(data),
      DemographicQuestionType.primaryDepartment || DemographicQuestionType.secondaryDepartment => ""
    };
  }

  static String _buildGenderData(String? data) {
    return switch (data) {
      "M" => DemographicStrings.man,
      "F" => DemographicStrings.woman,
      "A" => DemographicStrings.other,
      _ => DemographicStrings.notSpecified
    };
  }

  static String _buildYearOfBirthData(String? data) {
    if (data != null) {
      return data;
    } else {
      return DemographicStrings.notSpecified;
    }
  }

  static String _buildDepartmentData(String? data) {
    if (data != null) {
      final department = DepartmentHelper.getDepartment().firstWhere((department) => department.code == data);
      return "${department.name} (${department.code})";
    } else {
      return DemographicStrings.notSpecified;
    }
  }

  static String _buildCityTypeData(String? data) {
    return switch (data) {
      "R" => DemographicStrings.ruralArea,
      "U" => DemographicStrings.urbanArea,
      "A" => DemographicStrings.otherOrUnknown,
      _ => DemographicStrings.notSpecified
    };
  }

  static String _buildJobCategoryData(String? data) {
    return switch (data) {
      "AG" => DemographicStrings.farmer,
      "AR" => DemographicStrings.craftsmen,
      "CA" => DemographicStrings.managerialStaff,
      "PI" => DemographicStrings.intermediateProfessions,
      "EM" => DemographicStrings.employees,
      "OU" => DemographicStrings.workers,
      "ET" => DemographicStrings.student,
      "RE" => DemographicStrings.retired,
      "AU" => DemographicStrings.otherOrNonWorking,
      "UN" => DemographicStrings.unknown,
      _ => DemographicStrings.notSpecified
    };
  }

  static String _buildFrequencyData(String? data) {
    return switch (data) {
      "S" => DemographicStrings.often,
      "P" => DemographicStrings.sometime,
      "J" => DemographicStrings.never,
      _ => DemographicStrings.notSpecified
    };
  }
}
