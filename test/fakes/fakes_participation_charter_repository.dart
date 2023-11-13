import 'package:agora/infrastructure/participation_charter/participation_charter_repository.dart';

class FakeParticipationCharterSuccessRepository extends ParticipationCharterRepository {
  @override
  Future<GetParticipationCharterRepositoryResponse> getParticipationCharterResponse() async {
    return GetParticipationCharterSucceedResponse(extraText: 'RichText');
  }
}
