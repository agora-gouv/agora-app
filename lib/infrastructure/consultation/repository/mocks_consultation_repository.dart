import 'package:agora/domain/consultation/consultation_finished_paginated.dart';
import 'package:agora/domain/thematique/thematique.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';

class MockConsultationRepository extends ConsultationDioRepository {
  MockConsultationRepository({required super.httpClient, required super.crashlyticsHelper});

  @override
  Future<GetConsultationsFinishedPaginatedRepositoryResponse> fetchConsultationsFinishedPaginated({
    required int pageNumber,
  }) async {
    return GetConsultationsFinishedPaginatedSucceedResponse(
      maxPage: 3,
      finishedConsultationsPaginated: [
        ConsultationFinishedPaginated(
          id: "4ef06e4d-c1fc-4fe6-b924-c004856bc5bd",
          title: "Le petit déjeuner, le rituel sacré de la matinée.",
          coverUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/eb/Breakfast2.jpg/1024px-Breakfast2.jpg",
          thematique: Thematique(label: "Agriculture & alimentation", picto: "🌾"),
          step: 2,
        ),
      ],
    );
  }
}
