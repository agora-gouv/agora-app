import 'package:agora/referentiel/repository/referentiel_repository.dart';
import 'package:agora/referentiel/territoire.dart';

class ReferentielCacheRepository {
  final ReferentielRepository referentielRepository;

  ReferentielCacheRepository({required this.referentielRepository, this.referentielData = const []});

  List<Territoire> referentielData;
  DateTime? lastUpdate;

  static const Duration CACHE_MAX_AGE = Duration(minutes: 30);

  bool get isCacheSuccess => referentielData.isNotEmpty && isCacheFresh;

  bool get isCacheFresh => lastUpdate != null && DateTime.now().isBefore(lastUpdate!.add(CACHE_MAX_AGE));

  Future<List<Territoire>> fetchReferentielRegionsEtDepartements() async {
    if (isCacheSuccess) {
      return referentielData;
    }
    referentielData = await referentielRepository.fetchReferentielRegionsEtDepartements();
    lastUpdate = DateTime.now();
    return referentielData;
  }
}
