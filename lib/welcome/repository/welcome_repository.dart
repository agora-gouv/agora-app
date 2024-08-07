import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/log/sentry_wrapper.dart';
import 'package:agora/welcome/domain/welcome_a_la_une.dart';

abstract class WelcomeRepository {
  Future<WelcomeALaUne?> getWelcomeALaUne();
}

class WelcomeDioRepository extends WelcomeRepository {
  final AgoraDioHttpClient httpClient;
  final SentryWrapper sentryWrapper;

  WelcomeALaUne? _welcomeALaUne;

  WelcomeDioRepository({
    required this.httpClient,
    required this.sentryWrapper,
  });

  @override
  Future<WelcomeALaUne?> getWelcomeALaUne() async {
    if (_welcomeALaUne != null) {
      return _welcomeALaUne;
    } else {
      final fromNetwork = await _fetchOnlineWelcomeALaUne();
      _welcomeALaUne = fromNetwork;
      return fromNetwork;
    }
  }

  Future<WelcomeALaUne?> _fetchOnlineWelcomeALaUne() async {
    const uri = '/welcome_page/last_news';
    try {
      final response = await httpClient.get(uri);
      return WelcomeALaUne(
        description: response.data['description'] as String,
        actionText: response.data['callToActionText'] as String,
        routeName: response.data['routeName'] as String,
        routeArgument: response.data['routeArgument'] as String?,
      );
    } catch (exception, stacktrace) {
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
    }
    return null;
  }
}
