import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';

class MockConsultationRepository extends ConsultationDioRepository {
  MockConsultationRepository({
    required super.httpClient,
    required super.storageClient,
    super.sentryWrapper,
  });
}
