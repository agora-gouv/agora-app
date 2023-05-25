import 'package:agora/domain/qag/moderation/qag_moderation_list.dart';
import 'package:agora/domain/qag/qag_paginated.dart';
import 'package:agora/domain/qag/qag_paginated_filter.dart';
import 'package:agora/domain/thematique/thematique.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';

class MockQagRepository extends QagDioRepository {
  MockQagRepository({required super.httpClient});

  @override
  Future<ModerateQagRepositoryResponse> moderateQag({
    required String qagId,
    required bool isAccepted,
  }) async {
    return ModerateQagSuccessResponse();
  }

  @override
  Future<QagModerationListRepositoryResponse> fetchQagModerationList() async {
    return QagModerationListSuccessResponse(
      qagModerationList: QagModerationList(
        totalNumber: 100,
        qagsToModeration: [
          QagModeration(
            id: "996436ca-ee69-11ed-a05b-0242ac120003",
            thematique: Thematique(picto: "💼", label: "Travail & emploi"),
            title:
                "On parle beaucoup de l’intelligence artificielle… vous comptez faire quoi pour les emplois qu’elle risque de remplacer ?",
            description:
                "ChatGPT est arrivé avec fureur et on voit déjà combien un certain nombre de tâches et de métier pourraient être rapidement remplacés par l’intelligence artificielle… Faut-il interdire ChatGPT? Faut-il ré-orienter les travailleurs concernés ?",
            username: "Nina",
            date: DateTime(2023, 6, 23),
            supportCount: 22,
            isSupported: true,
          ),
          QagModeration(
            id: "1731a370-ee6b-11ed-a05b-0242ac120003",
            thematique: Thematique(picto: "🎓", label: "Education"),
            title: "Ma question, c’est pourquoi on n’arrive pas, dans ce pays, à recruter davantage de professeurs ?!",
            description:
                "Il y a bien sûr la question de la rémunération, mais au-delà de ça, c’est aussi la position sociale et la reconnaissance même du professeur qui semble avoir “baissé” ces 20 dernières années. Comment remédier à cela ?",
            username: "Agny",
            date: DateTime(2023, 6, 2),
            supportCount: 2,
            isSupported: false,
          ),
        ],
      ),
    );
  }

  @override
  Future<GetQagsPaginatedRepositoryResponse> fetchQagsPaginated({
    required int pageNumber,
    required String? thematiqueId,
    required QagPaginatedFilter filter,
  }) async {
    switch (filter) {
      case QagPaginatedFilter.popular:
        switch (pageNumber) {
          case 1:
            return getQagsPaginatedSucceedResponse("popular1", thematiqueId);
          case 2:
            return getQagsPaginatedSucceedResponse("popular2", thematiqueId);
          case 3:
            return getQagsPaginatedSucceedResponse("popular3", thematiqueId);
          case 4:
            return getQagsPaginatedSucceedResponse("popular4", thematiqueId);
          case 5:
            return getQagsPaginatedSucceedResponse("popular5", thematiqueId);
          case 6:
            return getQagsPaginatedSucceedResponse("popular6", thematiqueId);
          case 7:
            return getQagsPaginatedSucceedResponse("popular7", thematiqueId);
          default:
            return getQagsPaginatedSucceedResponse("popular8", thematiqueId);
        }
      case QagPaginatedFilter.latest:
        switch (pageNumber) {
          case 1:
            return getQagsPaginatedSucceedResponse("latest1", thematiqueId);
          case 2:
            return getQagsPaginatedSucceedResponse("latest2", thematiqueId);
          case 3:
            return getQagsPaginatedSucceedResponse("latest3", thematiqueId);
          case 4:
            return getQagsPaginatedSucceedResponse("latest4", thematiqueId);
          case 5:
            return getQagsPaginatedSucceedResponse("latest5", thematiqueId);
          case 6:
            return getQagsPaginatedSucceedResponse("latest6", thematiqueId);
          case 7:
            return getQagsPaginatedSucceedResponse("latest7", thematiqueId);
          default:
            return getQagsPaginatedSucceedResponse("latest8", thematiqueId);
        }
      case QagPaginatedFilter.supporting:
        switch (pageNumber) {
          case 1:
            return getQagsPaginatedSucceedResponse("supporting1", thematiqueId);
          case 2:
            return getQagsPaginatedSucceedResponse("supporting2", thematiqueId);
          case 3:
            return getQagsPaginatedSucceedResponse("supporting3", thematiqueId);
          case 4:
            return getQagsPaginatedSucceedResponse("supporting4", thematiqueId);
          case 5:
            return getQagsPaginatedSucceedResponse("supporting5", thematiqueId);
          case 6:
            return getQagsPaginatedSucceedResponse("supporting6", thematiqueId);
          case 7:
            return getQagsPaginatedSucceedResponse("supporting7", thematiqueId);
          default:
            return getQagsPaginatedSucceedResponse("supporting8", thematiqueId);
        }
    }
  }

  GetQagsPaginatedSucceedResponse getQagsPaginatedSucceedResponse(String name, String? thematiqueId) {
    return GetQagsPaginatedSucceedResponse(
      maxPage: 8,
      paginatedQags: [
        QagPaginated(
          id: "id_$name",
          thematique: _getThematique(thematiqueId),
          title: "title_$name",
          username: "username_$name",
          date: DateTime(2024, 2, 23),
          supportCount: 8,
          isSupported: false,
        ),
      ],
    );
  }

  Thematique _getThematique(String? thematiqueId) {
    switch (thematiqueId) {
      case "1f3dbdc6-cff7-4d6a-88b5-c5ec84c55d15":
        return Thematique(picto: "💼", label: "Travail & emploi");
      case "bb051bf2-644b-47b6-9488-7759fa727dc0":
        return Thematique(picto: "🌱", label: "Transition écologique");
      case "a4bb4b27-3271-4278-83c9-79ac3eee843a":
        return Thematique(picto: "🩺", label: "Santé");
      case "c97c3afd-1940-4b6d-950a-734b885ee5cb":
        return Thematique(picto: "📈", label: "Economie");
      case "5b9180e6-3e43-4c63-bcb5-4eab621fc016":
        return Thematique(picto: "🎓", label: "Education");
      case "8e200137-df3b-4bde-9981-b39a3d326da7":
        return Thematique(picto: "🌏", label: "International");
      case "0f644115-08f3-46ff-b776-51f19c65fdd1":
        return Thematique(picto: "🚊", label: "Transports");
      case "b276606e-f251-454e-9a73-9b70a6f30bfd":
        return Thematique(picto: "🚔", label: "Sécurité");
      case "30671310-ee62-11ed-a05b-0242ac120003":
        return Thematique(picto: "🗳", label: "Démocratie");
      default:
        return Thematique(picto: "📦", label: "Autre");
    }
  }
}
