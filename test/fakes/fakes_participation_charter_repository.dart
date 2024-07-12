import 'package:agora/profil/participation_charter/repository/participation_charter_repository.dart';

class FakeParticipationCharterSuccessRepository extends ParticipationCharterRepository {
  @override
  Future<GetParticipationCharterRepositoryResponse> getParticipationCharterResponse() async {
    return GetParticipationCharterSucceedResponse(extraText: 'RichText');
  }
}
