import 'package:agora/qag/repository/qag_cache_repository.dart';

class FakeQagCacheSuccessRepository extends QagCacheRepository {
  FakeQagCacheSuccessRepository({required super.qagRepository});

  @override
  bool get isCacheSuccess => false;
}

class FakeQagCacheDetailsSuccessRepository extends FakeQagCacheSuccessRepository {
  FakeQagCacheDetailsSuccessRepository({required super.qagRepository});
}

class FakeQagCacheDetailsSuccessAndFeedbackFailureRepository extends FakeQagCacheSuccessRepository {
  FakeQagCacheDetailsSuccessAndFeedbackFailureRepository({required super.qagRepository});
}

class FakeQagCacheSuccessWithResponseAndFeedbackGivenRepository extends FakeQagCacheSuccessRepository {
  FakeQagCacheSuccessWithResponseAndFeedbackGivenRepository({required super.qagRepository});
}

class FakeQagCacheSuccessWithResponseAndFeedbackNotGivenRepository extends FakeQagCacheSuccessRepository {
  FakeQagCacheSuccessWithResponseAndFeedbackNotGivenRepository({required super.qagRepository});
}

class FakeQagCacheSuccessWithTextResponse extends FakeQagCacheSuccessRepository {
  FakeQagCacheSuccessWithTextResponse({required super.qagRepository});
}

class FakeQagCacheSuccessWithVideoAndTextResponse extends FakeQagCacheSuccessRepository {
  FakeQagCacheSuccessWithVideoAndTextResponse({required super.qagRepository});
}

class FakeQagCacheSuccessWithAskQuestionErrorMessageRepository extends FakeQagCacheSuccessRepository {
  FakeQagCacheSuccessWithAskQuestionErrorMessageRepository({required super.qagRepository});
}

class FakeQagCacheFailureRepository extends QagCacheRepository {
  FakeQagCacheFailureRepository({required super.qagRepository});
}

class FakeQagCacheFailureUnauthorisedRepository extends FakeQagCacheFailureRepository {
  FakeQagCacheFailureUnauthorisedRepository({required super.qagRepository});
}

class FakeQagCacheTimeoutFailureRepository extends FakeQagCacheFailureRepository {
  FakeQagCacheTimeoutFailureRepository({required super.qagRepository});
}

class FakeQagCacheDetailsModerateFailureRepository extends FakeQagCacheFailureRepository {
  FakeQagCacheDetailsModerateFailureRepository({required super.qagRepository});
}
