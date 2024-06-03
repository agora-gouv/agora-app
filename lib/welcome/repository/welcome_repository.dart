import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/infrastructure/errors/sentry_wrapper.dart';
import 'package:agora/welcome/domain/welcome_a_la_une.dart';

abstract class WelcomeRepository {
  Future<WelcomeALaUne?> getWelcomeALaUne();
}

class WelcomeDioRepository extends WelcomeRepository {
  final AgoraDioHttpClient httpClient;
  final SentryWrapper? sentryWrapper;
  final Duration minimalSendingTime;

  WelcomeDioRepository({
    required this.httpClient,
    this.minimalSendingTime = const Duration(seconds: 2),
    this.sentryWrapper,
  });

  @override
  Future<WelcomeALaUne?> getWelcomeALaUne() async {
    final timer = Future.delayed(minimalSendingTime);
    try {
      final response = await httpClient.get('/welcome_page/last_news');
      await timer;
      return WelcomeALaUne(
        description: response.data['description'] as String,
        actionText: response.data['callToActionText'] as String,
        routeName: response.data['routeName'] as String,
        routeArgument: response.data['routeArgument'] as String?,
      );
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
      return WelcomeALaUne(
        description:
            'Une nouvelle consultation sur la planification écologique est lancée en région Centre-Val-de-Loire !',
        actionText: 'rendez-vous dans la section Consultations citoyennes',
        routeName: '/consultationsPage',
        routeArgument: null,
      );
    }
    // return null;
  }
}
