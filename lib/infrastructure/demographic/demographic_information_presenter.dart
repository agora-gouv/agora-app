import 'package:agora/bloc/demographic/get/demographic_information_view_model.dart';
import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/domain/demographic/demographic_information.dart';
import 'package:agora/domain/demographic/demographic_question_type.dart';
import 'package:agora/domain/demographic/department.dart';

class DemographicInformationPresenter {
  static List<DemographicInformationViewModel> present(List<DemographicInformation> demographicInformations) {
    return demographicInformations.map((demographicInformation) {
      return DemographicInformationViewModel(
        demographicType: _buildTypeString(demographicInformation.demographicType),
        data: _buildData(demographicInformation.demographicType, demographicInformation.data),
      );
    }).toList();
  }

  static List<DemographicInformationViewModel> presentEmptyData(List<DemographicInformationViewModel> viewModels) {
    return viewModels.map((viewModel) {
      return DemographicInformationViewModel(
        demographicType: viewModel.demographicType,
        data: DemographicStrings.notSpecified,
      );
    }).toList();
  }

  static String _buildTypeString(DemographicType demographicType) {
    switch (demographicType) {
      case DemographicType.gender:
        return DemographicStrings.gender;
      case DemographicType.yearOfBirth:
        return DemographicStrings.yearOfBirth;
      case DemographicType.department:
        return DemographicStrings.department;
      case DemographicType.cityType:
        return DemographicStrings.cityType;
      case DemographicType.jobCategory:
        return DemographicStrings.jobCategory;
      case DemographicType.voteFrequency:
        return DemographicStrings.voteFrequency;
      case DemographicType.publicMeetingFrequency:
        return DemographicStrings.publicMeetingFrequency;
      case DemographicType.consultationFrequency:
        return DemographicStrings.consultationFrequency;
    }
  }

  static String _buildData(DemographicType demographicType, String? data) {
    switch (demographicType) {
      case DemographicType.gender:
        return _buildGenderData(data);
      case DemographicType.yearOfBirth:
        return _buildYearOfBirthData(data);
      case DemographicType.department:
        return _buildDepartmentData(data);
      case DemographicType.cityType:
        return _buildCityTypeData(data);
      case DemographicType.jobCategory:
        return _buildJobCategoryData(data);
      case DemographicType.voteFrequency:
      case DemographicType.publicMeetingFrequency:
      case DemographicType.consultationFrequency:
        return _buildFrequencyData(data);
    }
  }

  static String _buildGenderData(String? data) {
    switch (data) {
      case "M":
        return DemographicStrings.man;
      case "F":
        return DemographicStrings.woman;
      case "A":
        return DemographicStrings.other;
      default:
        return DemographicStrings.notSpecified;
    }
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
    switch (data) {
      case "R":
        return DemographicStrings.ruralArea;
      case "U":
        return DemographicStrings.urbanArea;
      case "A":
        return DemographicStrings.otherOrUnknown;
      default:
        return DemographicStrings.notSpecified;
    }
  }

  static String _buildJobCategoryData(String? data) {
    switch (data) {
      case "AG":
        return DemographicStrings.farmer;
      case "AR":
        return DemographicStrings.craftsmen;
      case "CA":
        return DemographicStrings.managerialStaff;
      case "PI":
        return DemographicStrings.intermediateProfessions;
      case "EM":
        return DemographicStrings.employees;
      case "OU":
        return DemographicStrings.workers;
      case "ET":
        return DemographicStrings.student;
      case "RE":
        return DemographicStrings.retired;
      case "AU":
        return DemographicStrings.otherOrNonWorking;
      case "UN":
        return DemographicStrings.unknown;
      default:
        return DemographicStrings.notSpecified;
    }
  }

  static String _buildFrequencyData(String? data) {
    switch (data) {
      case "S":
        return DemographicStrings.often;
      case "P":
        return DemographicStrings.sometime;
      case "J":
        return DemographicStrings.never;
      default:
        return DemographicStrings.notSpecified;
    }
  }
}
