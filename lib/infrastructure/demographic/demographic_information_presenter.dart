import 'package:agora/bloc/demographic/get/demographic_information_view_model.dart';
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

  static String _buildTypeString(DemographicType demographicType) {
    switch (demographicType) {
      case DemographicType.gender:
        return "Genre";
      case DemographicType.yearOfBirth:
        return "Année de naissance";
      case DemographicType.department:
        return "Département";
      case DemographicType.cityType:
        return "J'habite";
      case DemographicType.jobCategory:
        return "Catégorie socio-professionnelle";
      case DemographicType.voteFrequency:
        return "Vote";
      case DemographicType.publicMeetingFrequency:
        return "Réunions publiques";
      case DemographicType.consultationFrequency:
        return "Consultations citoyennes";
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
        return "Homme";
      case "F":
        return "Femme";
      case "A":
        return "Autre";
      default:
        return "Non renseigné";
    }
  }

  static String _buildYearOfBirthData(String? data) {
    if (data != null) {
      return data;
    } else {
      return "Non renseigné";
    }
  }

  static String _buildDepartmentData(String? data) {
    if (data != null) {
      final department = DepartmentHelper.getDepartment().firstWhere((department) => department.code == data);
      return "${department.name} (${department.code})";
    } else {
      return "Non renseigné";
    }
  }

  static String _buildCityTypeData(String? data) {
    switch (data) {
      case "R":
        return "En milieu rural";
      case "U":
        return "En milieu urbain";
      case "A":
        return "Autre / Je ne sais pas";
      default:
        return "Non renseigné";
    }
  }

  static String _buildJobCategoryData(String? data) {
    switch (data) {
      case "AG":
        return "Agriculteurs";
      case "AR":
        return "Artisans, commerçants, chefs d'entreprise";
      case "CA":
        return "Cadres";
      case "PI":
        return "Professions intermédiaires";
      case "EM":
        return "Employés";
      case "OU":
        return "Ouvriers";
      case "ND":
        return "Non déterminé";
      case "UN":
        return "Je ne sais pas";
      default:
        return "Non renseigné";
    }
  }

  static String _buildFrequencyData(String? data) {
    switch (data) {
      case "S":
        return "Souvent";
      case "P":
        return "Parfois";
      case "J":
        return "Jamais";
      default:
        return "Non renseigné";
    }
  }
}
