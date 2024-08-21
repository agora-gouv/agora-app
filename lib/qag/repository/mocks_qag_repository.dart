import 'package:agora/qag/domain/qag_similar.dart';
import 'package:agora/thematique/domain/thematique.dart';
import 'package:agora/qag/repository/qag_repository.dart';

class MockQagRepository extends QagDioRepository {
  MockQagRepository({required super.httpClient, required super.sentryWrapper});

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
}
