import 'package:agora/domain/qag/qag_response_paginated.dart';
import 'package:agora/domain/thematique/thematique.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';

class MockQagRepository extends QagDioRepository {
  MockQagRepository({required super.httpClient, required super.crashlyticsHelper});

  @override
  Future<GetQagsResponsePaginatedRepositoryResponse> fetchQagsResponsePaginated({
    required int pageNumber,
  }) async {
    return GetQagsResponsePaginatedSucceedResponse(
      maxPage: 3,
      paginatedQagsResponse: [
        QagResponsePaginated(
          qagId: "f29c5d6f-9838-4c57-a7ec-0612145bb0c8",
          thematique: Thematique(picto: "🗳", label: "Démocratie"),
          title: "$pageNumber - Pourquoi avoir créé l’application Agora ?",
          author: "Olivier Véran",
          authorPortraitUrl: "https://betagouv.github.io/agora-content/QaG-OlivierVeran.png",
          responseDate: DateTime(2023, 6, 5),
        ),
      ],
    );
  }
}
