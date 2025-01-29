import 'package:agora/consultation/repository/consultation_repository.dart';

class MockConsultationRepository extends ConsultationDioRepository {
  MockConsultationRepository({
    required super.httpClient,
    required super.storageClient,
    required super.sentryWrapper,
    required super.mapper,
  });
}
