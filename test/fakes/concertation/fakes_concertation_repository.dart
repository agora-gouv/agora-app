import 'package:agora/concertation/repository/concertation_cache_repository.dart';
import 'package:agora/concertation/repository/concertation_repository.dart';
import 'package:agora/consultation/domain/consultation.dart';
import 'package:agora/thematique/domain/thematique.dart';

class FakesConcertationRepository extends ConcertationRepository {
  @override
  Future<List<Concertation>> fetchConcertations() async {
    return [
      Concertation(
        id: "concertationId1",
        slug: "concertationId1",
        title: "Développer le covoiturage",
        coverUrl: "coverUrl1",
        externalLink: "externalLink1",
        thematique: Thematique(label: "Transports", picto: "🚊"),
        updateDate: DateTime(2023, 3, 21),
        label: "Plus que 3 jours",
        territoire: "Paris",
      ),
    ];
  }
}

class FakesConcertationCacheRepository extends ConcertationCacheRepository {
  FakesConcertationCacheRepository({required super.concertationRepository});
}
