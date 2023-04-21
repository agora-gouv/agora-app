import 'package:agora/domain/qag/details/qag_details.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';

// TODO suppress when debouncing is done
class MockQagSuccessRepository extends QagDioRepository {
  MockQagSuccessRepository({required super.httpClient});

  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
    required String deviceId,
  }) async {
    return GetQagDetailsSucceedResponse(
      qagDetails: QagDetails(
        id: qagId,
        thematiqueId: "1f3dbdc6-cff7-4d6a-88b5-c5ec84c55d15",
        title: "Pour la retraite : comment est-ce qu’on aboutit au chiffre de 65 ans ?",
        description:
            "Le conseil d’orientation des retraites indique que les comptes sont à l’équilibre. A chaque nouveau président l’âge maximal change, qui choisit l’âge de 65 ans et pourquoi ? Je n’ai trouvé aucune justification concrète.",
        date: DateTime(2024, 1, 23),
        username: "CollectifSauvonsLaRetraite",
        support: null,
        //QagDetailsSupport(count: 112, isSupported: true),
        response: QagDetailsResponse(
          author: "Olivier Véran",
          authorDescription:
              "Ministre délégué auprès de la Première ministre, chargé du Renouveau démocratique, porte-parole du Gouvernement",
          responseDate: DateTime(2024, 2, 20),
          videoUrl: "https://betagouv.github.io/agora-content/QaG-Stormtrooper-Response.mp4",
          transcription:
              "Merci CollectifSauvonsLaRetraite pour ta question ! Vous avez raison, le gouvernement se doit d’être à l’écoute des Français et de leurs craintes. Les récents incidents liés à la pratique de la chasse ne sont pas acceptables et nous avons dors-et-déjà mis en oeuvre plusieurs lois d’encadrement de cette pratique pour la sécurité de nos concitoyens, notamment sur sa pratique dans des zones proches d’habitations. Mais gouverner, c’est également savoir soutenir et protéger les pratiques et traditions de nos ...",
          feedbackStatus: true,
        ),
      ),
    );
  }

  @override
  Future<SupportQagRepositoryResponse> supportQag({required String qagId, required String deviceId}) async {
    return SupportQagSucceedResponse();
  }

  @override
  Future<DeleteSupportQagRepositoryResponse> deleteSupportQag({required String qagId, required String deviceId}) async {
    return DeleteSupportQagSucceedResponse();
  }
}
