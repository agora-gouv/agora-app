import 'package:agora/consultation/repository/consultation_repository.dart';
import 'package:agora/consultation/repository/consultation_responses.dart';

class ConsultationCacheRepository {
  final ConsultationRepository consultationRepository;

  ConsultationCacheRepository({required this.consultationRepository});

  GetConsultationsRepositoryResponse? consultationsData;
  DateTime? lastUpdate;

  static const Duration CACHE_MAX_AGE = Duration(minutes: 5);

  bool get isCacheSuccess => consultationsData is GetConsultationsSucceedResponse && isCacheFresh;

  bool get isCacheFresh => lastUpdate != null && DateTime.now().isBefore(lastUpdate!.add(CACHE_MAX_AGE));

  Future<GetConsultationsRepositoryResponse> fetchConsultations() async {
    if (isCacheSuccess) {
      return consultationsData!;
    }
    consultationsData = await consultationRepository.fetchConsultations();
    lastUpdate = DateTime.now();

    return consultationsData!;
  }
}
