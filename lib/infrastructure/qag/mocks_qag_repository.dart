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

    if (response is GetQagDetailsSucceedResponse && qagId == 'b68c37bf-dfcd-4f23-9d2b-0d309a0c1e55') {
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
          response: null,
          textResponse: QagDetailsTextResponse(
            responseLabel: "Réponse de l'équipe AGORA",
            responseText:
            "Bonjour, l'application est <b>déjà sortie</b> ! La preuve vous avez pu nous poser la question et on vous y répond 😂",
            feedbackQuestion: "Êtes-vous satisfait(e) de la réponse ?",
            feedbackStatus: false,
            feedbackResults: null,
          ),
        ),
      );
    }
    return response;
  }
}
