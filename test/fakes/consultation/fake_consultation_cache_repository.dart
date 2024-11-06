import 'package:agora/consultation/domain/consultations_error_type.dart';
import 'package:agora/consultation/repository/consultation_cache_repository.dart';
import 'package:agora/consultation/repository/consultation_responses.dart';

class FakeConsultationCacheSuccessRepository extends ConsultationCacheRepository {
  FakeConsultationCacheSuccessRepository({required super.consultationRepository});

  @override
  bool get isCacheSuccess => false;
}

class FakeConsultationCacheSuccessWithFinishedConsultationEmptyRepository
    extends FakeConsultationCacheSuccessRepository {
  FakeConsultationCacheSuccessWithFinishedConsultationEmptyRepository({required super.consultationRepository});
}

class FakeConsultationCacheFailureRepository extends ConsultationCacheRepository {
  FakeConsultationCacheFailureRepository({required super.consultationRepository});

  @override
  Future<GetConsultationsRepositoryResponse> fetchConsultations() async {
    return GetConsultationsFailedResponse();
  }
}

class FakeConsultationCacheTimeoutFailureRepository extends FakeConsultationCacheFailureRepository {
  FakeConsultationCacheTimeoutFailureRepository({required super.consultationRepository});

  @override
  Future<GetConsultationsRepositoryResponse> fetchConsultations() async {
    return GetConsultationsFailedResponse(errorType: ConsultationsErrorType.timeout);
  }
}
