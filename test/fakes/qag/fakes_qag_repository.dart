import 'package:agora/domain/qag/details/qag_details.dart';
import 'package:agora/domain/qag/header_qag.dart';
import 'package:agora/domain/qag/moderation/qag_moderation_list.dart';
import 'package:agora/domain/qag/qag.dart';
import 'package:agora/domain/qag/qag_response.dart';
import 'package:agora/domain/qag/qag_response_paginated.dart';
import 'package:agora/domain/qag/qag_similar.dart';
import 'package:agora/domain/qag/qas_list_filter.dart';
import 'package:agora/domain/thematique/thematique.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';

class FakeQagSuccessRepository extends QagRepository {
  @override
  Future<CreateQagRepositoryResponse> createQag({
    required String title,
    required String description,
    required String author,
    required String thematiqueId,
  }) async {
    return CreateQagSucceedResponse(qagId: "qagId");
  }

  @override
  Future<AskQagStatusRepositoryResponse> fetchAskQagStatus() async {
    return AskQagStatusSucceedResponse(askQagError: "askQagError");
  }

  @override
  Future<GetQagsListRepositoryResponse> fetchQagList({
    required int pageNumber,
    required String? thematiqueId,
    required QagListFilter filter,
  }) async {
    switch (pageNumber) {
      case 1:
        return GetQagListSucceedResponse(
          maxPage: 2,
          qags: [
            Qag(
              id: "id1",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: DateTime(2024, 2, 23),
              supportCount: 8,
              isSupported: false,
              isAuthor: false,
            ),
          ],
          header: HeaderQag(
            id: "headerId",
            title: "headerTitle",
            message: "headerMessage",
          ),
        );
      case 2:
        return GetQagListSucceedResponse(
          maxPage: 2,
          qags: [
            Qag(
              id: "id1",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: DateTime(2024, 2, 23),
              supportCount: 9,
              isSupported: true,
              isAuthor: false,
            ),
            Qag(
              id: "id2",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: DateTime(2024, 2, 23),
              supportCount: 8,
              isSupported: true,
              isAuthor: false,
            ),
          ],
          header: HeaderQag(
            id: "headerId2",
            title: "headerTitle2",
            message: "headerMessage2",
          ),
        );
      default:
        return GetQagListFailedResponse();
    }
  }

  @override
  Future<GetQagsResponseRepositoryResponse> fetchQagsResponse() async {
    return GetQagsResponseSucceedResponse(
      qagResponsesIncoming: [
        QagResponseIncoming(
          qagId: "qagId2",
          thematique: Thematique(picto: "🚊", label: "Transports"),
          title: "Pour la ...",
          supportCount: 200,
          isSupported: true,
          order: 0,
          dateLundiPrecedent: DateTime(2024, 6, 3),
          dateLundiSuivant: DateTime(2024, 6, 10),
        ),
      ],
      qagResponses: [
        QagResponse(
          qagId: "qagId",
          thematique: Thematique(picto: "🚊", label: "Transports"),
          title: "Pour la retraite : comment est-ce qu'on aboutit au chiffre de 65 ans ?",
          author: "author",
          authorPortraitUrl: "authorPortraitUrl",
          responseDate: DateTime(2024, 1, 23),
          order: 1,
        ),
      ],
    );
  }

  @override
  Future<GetQagsResponsePaginatedRepositoryResponse> fetchQagsResponsePaginated({
    required int pageNumber,
  }) async {
    return GetQagsResponsePaginatedSucceedResponse(
      maxPage: 3,
      paginatedQagsResponse: [
        QagResponsePaginated(
          qagId: "qagId",
          thematique: Thematique(picto: "🚊", label: "Transports"),
          title: "Pour la ... ?",
          author: "author",
          authorPortraitUrl: "authorPortraitUrl",
          responseDate: DateTime(2024, 1, 23),
        ),
      ],
    );
  }

  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
  }) async {
    return GetQagDetailsSucceedResponse(
      qagDetails: QagDetails(
        id: qagId,
        thematique: Thematique(picto: "🚊", label: "Transports"),
        title: "Pour la retraite : comment est-ce qu'on aboutit au chiffre de 65 ans ?",
        description: "Le conseil d'orientation des retraites indique que les comptes sont à l'équilibre.",
        date: DateTime(2024, 1, 23),
        username: "CollectifSauvonsLaRetraite",
        canShare: false,
        canSupport: false,
        canDelete: false,
        isAuthor: false,
        support: QagDetailsSupport(count: 112, isSupported: true),
        response: null,
        textResponse: null,
      ),
    );
  }

  @override
  Future<DeleteQagRepositoryResponse> deleteQag({required String qagId}) async {
    return DeleteQagSucceedResponse();
  }

  @override
  Future<SupportQagRepositoryResponse> supportQag({required String qagId}) async {
    return SupportQagSucceedResponse();
  }

  @override
  Future<DeleteSupportQagRepositoryResponse> deleteSupportQag({required String qagId}) async {
    return DeleteSupportQagSucceedResponse();
  }

  @override
  Future<QagFeedbackRepositoryResponse> giveQagResponseFeedback({
    required String qagId,
    required bool isHelpful,
  }) async {
    return QagFeedbackSuccessBodyResponse();
  }

  @override
  Future<QagModerationListRepositoryResponse> fetchQagModerationList() async {
    return QagModerationListSuccessResponse(
      qagModerationList: QagModerationList(
        totalNumber: 120,
        qagsToModeration: [
          QagModeration(
            id: "id",
            thematique: Thematique(picto: "🚊", label: "Transports"),
            title: "title",
            description: "description",
            username: "username",
            date: DateTime(2024, 4, 23),
            supportCount: 9,
            isSupported: true,
          ),
        ],
      ),
    );
  }

  @override
  Future<ModerateQagRepositoryResponse> moderateQag({
    required String qagId,
    required bool isAccepted,
  }) async {
    return ModerateQagSuccessResponse();
  }

  @override
  Future<QagHasSimilarRepositoryResponse> hasSimilarQag({
    required String title,
  }) async {
    return QagHasSimilarSuccessResponse(hasSimilar: true);
  }

  @override
  Future<QagSimilarRepositoryResponse> getSimilarQags({
    required String title,
  }) async {
    return QagSimilarSuccessResponse(
      similarQags: [
        QagSimilar(
          id: "id",
          thematique: Thematique(picto: "🚊", label: "Transports"),
          title: "title",
          description: "description",
          username: "username",
          date: DateTime(2024, 4, 23),
          supportCount: 9,
          isSupported: true,
        ),
      ],
    );
  }

  @override
  Future<GetSearchQagsRepositoryResponse> fetchSearchQags({required String? keywords}) async {
    return GetSearchQagsSucceedResponse(
      searchQags: [
        Qag(
          id: "id0",
          thematique: Thematique(picto: "🚊", label: "Transports"),
          title: "title0",
          username: "username0",
          date: DateTime(2024, 4, 23),
          supportCount: 8,
          isSupported: true,
          isAuthor: false,
        ),
      ],
    );
  }
}

class FakeQagDetailsSuccessRepository extends FakeQagSuccessRepository {
  final QagDetails qagDetails;
  int remainingSendFeedbackCount;

  FakeQagDetailsSuccessRepository({required this.qagDetails, this.remainingSendFeedbackCount = 999});

  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
  }) async {
    return GetQagDetailsSucceedResponse(
      qagDetails: qagDetails,
    );
  }

  @override
  Future<QagFeedbackRepositoryResponse> giveQagResponseFeedback({
    required String qagId,
    required bool isHelpful,
  }) async {
    if (remainingSendFeedbackCount >= 0) {
      remainingSendFeedbackCount--;
      return QagFeedbackSuccessBodyWithRatioResponse(
        feedbackBody: QagFeedbackResults(
          positiveRatio: 79,
          negativeRatio: 21,
          count: 31415,
        ),
      );
    } else {
      return QagFeedbackFailedResponse();
    }
  }

  @override
  Future<GetSearchQagsRepositoryResponse> fetchSearchQags({required String? keywords}) async {
    return GetSearchQagsSucceedResponse(
      searchQags: [
        Qag(
          id: "id",
          thematique: Thematique(picto: "🚊", label: "Transports"),
          title: "title",
          username: "username",
          date: DateTime(2024, 4, 23),
          supportCount: 9,
          isSupported: true,
          isAuthor: false,
        ),
      ],
    );
  }
}

class FakeQagDetailsSuccessAndFeedbackFailureRepository extends FakeQagSuccessRepository {
  final QagDetails qagDetails;

  FakeQagDetailsSuccessAndFeedbackFailureRepository({required this.qagDetails});

  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
  }) async {
    return GetQagDetailsSucceedResponse(
      qagDetails: qagDetails,
    );
  }

  @override
  Future<QagFeedbackRepositoryResponse> giveQagResponseFeedback({
    required String qagId,
    required bool isHelpful,
  }) async {
    return QagFeedbackFailedResponse();
  }

  @override
  Future<GetSearchQagsRepositoryResponse> fetchSearchQags({required String? keywords}) async {
    return GetSearchQagsSucceedResponse(
      searchQags: [
        Qag(
          id: "id",
          thematique: Thematique(picto: "🚊", label: "Transports"),
          title: "title",
          username: "username",
          date: DateTime(2024, 4, 23),
          supportCount: 9,
          isSupported: true,
          isAuthor: false,
        ),
      ],
    );
  }
}

class FakeQagSuccessWithResponseAndFeedbackGivenRepository extends FakeQagSuccessRepository {
  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
  }) async {
    return GetQagDetailsSucceedResponse(
      qagDetails: QagDetails(
        id: qagId,
        thematique: Thematique(picto: "🚊", label: "Transports"),
        title: "Pour la retraite : comment est-ce qu'on aboutit au chiffre de 65 ans ?",
        description: "Le conseil d'orientation des retraites indique que les comptes sont à l'équilibre.",
        date: DateTime(2024, 1, 23),
        username: "CollectifSauvonsLaRetraite",
        canShare: true,
        canSupport: true,
        canDelete: true,
        isAuthor: true,
        support: QagDetailsSupport(count: 112, isSupported: true),
        response: QagDetailsResponse(
          author: "Olivier Véran",
          authorDescription: "Ministre délégué auprès de...",
          responseDate: DateTime(2024, 2, 20),
          videoUrl: "https://betagouv.github.io/agora-content/QaG-Stormtrooper-Response.mp4",
          videoWidth: 1080,
          videoHeight: 1920,
          transcription: "Blablabla",
          feedbackQuestion: 'feedbackQuestion',
          feedbackUserResponse: true,
          feedbackResults: QagFeedbackResults(
            positiveRatio: 79,
            negativeRatio: 21,
            count: 31415,
          ),
          additionalInfo: QagDetailsResponseAdditionalInfo(
            title: "Information complémentaires",
            description: "Description d'infos complémentaires",
          ),
        ),
        textResponse: null,
      ),
    );
  }

  @override
  Future<GetSearchQagsRepositoryResponse> fetchSearchQags({required String? keywords}) async {
    return GetSearchQagsSucceedResponse(
      searchQags: [
        Qag(
          id: "id",
          thematique: Thematique(picto: "🚊", label: "Transports"),
          title: "title",
          username: "username",
          date: DateTime(2024, 4, 23),
          supportCount: 9,
          isSupported: true,
          isAuthor: false,
        ),
      ],
    );
  }
}

class FakeQagSuccessWithResponseAndFeedbackNotGivenRepository extends FakeQagSuccessRepository {
  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
  }) async {
    return GetQagDetailsSucceedResponse(
      qagDetails: QagDetails(
        id: qagId,
        thematique: Thematique(picto: "🚊", label: "Transports"),
        title: "Pour la retraite : comment est-ce qu'on aboutit au chiffre de 65 ans ?",
        description: "Le conseil d'orientation des retraites indique que les comptes sont à l'équilibre.",
        date: DateTime(2024, 1, 23),
        username: "CollectifSauvonsLaRetraite",
        canShare: true,
        canSupport: true,
        canDelete: true,
        isAuthor: true,
        support: QagDetailsSupport(count: 112, isSupported: true),
        response: QagDetailsResponse(
          author: "Olivier Véran",
          authorDescription: "Ministre délégué auprès de...",
          responseDate: DateTime(2024, 2, 20),
          videoUrl: "https://betagouv.github.io/agora-content/QaG-Stormtrooper-Response.mp4",
          videoWidth: 1080,
          videoHeight: 1920,
          transcription: "Blablabla",
          feedbackQuestion: 'feedbackQuestion',
          feedbackUserResponse: null,
          feedbackResults: QagFeedbackResults(
            positiveRatio: 79,
            negativeRatio: 21,
            count: 31415,
          ),
          additionalInfo: QagDetailsResponseAdditionalInfo(
            title: "Information complémentaires",
            description: "Description d'infos complémentaires",
          ),
        ),
        textResponse: null,
      ),
    );
  }
}

class FakeQagSuccessWithTextResponse extends FakeQagSuccessRepository {
  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
  }) async {
    return GetQagDetailsSucceedResponse(
      qagDetails: QagDetails(
        id: qagId,
        thematique: Thematique(picto: "🚊", label: "Transports"),
        title: "Pour la retraite : comment est-ce qu'on aboutit au chiffre de 65 ans ?",
        description: "Le conseil d'orientation des retraites indique que les comptes sont à l'équilibre.",
        date: DateTime(2024, 1, 23),
        username: "CollectifSauvonsLaRetraite",
        canShare: true,
        canSupport: true,
        canDelete: true,
        isAuthor: true,
        support: QagDetailsSupport(count: 112, isSupported: true),
        response: null,
        textResponse: QagDetailsTextResponse(
          responseLabel: "responseLabel",
          responseText: "responseText",
          feedbackQuestion: "feedbackQuestionFromTextResponse",
          feedbackUserResponse: true,
          feedbackResults: QagFeedbackResults(
            positiveRatio: 51,
            negativeRatio: 49,
            count: 123,
          ),
        ),
      ),
    );
  }
}

class FakeQagSuccessWithVideoAndTextResponse extends FakeQagSuccessRepository {
  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
  }) async {
    return GetQagDetailsSucceedResponse(
      qagDetails: QagDetails(
        id: qagId,
        thematique: Thematique(picto: "🚊", label: "Transports"),
        title: "Pour la retraite : comment est-ce qu'on aboutit au chiffre de 65 ans ?",
        description: "Le conseil d'orientation des retraites indique que les comptes sont à l'équilibre.",
        date: DateTime(2024, 1, 23),
        username: "CollectifSauvonsLaRetraite",
        canShare: true,
        canSupport: true,
        canDelete: true,
        isAuthor: true,
        support: QagDetailsSupport(count: 112, isSupported: true),
        response: QagDetailsResponse(
          author: "Olivier Véran",
          authorDescription: "Ministre délégué auprès de...",
          responseDate: DateTime(2024, 2, 20),
          videoUrl: "https://betagouv.github.io/agora-content/QaG-Stormtrooper-Response.mp4",
          videoWidth: 1080,
          videoHeight: 1920,
          transcription: "Blablabla",
          feedbackQuestion: 'feedbackQuestion',
          feedbackUserResponse: true,
          feedbackResults: QagFeedbackResults(
            positiveRatio: 79,
            negativeRatio: 21,
            count: 31415,
          ),
          additionalInfo: QagDetailsResponseAdditionalInfo(
            title: "Information complémentaires",
            description: "Description d'infos complémentaires",
          ),
        ),
        textResponse: QagDetailsTextResponse(
          responseLabel: "responseLabel",
          responseText: "responseText",
          feedbackQuestion: "feedbackQuestionFromTextResponse",
          feedbackUserResponse: true,
          feedbackResults: QagFeedbackResults(
            positiveRatio: 51,
            negativeRatio: 49,
            count: 123,
          ),
        ),
      ),
    );
  }

  @override
  Future<GetSearchQagsRepositoryResponse> fetchSearchQags({required String? keywords}) async {
    return GetSearchQagsSucceedResponse(
      searchQags: [
        Qag(
          id: "id",
          thematique: Thematique(picto: "🚊", label: "Transports"),
          title: "title",
          username: "username",
          date: DateTime(2024, 4, 23),
          supportCount: 9,
          isSupported: true,
          isAuthor: false,
        ),
      ],
    );
  }
}

class FakeQagSuccessWithAskQuestionErrorMessageRepository extends FakeQagSuccessRepository {
  @override
  Future<GetSearchQagsRepositoryResponse> fetchSearchQags({required String? keywords}) async {
    return GetSearchQagsSucceedResponse(
      searchQags: [
        Qag(
          id: "id",
          thematique: Thematique(picto: "🚊", label: "Transports"),
          title: "title",
          username: "username",
          date: DateTime(2024, 4, 23),
          supportCount: 9,
          isSupported: true,
          isAuthor: false,
        ),
      ],
    );
  }
}

class FakeQagFailureRepository extends QagRepository {
  @override
  Future<CreateQagRepositoryResponse> createQag({
    required String title,
    required String description,
    required String author,
    required String thematiqueId,
  }) async {
    return CreateQagFailedResponse();
  }

  @override
  Future<AskQagStatusRepositoryResponse> fetchAskQagStatus() async {
    return AskQagStatusFailedResponse();
  }

  @override
  Future<GetQagsListRepositoryResponse> fetchQagList({
    required int pageNumber,
    required String? thematiqueId,
    required QagListFilter filter,
  }) async {
    return GetQagListFailedResponse();
  }

  @override
  Future<GetQagsResponseRepositoryResponse> fetchQagsResponse() async {
    return GetQagsResponseFailedResponse();
  }

  @override
  Future<GetQagsResponsePaginatedRepositoryResponse> fetchQagsResponsePaginated({
    required int pageNumber,
  }) async {
    return GetQagsResponsePaginatedFailedResponse();
  }

  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
  }) async {
    return GetQagDetailsFailedResponse();
  }

  @override
  Future<DeleteQagRepositoryResponse> deleteQag({required String qagId}) async {
    return DeleteQagFailedResponse();
  }

  @override
  Future<SupportQagRepositoryResponse> supportQag({required String qagId}) async {
    return SupportQagFailedResponse();
  }

  @override
  Future<DeleteSupportQagRepositoryResponse> deleteSupportQag({required String qagId}) async {
    return DeleteSupportQagFailedResponse();
  }

  @override
  Future<QagFeedbackRepositoryResponse> giveQagResponseFeedback({
    required String qagId,
    required bool isHelpful,
  }) async {
    return QagFeedbackFailedResponse();
  }

  @override
  Future<QagModerationListRepositoryResponse> fetchQagModerationList() async {
    return QagModerationListFailedResponse();
  }

  @override
  Future<ModerateQagRepositoryResponse> moderateQag({
    required String qagId,
    required bool isAccepted,
  }) async {
    return ModerateQagFailedResponse();
  }

  @override
  Future<QagHasSimilarRepositoryResponse> hasSimilarQag({
    required String title,
  }) async {
    return QagHasSimilarFailedResponse();
  }

  @override
  Future<QagSimilarRepositoryResponse> getSimilarQags({
    required String title,
  }) async {
    return QagSimilarFailedResponse();
  }

  @override
  Future<GetSearchQagsRepositoryResponse> fetchSearchQags({required String? keywords}) async {
    return GetSearchQagsFailedResponse();
  }
}

class FakeQagFailureUnauthorisedRepository extends FakeQagFailureRepository {
  @override
  Future<CreateQagRepositoryResponse> createQag({
    required String title,
    required String description,
    required String author,
    required String thematiqueId,
  }) async {
    return CreateQagFailedUnauthorizedResponse();
  }

  @override
  Future<GetSearchQagsRepositoryResponse> fetchSearchQags({required String? keywords}) async {
    return GetSearchQagsFailedResponse();
  }
}

class FakeQagTimeoutFailureRepository extends FakeQagFailureRepository {
  @override
  Future<GetSearchQagsRepositoryResponse> fetchSearchQags({required String? keywords}) async {
    return GetSearchQagsFailedResponse();
  }
}

class FakeQagDetailsModerateFailureRepository extends FakeQagFailureRepository {
  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
  }) async {
    return GetQagDetailsModerateFailedResponse();
  }

  @override
  Future<GetSearchQagsRepositoryResponse> fetchSearchQags({required String? keywords}) async {
    return GetSearchQagsFailedResponse();
  }
}
