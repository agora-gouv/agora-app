import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/profil/demographic/bloc/get/demographic_information_view_model.dart';
import 'package:agora/profil/demographic/domain/demographic_information.dart';
import 'package:agora/profil/demographic/domain/demographic_question_type.dart';
import 'package:agora/referentiel/territoire.dart';
import 'package:agora/referentiel/territoire_helper.dart';

class DemographicInformationPresenter {
  static List<DemographicInformationViewModel> present(
    List<DemographicInformation> demographicInformations,
    List<Territoire> referentiel,
  ) {
    return demographicInformations.map((demographicInformation) {
      return DemographicInformationViewModel(
        demographicType: _buildTypeString(demographicInformation.demographicType),
        data: _buildData(demographicInformation.demographicType, demographicInformation.data, referentiel),
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
      DemographicQuestionType.primaryDepartment || DemographicQuestionType.secondaryDepartment => "",
    };
  }

  static String _buildData(DemographicQuestionType demographicType, String? data, List<Territoire> referentiel) {
    return switch (demographicType) {
      DemographicQuestionType.gender => _buildGenderData(data),
      DemographicQuestionType.yearOfBirth => _buildYearOfBirthData(data),
      DemographicQuestionType.department => _buildDepartmentData(data, referentiel),
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

  static String _buildDepartmentData(String? data, List<Territoire> referentiel) {
    if (data != null) {
      final department = getDepartementByCodePostal(data, referentiel);
      return department != null ? "${department.label} (${department.codePostal})" : DemographicStrings.notSpecified;
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
