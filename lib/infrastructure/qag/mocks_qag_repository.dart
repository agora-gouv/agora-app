import 'package:agora/domain/qag/details/qag_details.dart';
import 'package:agora/domain/qag/qag_similar.dart';
import 'package:agora/domain/thematique/thematique.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';

class MockQagRepository extends QagDioRepository {
  MockQagRepository({required super.httpClient});

  @override
  Future<QagHasSimilarRepositoryResponse> hasSimilarQag({
    required String title,
  }) async {
    return QagHasSimilarSuccessResponse(hasSimilar: true);
  }

  @override
  Future<QagSimilarRepositoryResponse> getSimilarQags({required String title}) async {
    return QagSimilarSuccessResponse(
      similarQags: [
        QagSimilar(
          id: "d68ce1a4-9324-4df8-ae94-1408492b0634",
          thematique: Thematique(picto: "🎓", label: "Education & jeunesse"),
          title: "une question de test",
          description: "",
          username: "yoyo",
          date: DateTime(2023, 6, 23),
          supportCount: 1,
          isSupported: false,
        ),
        QagSimilar(
          id: "a8a3f83c-fce6-49b4-a6c7-d28bcc0966b7",
          thematique: Thematique(picto: "🎓", label: "Education"),
          title: "première question sur l'interface Web",
          description: "",
          username: "Imane",
          date: DateTime(2023, 6, 2),
          supportCount: 1,
          isSupported: false,
        ),
      ],
    );
  }

  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({required String qagId}) async {
    final response = await super.fetchQagDetails(qagId: qagId);

    if (response is GetQagDetailsSucceedResponse && response.qagDetails.response != null) {
      return GetQagDetailsSucceedResponse(
        qagDetails: QagDetails(
          id: response.qagDetails.id,
          thematique: response.qagDetails.thematique,
          title: response.qagDetails.title,
          description: response.qagDetails.description,
          date: response.qagDetails.date,
          username: response.qagDetails.username,
          canShare: response.qagDetails.canShare,
          canSupport: response.qagDetails.canSupport,
          canDelete: response.qagDetails.canDelete,
          isAuthor: response.qagDetails.isAuthor,
          support: response.qagDetails.support,
          response: QagDetailsResponse(
            author: response.qagDetails.response!.author,
            authorDescription: response.qagDetails.response!.authorDescription,
            responseDate: response.qagDetails.response!.responseDate,
            videoUrl: response.qagDetails.response!.videoUrl,
            videoWidth: response.qagDetails.response!.videoWidth,
            videoHeight: response.qagDetails.response!.videoHeight,
            transcription: response.qagDetails.response!.transcription,
            feedbackStatus: response.qagDetails.response!.feedbackStatus,
            feedbackResults: QagFeedbackResults(
              positiveRatio: 79,
              negativeRatio: 21,
              count: 42118,
            ),
          ),
        ),
      );
    } else {
      return response;
    }
  }
}
