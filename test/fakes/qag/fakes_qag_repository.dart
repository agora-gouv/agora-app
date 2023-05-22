import 'package:agora/domain/qag/details/qag_details.dart';
import 'package:agora/domain/qag/qag.dart';
import 'package:agora/domain/qag/qag_paginated.dart';
import 'package:agora/domain/qag/qag_paginated_filter.dart';
import 'package:agora/domain/qag/qag_response.dart';
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
    return CreateQagSucceedResponse();
  }

  @override
  Future<GetQagsRepositoryResponse> fetchQags({
    required String? thematiqueId,
  }) async {
    return GetQagsSucceedResponse(
      qagResponses: [
        QagResponse(
          qagId: "qagId",
          thematique: Thematique(picto: "🚊", label: "Transports"),
          title: "Pour la retraite : comment est-ce qu’on aboutit au chiffre de 65 ans ?",
          author: "author",
          authorPortraitUrl: "authorPortraitUrl",
          responseDate: DateTime(2024, 1, 23),
        ),
      ],
      qagPopular: [
        Qag(
          id: "id1",
          thematique: Thematique(picto: "🚊", label: "Transports"),
          title: "title1",
          username: "username1",
          date: DateTime(2024, 1, 23),
          supportCount: 7,
          isSupported: true,
        ),
      ],
      qagLatest: [
        Qag(
          id: "id2",
          thematique: Thematique(picto: "🚊", label: "Transports"),
          title: "title2",
          username: "username2",
          date: DateTime(2024, 2, 23),
          supportCount: 8,
          isSupported: false,
        ),
      ],
      qagSupporting: [
        Qag(
          id: "id3",
          thematique: Thematique(picto: "🚊", label: "Transports"),
          title: "title3",
          username: "username3",
          date: DateTime(2024, 3, 23),
          supportCount: 9,
          isSupported: true,
        ),
      ],
    );
  }

  @override
  Future<GetQagsPaginatedRepositoryResponse> fetchQagsPaginated({
    required int pageNumber,
    required String? thematiqueId,
    required QagPaginatedFilter filter,
  }) async {
    switch (pageNumber) {
      case 1:
        return GetQagsPaginatedSucceedResponse(
          maxPage: 3,
          paginatedQags: [
            QagPaginated(
              id: "id1",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: DateTime(2024, 2, 23),
              supportCount: 8,
              isSupported: false,
            ),
          ],
        );
      case 2:
        return GetQagsPaginatedSucceedResponse(
          maxPage: 3,
          paginatedQags: [
            QagPaginated(
              id: "id2",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "title2",
              username: "username2",
              date: DateTime(2024, 3, 23),
              supportCount: 9,
              isSupported: true,
            ),
          ],
        );
      default:
        return GetQagsPaginatedSucceedResponse(
          maxPage: 3,
          paginatedQags: [
            QagPaginated(
              id: "id3",
              thematique: Thematique(picto: "🚊", label: "Transports"),
              title: "title3",
              username: "username3",
              date: DateTime(2024, 4, 23),
              supportCount: 9,
              isSupported: true,
            ),
          ],
        );
    }
  }

  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
  }) async {
    return GetQagDetailsSucceedResponse(
      qagDetails: QagDetails(
        id: qagId,
        thematique: Thematique(picto: "🚊", label: "Transports"),
        title: "Pour la retraite : comment est-ce qu’on aboutit au chiffre de 65 ans ?",
        description: "Le conseil d’orientation des retraites indique que les comptes sont à l’équilibre.",
        date: DateTime(2024, 1, 23),
        username: "CollectifSauvonsLaRetraite",
        support: QagDetailsSupport(count: 112, isSupported: true),
        response: null,
      ),
    );
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
    return QagFeedbackSuccessResponse();
  }
}

class FakeQagSuccessWithSupportNullAndResponseNotNullRepository extends FakeQagSuccessRepository {
  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
  }) async {
    return GetQagDetailsSucceedResponse(
      qagDetails: QagDetails(
        id: qagId,
        thematique: Thematique(picto: "🚊", label: "Transports"),
        title: "Pour la retraite : comment est-ce qu’on aboutit au chiffre de 65 ans ?",
        description: "Le conseil d’orientation des retraites indique que les comptes sont à l’équilibre.",
        date: DateTime(2024, 1, 23),
        username: "CollectifSauvonsLaRetraite",
        support: null,
        response: QagDetailsResponse(
          author: "Olivier Véran",
          authorDescription: "Ministre délégué auprès de...",
          responseDate: DateTime(2024, 2, 20),
          videoUrl: "https://betagouv.github.io/agora-content/QaG-Stormtrooper-Response.mp4",
          transcription: "Blablabla",
          feedbackStatus: true,
        ),
      ),
    );
  }

  @override
  Future<SupportQagRepositoryResponse> supportQag({required String qagId}) async {
    return SupportQagSucceedResponse();
  }

  @override
  Future<DeleteSupportQagRepositoryResponse> deleteSupportQag({required String qagId}) async {
    return DeleteSupportQagSucceedResponse();
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
  Future<GetQagsRepositoryResponse> fetchQags({
    required String? thematiqueId,
  }) async {
    return GetQagsFailedResponse();
  }

  @override
  Future<GetQagsPaginatedRepositoryResponse> fetchQagsPaginated({
    required int pageNumber,
    required String? thematiqueId,
    required QagPaginatedFilter filter,
  }) async {
    return GetQagsPaginatedFailedResponse();
  }

  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
  }) async {
    return GetQagDetailsFailedResponse();
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
}
