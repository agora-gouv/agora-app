class DemographicResponseHelper {
  static List<DemographicResponseChoice> question1ResponseChoice() {
    return [
      DemographicResponseChoice(responseLabel: "Une femme", responseCode: "F"),
      DemographicResponseChoice(responseLabel: "Un homme", responseCode: "M"),
      DemographicResponseChoice(responseLabel: "Autre", responseCode: "A"),
    ];
  }

  static List<DemographicResponseChoice> question4ResponseChoice() {
    return [
      DemographicResponseChoice(responseLabel: "En milieu rural", responseCode: "R"),
      DemographicResponseChoice(responseLabel: "En milieu urbain", responseCode: "U"),
      DemographicResponseChoice(responseLabel: "Autre / Je ne sais pas", responseCode: "A"),
    ];
  }

  static List<DemographicResponseChoice> question5ResponseChoice() {
    return [
      DemographicResponseChoice(responseLabel: "Agriculteurs", responseCode: "AG"),
      DemographicResponseChoice(responseLabel: "Artisans, commerçants, chefs d'entreprise", responseCode: "AR"),
      DemographicResponseChoice(responseLabel: "Cadres", responseCode: "CA"),
      DemographicResponseChoice(responseLabel: "Professions intermédiaires", responseCode: "PI"),
      DemographicResponseChoice(responseLabel: "Employés", responseCode: "EM"),
      DemographicResponseChoice(responseLabel: "Ouvriers", responseCode: "OU"),
      DemographicResponseChoice(responseLabel: "Etudiants", responseCode: "ET"),
      DemographicResponseChoice(responseLabel: "Retraités", responseCode: "RE"),
      DemographicResponseChoice(responseLabel: "Autre / Sans activité professionnelle", responseCode: "AU"),
      DemographicResponseChoice(responseLabel: "Je ne sais pas", responseCode: "UN"),
    ];
  }

  static List<DemographicResponseChoice> question6ResponseChoice() {
    return [
      DemographicResponseChoice(responseLabel: "Souvent", responseCode: "S"),
      DemographicResponseChoice(responseLabel: "Parfois", responseCode: "P"),
      DemographicResponseChoice(responseLabel: "Jamais", responseCode: "J"),
    ];
  }
}

class DemographicResponseChoice {
  final String responseLabel;
  final String responseCode;

  DemographicResponseChoice({required this.responseLabel, required this.responseCode});
}
