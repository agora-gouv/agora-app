import 'package:agora/concertation/repository/concertation_repository.dart';
import 'package:agora/consultation/domain/consultation.dart';

class ConcertationCacheRepository {
  final ConcertationRepository concertationRepository;

  ConcertationCacheRepository({required this.concertationRepository, this.concertationData = const []});

  List<Concertation> concertationData;
  DateTime? lastUpdate;

  static const Duration CACHE_MAX_AGE = Duration(minutes: 5);

  bool get isCacheSuccess => concertationData.isNotEmpty && isCacheFresh;

  bool get isCacheFresh => lastUpdate != null && DateTime.now().isBefore(lastUpdate!.add(CACHE_MAX_AGE));

  Future<List<Concertation>> fetchConcertations() async {
    if (isCacheSuccess) {
      return concertationData;
    }
    concertationData = await concertationRepository.fetchConcertations();
    lastUpdate = DateTime.now();
    return concertationData;
  }
}
