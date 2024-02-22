import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/domain/consultation/consultation.dart';
import 'package:agora/domain/consultation/consultation_finished_paginated.dart';
import 'package:agora/domain/consultation/consultations_error_type.dart';
import 'package:agora/domain/consultation/details/consultation_details.dart';
import 'package:agora/domain/consultation/dynamic/dynamic_consultation.dart';
import 'package:agora/domain/consultation/dynamic/dynamic_consultation_section.dart';
import 'package:agora/domain/consultation/questions/consultation_question.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/domain/consultation/summary/consultation_summary.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_et_ensuite.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_presentation.dart';
import 'package:agora/infrastructure/consultation/repository/builder/consultation_questions_builder.dart';
import 'package:agora/infrastructure/consultation/repository/builder/consultation_responses_builder.dart';
import 'package:agora/infrastructure/errors/sentry_wrapper.dart';
import 'package:agora/pages/consultation/question/consultation_question_storage_client.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationRepository {
  Future<GetConsultationsRepositoryResponse> fetchConsultations();

  Future<GetConsultationsFinishedPaginatedRepositoryResponse> fetchConsultationsFinishedPaginated({
    required int pageNumber,
  });

  Future<GetConsultationDetailsRepositoryResponse> fetchConsultationDetails({
    required String consultationId,
  });

  Future<GetConsultationQuestionsRepositoryResponse> fetchConsultationQuestions({
    required String consultationId,
  });

  Future<SendConsultationResponsesRepositoryResponse> sendConsultationResponses({
    required String consultationId,
    required List<ConsultationQuestionResponses> questionsResponses,
  });

  Future<GetConsultationSummaryRepositoryResponse> fetchConsultationSummary({
    required String consultationId,
  });

  Future<DynamicConsultationResponse> getDynamicConsultation(String consultationId);
}

class ConsultationDioRepository extends ConsultationRepository {
  final AgoraDioHttpClient httpClient;
  final SentryWrapper? sentryWrapper;
  final Duration minimalSendingTime;
  final ConsultationQuestionStorageClient storageClient;

  ConsultationDioRepository({
    required this.httpClient,
    this.sentryWrapper,
    this.minimalSendingTime = const Duration(seconds: 2),
    required this.storageClient,
  });

  @override
  Future<GetConsultationsRepositoryResponse> fetchConsultations() async {
    try {
      final response = await httpClient.get(
        "/consultations",
      );
      final ongoingConsultations = response.data["ongoing"] as List;
      final finishedConsultations = response.data["finished"] as List;
      final answeredConsultations = response.data["answered"] as List;
      return GetConsultationsSucceedResponse(
        ongoingConsultations: ongoingConsultations.map((ongoingConsultation) {
          return ConsultationOngoing(
            id: ongoingConsultation["id"] as String,
            title: ongoingConsultation["title"] as String,
            coverUrl: ongoingConsultation["coverUrl"] as String,
            thematique: (ongoingConsultation["thematique"] as Map).toThematique(),
            endDate: (ongoingConsultation["endDate"] as String).parseToDateTime(),
            highlightLabel: ongoingConsultation["highlightLabel"] as String?,
          );
        }).toList(),
        finishedConsultations: finishedConsultations.map((finishedConsultation) {
          return ConsultationFinished(
            id: finishedConsultation["id"] as String,
            title: finishedConsultation["title"] as String,
            coverUrl: finishedConsultation["coverUrl"] as String,
            thematique: (finishedConsultation["thematique"] as Map).toThematique(),
            step: finishedConsultation["step"] as int,
          );
        }).toList(),
        answeredConsultations: answeredConsultations.map((answeredConsultation) {
          return ConsultationAnswered(
            id: answeredConsultation["id"] as String,
            title: answeredConsultation["title"] as String,
            coverUrl: answeredConsultation["coverUrl"] as String,
            thematique: (answeredConsultation["thematique"] as Map).toThematique(),
            step: answeredConsultation["step"] as int,
          );
        }).toList(),
      );
    } catch (e, s) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
          return GetConsultationsFailedResponse(errorType: ConsultationsErrorType.timeout);
        }
      }
      sentryWrapper?.captureException(e, s);
      return GetConsultationsFailedResponse();
    }
  }

  @override
  Future<GetConsultationsFinishedPaginatedRepositoryResponse> fetchConsultationsFinishedPaginated({
    required int pageNumber,
  }) async {
    try {
      final response = await httpClient.get("/consultations/finished/$pageNumber");
      return GetConsultationsFinishedPaginatedSucceedResponse(
        maxPage: response.data["maxPageNumber"] as int,
        finishedConsultationsPaginated: (response.data["consultations"] as List).map((finishedConsultation) {
          return ConsultationFinishedPaginated(
            id: finishedConsultation["id"] as String,
            title: finishedConsultation["title"] as String,
            coverUrl: finishedConsultation["coverUrl"] as String,
            thematique: (finishedConsultation["thematique"] as Map).toThematique(),
            step: finishedConsultation["step"] as int,
          );
        }).toList(),
      );
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
      return GetConsultationsFinishedPaginatedFailedResponse();
    }
  }

  @override
  Future<GetConsultationDetailsRepositoryResponse> fetchConsultationDetails({
    required String consultationId,
  }) async {
    try {
      final response = await httpClient.get(
        "/consultations/$consultationId",
      );
      return GetConsultationDetailsSucceedResponse(
        consultationDetails: ConsultationDetails(
          id: response.data["id"] as String,
          title: response.data["title"] as String,
          coverUrl: response.data["coverUrl"] as String,
          thematique: (response.data["thematique"] as Map).toThematique(),
          endDate: (response.data["endDate"] as String).parseToDateTime(),
          questionCount: response.data["questionCount"] as String,
          estimatedTime: response.data["estimatedTime"] as String,
          participantCount: response.data["participantCount"] as int,
          participantCountGoal: response.data["participantCountGoal"] as int,
          description: response.data["description"] as String,
          tipsDescription: response.data["tipsDescription"] as String,
          hasAnswered: response.data["hasAnswered"] as bool,
        ),
      );
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
      return GetConsultationDetailsFailedResponse();
    }
  }

  @override
  Future<GetConsultationQuestionsRepositoryResponse> fetchConsultationQuestions({
    required String consultationId,
  }) async {
    try {
      final response = await httpClient.get(
        "/consultations/$consultationId/questions",
      );
      return GetConsultationQuestionsSucceedResponse(
        consultationQuestions: ConsultationQuestionsBuilder.buildQuestions(
          uniqueChoiceQuestions: response.data["questionsUniqueChoice"] as List,
          openedQuestions: response.data["questionsOpened"] as List,
          multipleChoicesQuestions: response.data["questionsMultipleChoices"] as List,
          withConditionQuestions: response.data["questionsWithCondition"] as List,
          chapters: response.data["chapters"] as List,
        ),
      );
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
      return GetConsultationQuestionsFailedResponse();
    }
  }

  @override
  Future<SendConsultationResponsesRepositoryResponse> sendConsultationResponses({
    required String consultationId,
    required List<ConsultationQuestionResponses> questionsResponses,
  }) async {
    try {
      final timer = Future.delayed(minimalSendingTime);
      final response = await httpClient.post(
        "/consultations/$consultationId/responses",
        data: {
          "consultationId": consultationId,
          "responses": questionsResponses
              .map(
                (questionResponse) => {
                  "questionId": questionResponse.questionId,
                  "choiceIds": questionResponse.responseIds,
                  "responseText": questionResponse.responseText,
                },
              )
              .toList(),
        },
      );
      await timer;
      return SendConsultationResponsesSucceedResponse(
        shouldDisplayDemographicInformation: response.data["askDemographicInfo"] as bool,
      );
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
      return SendConsultationResponsesFailureResponse();
    }
  }

  @override
  Future<GetConsultationSummaryRepositoryResponse> fetchConsultationSummary({
    required String consultationId,
  }) async {
    try {
      final asyncResponse = httpClient.get(
        "/consultations/$consultationId/responses",
      );
      final (_, userResponses, _) = await storageClient.get(consultationId);
      final response = await asyncResponse;
      final etEnsuite = response.data["etEnsuite"];
      final presentation = response.data["presentation"];
      final explanations = etEnsuite["explanations"] as List;
      final etEnsuiteVideo = etEnsuite["video"] as Map?;
      final etEnsuiteConclusion = etEnsuite["conclusion"] as Map?;
      final summary = ConsultationSummary(
        title: response.data["title"] as String,
        participantCount: response.data["participantCount"] as int,
        results: ConsultationResponsesBuilder.buildResults(
          uniqueChoiceResults: response.data["resultsUniqueChoice"] as List,
          multipleChoicesResults: response.data["resultsMultipleChoice"] as List,
          userResponses: userResponses,
        ),
        etEnsuite: ConsultationSummaryEtEnsuite(
          step: etEnsuite["step"] as int,
          description: etEnsuite["description"] as String,
          explanationsTitle: etEnsuite["explanationsTitle"] as String?,
          explanations: explanations.map((explanation) {
            return ConsultationSummaryEtEnsuiteExplanation(
              isTogglable: explanation["isTogglable"] as bool,
              title: explanation["title"] as String,
              intro: explanation["intro"] as String,
              imageUrl: (explanation['image'] as Map?)?['url'] as String?,
              imageDescription: (explanation['image'] as Map?)?['description'] as String?,
              description: explanation["description"] as String,
            );
          }).toList(),
          video: etEnsuiteVideo != null
              ? ConsultationSummaryEtEnsuiteVideo(
                  title: etEnsuiteVideo["title"] as String,
                  intro: etEnsuiteVideo["intro"] as String,
                  videoUrl: etEnsuiteVideo["videoUrl"] as String,
                  videoWidth: etEnsuiteVideo["videoWidth"] as int,
                  videoHeight: etEnsuiteVideo["videoHeight"] as int,
                  transcription: etEnsuiteVideo["transcription"] as String,
                )
              : null,
          conclusion: etEnsuiteConclusion != null
              ? ConsultationSummaryEtEnsuiteConclusion(
                  title: etEnsuiteConclusion["title"] as String,
                  description: etEnsuiteConclusion["description"] as String,
                )
              : null,
        ),
        presentation: ConsultationSummaryPresentation(
          startDate: (presentation["startDate"] as String).parseToDateTime(),
          endDate: (presentation["endDate"] as String).parseToDateTime(),
          description: presentation["description"] as String,
          tipDescription: presentation["tipsDescription"] as String,
        ),
      );
      return GetConsultationSummarySucceedResponse(consultationSummary: summary);
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
      return GetConsultationSummaryFailedResponse();
    }
  }

  @override
  Future<DynamicConsultationResponse> getDynamicConsultation(String consultationId) async {
    if (consultationId == '23325238-180d-4472-8d58-b88bd0d86ea3') {
      final consultation = DynamicConsultation(
        id: consultationId,
        title: 'Quelles réformes pour le métier d’infirmier ?',
        coverUrl: 'https://content.agora.beta.gouv.fr/consultation_covers/infirmiers.jpeg',
        shareText: 'shareText',
        thematicLogo: '🚊',
        thematicLabel: 'Santé',
        questionsInfos: null,
        responseInfos: ConsultationResponseInfos(
          picto: '🙌',
          description: '<body><b>Merci pour votre participation</b><br> à cette consultation !</body>',
        ),
        infoHeader: ConsultationInfoHeader(
          logo: '🎉',
          description:
              '<body>Les réponses à cette consultation ont abouti à un projet de loi. <b> Merci à tous !</b></body>',
        ),
        collapsedSections: [
          DynamicConsultationSectionTitle('Pourquoi cette consultation ?'),
          DynamicConsultationSectionRichText(
            "<body>🗳 La consultation est terminée !<br/>Les résultats sont en cours d’analyse. Vous serez notifié",
          ),
        ],
        expandedSections: [
          DynamicConsultationSectionTitle('Pourquoi cette consultation ?'),
          DynamicConsultationSectionRichText(
            "<body>🗳 La consultation est terminée !<br/>Les résultats sont en cours d’analyse. Vous serez notifié(e) dès que la synthèse sera disponible.<br/><br/>—<br║             /><br/>👉 A partir des résultats de cette consultation, la ministre déléguée chargée de l’Organisation territoriale et des Professions de santé, <b>Agnès Firmin Le Bodo</b> enrichira les <b>travaux relatifs à la réforme à venir du métier d’infirmier</b>. ",
          ),
          DynamicConsultationSectionTitle('Les jeunes urbains en première ligne'),
          DynamicConsultationSectionFocusNumber(
            title: '30%',
            desctiption:
                "Des <b>conducteurs</b> sont prêts à proposer du co-voiturage s’ils sont accompagnés dans leur démarche",
          ),
          DynamicConsultationSectionRichText(
            "<body>Avec plus de <b>30 000 participations</b> pour 6 semaines de consultation, vous avez été nombreux à partager votre avis, et nous vous en remercions !<br><br>Les jeunes <b>de 18 à 25 ans</b> ont été les plus nombreux avec plus de 45% des réponses apportées. 65% des réponses ont été enregistrées par des personnes vivant dans des <b>villes grandes ou moyennes.</b></body>",
          ),
          DynamicConsultationSectionQuote(
            "<i>“ En plus de réduire mes dépenses, j’ai rencontré beaucoup de gens intéressants avec qui j’ai gardé contact ”</i> — <b>Alice</b>",
          ),
          DynamicConsultationSectionImage(
            desctiption: "Ceci est la description de l'image",
            url:
                "https://raw.githubusercontent.com/agora-gouv/agora-content/main/participation_citoyenne/step2-b01.png",
          ),
          DynamicConsultationSectionRichText(
            "<body>Avec plus de <b>30 000 participations</b> pour 6 semaines de consultation, vous avez été nombreux à partager votre avis, et nous vous en remercions !<br><br>Les jeunes <b>de 18 à 25 ans</b> ont été les plus nombreux avec plus de 45% des réponses apportées. 65% des réponses ont été enregistrées par des personnes vivant dans des <b>villes grandes ou moyennes.</b></body>",
          ),
        ],
        participationInfo: ConsultationParticipationInfo(
          participantCount: 15035,
          participantCountGoal: 30000,
        ),
        downloadInfo: ConsultationDownloadInfo(
          url: 'https://github.com/agora-gouv/agora-content/blob/main/participation_citoyenne/step2-rapportvdef.pdf',
        ),
        feedbackQuestion: ConsultationFeedbackQuestion(
          title: 'Donnez votre avis',
          picto: '💬',
          description: '<body>Avez-vous aimé la réponse du gouvernement à cette consultation ?</body>',
          id: 'yolo',
        ),
        feedbackResult: ConsultationFeedbackResults(
          id: 'yolo',
          picto: '💬',
          title: 'Donnez votre avis',
          description: '<body>Avez-vous aimé la réponse du gouvernement à cette consultation ?</body>',
          positiveRatio: 68,
          negativeRation: 32,
          responseCount: 12034,
          userResponseIsPositive: true,
        ),
        history: null,
        footer: ConsultationFooter(
          title: 'Envie d\'aller plus loin ?',
          description:
              "<body>Rendez-vous sur :<br/><br/><ul><li><a href=\"https://sante.gouv.fr/\">Le site du ministère de la Santé etde la Prévention</a><br/></li><li><a href=\"https://sante.gouv.fr/metiers-et-concours/les-metiers-de-la-sante/le-repertoire-des-metiers-de-la-sante-et-de-l-autonomie-fonction-publique/soins/sousfamille/soins-infirmiers\">L’ensemble desactivités liées au métier d’infirmier</a><br/></li></ul><ul><li><a href=\"https://sante.gouv.fr/metiers-et-concours/les-metiers-de-la-sante/le-repertoire-des-metiers-de-la-sante-et-de-l-autonomie-fonction-publique/soins/sousfamille/soins-infirmiers/metier/infirmier-ere-en-soins-generaux-ide\">La description du métier d’Infirmier(ère) en soins généraux (IDE)</a></body>",
        ),
      );
      return DynamicConsultationSuccessResponse(consultation);
    }
    final consultation = DynamicConsultation(
      id: consultationId,
      title: 'Développer le covoiturage au quotidien',
      coverUrl: 'https://content.agora.beta.gouv.fr/consultation_covers/covoiturage.png',
      shareText: 'shareText',
      thematicLogo: '🚊',
      thematicLabel: 'Transports',
      questionsInfos: ConsultationQuestionsInfos(
        participantCount: 15035,
        participantCountGoal: 30000,
        questionCount: '5 à 10 questions',
        estimatedTime: '5 minutes',
        endDate: DateTime(2024, 1, 21, 23, 59),
      ),
      responseInfos: null,
      infoHeader: null,
      collapsedSections: [
        DynamicConsultationSectionTitle('Pourquoi cette consultation ?'),
        DynamicConsultationSectionRichText(
          "<body><b>Tous les cinq jours, un enfant meurt sous les coups de ses parents. </b><br/>Toutes les trois minutes, un enfant est victime d’inceste, de viol ou d’agression sexuelle. </b><br/><br/><b>Les violences faites aux enfants</b></body>",
        ),
      ],
      expandedSections: [
        DynamicConsultationSectionTitle('Pourquoi cette consultation ?'),
        DynamicConsultationSectionRichText(
          "<body><b>Tous les cinq jours, un enfant meurt sous les coups de ses parents. </b><br/>Toutes les trois minutes, un enfant est victime d’inceste, de viol ou d’agression sexuelle. </b><br/><br/><b>Les violences faites aux enfants concernent l’ensemble de la société et nous obligent. </b><br/></b><br/><b>Qu’elles se déroulent en milieu familial ou au sein d’institutions, les violences subies durant l’enfance ou l’adolescence ont des effets négatifs très importants et durables, représentant des risques en termes de santé mentaleet physique, de développement, de vie affective, de scolarité, d’insertion sociale et professionnelle. Prévenir ces violences et protéger les enfants sont ainsi des enjeux de santé publique.</b><br/></b><br/>Au vu de la triste réalité des chiffres de notre pays, conformément à ses différents engagements internationaux et européens en matière de lutte contre les violences faites aux enfants,<b> la France poursuit l’ambition d’apporter une réponse globale pour lutter contre l’ensemble desviolences faites aux enfants</b>.<br/><br/>Les avis recueillis contribueront à nourrir la stratégie gouvernementale de lutte contre les violences commises sur lesenfants, dont les mesures seront dévoilées par la Première ministre à l’occasion du comité interministériel à l’enfance cet automne.<br/><br/>🤝 <b>Agora, l’appli qui vous donne la parole et vous rend des comptes</b><br/></b><br/><i>Une consultation sur Agora est bien plus qu’un sondage ! Les questions sont pensées pour nourrir les décisions gouvernementales et la Ministre s’engage à y donner suite.</i><br/><i><br/>En contribuant au débat, vous travaillez à définir les orientations et les actions du Gouvernement.</i></body>",
        ),
        DynamicConsultationSectionTitle('Réponse de notre chef à tous'),
        DynamicConsultationSectionVideo(
          url: 'https://github.com/agora-gouv/agora-content/raw/main/qag_responses/responseQag5.mp4',
          transcription: 'Il est très difficile de retranscrire les paroles du grand Thierry',
          width: 480,
          height: 854,
          authorName: 'Thierry Lee',
          authorDescription:
              "<body><b>Inventeur du produit Agora<br><br><i>   Issu d'OCTO Technology, Thierry Lee s'est toujours battu pour la justice sociale. Devenu professeur d'informatique, il a sensibilisé ses élèves à la démocratie directe, organisant des votes sur des sujets de la vie quotidienne.<br><br>Sa passion pour la participation citoyenne l'a poussé à créer un mouvement prônant la démocratie directe. Le mouvement a rapidement gagné en popularité, attirant des citoyens lassés du système politique traditionnel.<br><br>Thierry a décidé de se présenter à l'élection présidentielle, avec un programme audacieux : donner aux citoyens le pouvoir de voter directement sur les lois et les décisions importantes.<br><br>Sa campagne a été un véritable succès, galvanisant la population par sa sincérité et son engagement. Le jour du scrutin, Thierry a été élu président de la République française avec une majorité écrasante.<br><br>Dès son investiture, il a mis en place des réformes pour implémenter la démocratie directe. Des plateformes numériques ont été créées pour permettre aux citoyens de voter sur les lois et de proposer des initiatives.<br><br>Le mandat de Thierry a été marqué par une participation citoyenne sans précédent. Le peuple français a enfin eu voix au chapitre, et la France est devenue un modèle de démocratie directe pour le monde entier.</i></b>",
          date: DateTime(2024, 2, 19, 23),
        ),
      ],
      participationInfo: null,
      downloadInfo: null,
      feedbackQuestion: null,
      feedbackResult: null,
      history: null,
      footer: ConsultationFooter(
        title: null,
        description:
            "<body>🗣 Consultation proposée par le <b>Ministère des Transports</b><br/><br/>🎯<b> Objectif</b> : évaluer et améliorer le plan national covoiturage <br/><br/>🚀<b>Axe gouvernemental</b> : Planifier et accélérer la transition écologique</body>",
      ),
    );
    return DynamicConsultationSuccessResponse(consultation);
  }
}

abstract class GetConsultationsRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetConsultationsSucceedResponse extends GetConsultationsRepositoryResponse {
  final List<ConsultationOngoing> ongoingConsultations;
  final List<ConsultationFinished> finishedConsultations;
  final List<ConsultationAnswered> answeredConsultations;

  GetConsultationsSucceedResponse({
    required this.ongoingConsultations,
    required this.finishedConsultations,
    required this.answeredConsultations,
  });

  @override
  List<Object> get props => [
        ongoingConsultations,
        finishedConsultations,
        answeredConsultations,
      ];
}

class GetConsultationsFailedResponse extends GetConsultationsRepositoryResponse {
  final ConsultationsErrorType errorType;

  GetConsultationsFailedResponse({this.errorType = ConsultationsErrorType.generic});

  @override
  List<Object> get props => [errorType];
}

abstract class GetConsultationsFinishedPaginatedRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetConsultationsFinishedPaginatedSucceedResponse extends GetConsultationsFinishedPaginatedRepositoryResponse {
  final int maxPage;
  final List<ConsultationFinishedPaginated> finishedConsultationsPaginated;

  GetConsultationsFinishedPaginatedSucceedResponse({
    required this.maxPage,
    required this.finishedConsultationsPaginated,
  });

  @override
  List<Object> get props => [maxPage, finishedConsultationsPaginated];
}

class GetConsultationsFinishedPaginatedFailedResponse extends GetConsultationsFinishedPaginatedRepositoryResponse {}

abstract class GetConsultationDetailsRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetConsultationDetailsSucceedResponse extends GetConsultationDetailsRepositoryResponse {
  final ConsultationDetails consultationDetails;

  GetConsultationDetailsSucceedResponse({required this.consultationDetails});

  @override
  List<Object> get props => [consultationDetails];
}

class GetConsultationDetailsFailedResponse extends GetConsultationDetailsRepositoryResponse {}

abstract class GetConsultationQuestionsRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetConsultationQuestionsSucceedResponse extends GetConsultationQuestionsRepositoryResponse {
  final List<ConsultationQuestion> consultationQuestions;

  GetConsultationQuestionsSucceedResponse({required this.consultationQuestions});

  @override
  List<Object> get props => [consultationQuestions];
}

class GetConsultationQuestionsFailedResponse extends GetConsultationQuestionsRepositoryResponse {}

abstract class SendConsultationResponsesRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class SendConsultationResponsesSucceedResponse extends SendConsultationResponsesRepositoryResponse {
  final bool shouldDisplayDemographicInformation;

  SendConsultationResponsesSucceedResponse({required this.shouldDisplayDemographicInformation});

  @override
  List<Object> get props => [shouldDisplayDemographicInformation];
}

class SendConsultationResponsesFailureResponse extends SendConsultationResponsesRepositoryResponse {}

abstract class GetConsultationSummaryRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetConsultationSummarySucceedResponse extends GetConsultationSummaryRepositoryResponse {
  final ConsultationSummary consultationSummary;

  GetConsultationSummarySucceedResponse({required this.consultationSummary});

  @override
  List<Object> get props => [consultationSummary];
}

class GetConsultationSummaryFailedResponse extends GetConsultationSummaryRepositoryResponse {}

sealed class DynamicConsultationResponse extends Equatable {}

class DynamicConsultationSuccessResponse extends DynamicConsultationResponse {
  final DynamicConsultation consultation;

  DynamicConsultationSuccessResponse(this.consultation);

  @override
  List<Object?> get props => [consultation];
}

class DynamicConsultationErrorResponse extends DynamicConsultationResponse {
  @override
  List<Object?> get props => [];
}
