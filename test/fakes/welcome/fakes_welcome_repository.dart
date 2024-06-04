import 'package:agora/welcome/domain/welcome_a_la_une.dart';
import 'package:agora/welcome/repository/welcome_repository.dart';

class FakeWelcomeSuccessRepository extends WelcomeRepository {
  @override
  Future<WelcomeALaUne?> getWelcomeALaUne() {
    return Future.value(WelcomeALaUne(description: "description", actionText: "actionText", routeName: "routeName"));
  }
}

class FakeWelcomeFailureRepository extends WelcomeRepository {
  @override
  Future<WelcomeALaUne?> getWelcomeALaUne() {
    return Future.value(null);
  }
}
