class ConsultationStrings {
  static const String toolbarPart1 = "Participer aux";
  static const String toolbarPart2 = "consultations";
  static const String ongoingConsultationPart1 = "Consultations";
  static const String ongoingConsultationPart2 = "en cours";
  static const String finishConsultationPart1 = "Ça a été fait";
  static const String finishConsultationPart2 = "grâce à vous";
  static const String answeredConsultationPart1 = "Mes ";
  static const String answeredConsultationPart2 = "consultations";
  static const String ongoingConsultationEmpty = "Vous avez répondu à toutes les consultations en cours\u{00A0}!";
  static const String noOngoingConsultation =
      "Il n’y a actuellement pas de consultation en cours. Vous serez prévenu(e) dès que la prochaine arrive\u{00A0}!";
  static const String gotoQags = "Découvrez les questions citoyennes";
  static const String consultationEmpty = "La liste est vide.";
  static const String answeredConsultationEmptyList = "Vous n'avez pas encore participé à une consultation.";
  static const String participate = "Participer";
  static const String beginButton = "Commencer";
  static const String beginButtonDescription = "Commencer la consultation";
  static const String endDate = "Jusqu'au %s";
  static const String rangeDate = "Du %1s au %2s";
  static const String participantCount = "%s participants";
  static const String participantCountGoal = "Prochain objectif\u{00A0}: %s\u{00A0}!";
  static const String ignoreQuestion = "Passer cette question →";
  static const String summaryTabResult = "Résultats";
  static const String consultationResultsPageTitle = "Réponses des participants";
  static const String summaryTabEtEnsuite = "Et ensuite ?";
  static const String summaryTabPresentation = "Présentation";
  static const String percentage = "%s\u{00A0}%";
  static const String step = "Étape %s/3";
  static const String step1 = "Consultation en cours";
  static const String step2 = "Engagements politiques";
  static const String step3 = "Mise en oeuvre";
  static const String returnToHome = "Retour à l'accueil";
  static const String share = "Partager";
  static const String notificationInformation = "Vous serez tenu(e) au courant des prochaines étapes\u{00A0}!";
  static const String refuseNotification = "Ne pas recevoir de notifications";
  static const String openedQuestionNotice =
      "Attention à n'indiquer ni données personnelles qui pourraient vous identifier, ni de lien vers un site internet.";
  static const String previousQuestion = "←";
  static const String nextQuestion = "Question suivante →";
  static const String validate = "Valider";
  static const String hintText = "Saisissez votre réponse\n\n\n\n\n\n";
  static const String maxChoices = "Vous pouvez choisir jusqu'à %s réponses.";
  static const String withCondition =
      "Vous devez répondre à cette question pour accéder à la suite de la consultation, adaptée pour vous.";
  static const String otherChoiceHint = "Précisez votre réponse";
  static const String severalResponsePossible = "Plusieurs réponses possibles.";

  static const String inProgress = "En cours";
  static const String coming = "A venir";
  static const String engagement = "Engagements";
  static const String implementation = "Mise en œuvre";
  static const String shortly = "PROCHAINEMENT";

  static const String shareConsultationDeeplink =
      "Comme moi, tu peux participer à la Consultation\u{00A0}: %1s\nhttps://agora.beta.gouv.fr/consultations/%2s";

  static const String summaryInformation =
      "Les réponses aux questions ouvertes de cette consultation seront traitées et rendues disponibles sous la forme d'une synthèse une fois la consultation terminée.";

  static const String openQuestionInformation =
      "L’analyse des réponses à cette question sera disponible dans la synthèse.";

  static String seenRationInformation(int seenRatio) =>
      "Cette question a été proposée à $seenRatio% des participants, du fait de leurs réponses précédentes.";
}
