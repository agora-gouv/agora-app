import 'package:agora/infrastructure/participation_charter/participation_charter_repository.dart';

class MockParticipationCharterRepository extends ParticipationCharterDioRepository {
  MockParticipationCharterRepository({required super.httpClient, super.sentryWrapper});
}
