import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/profil/app_feedback/domain/device_informations.dart';
import 'package:agora/profil/app_feedback/domain/app_feedback.dart';
import 'package:agora/common/log/sentry_wrapper.dart';

abstract class AppFeedbackRepository {
  Future<bool> sendFeedback(AppFeedback feedback, DeviceInformation deviceInformations);
}

class AppFeedbackDioRepository extends AppFeedbackRepository {
  final AgoraDioHttpClient httpClient;
  final SentryWrapper sentryWrapper;
  final Duration minimalSendingTime;

  AppFeedbackDioRepository({
    required this.httpClient,
    this.minimalSendingTime = const Duration(seconds: 2),
    required this.sentryWrapper,
  });

  @override
  Future<bool> sendFeedback(AppFeedback feedback, DeviceInformation deviceInformations) async {
    final timer = Future.delayed(minimalSendingTime);
    const uri = '/feedback';
    try {
      final response = await httpClient.post(
        uri,
        data: {
          "type": switch (feedback.type) {
            AppFeedbackType.bug => "bug",
            AppFeedbackType.comment => "comment",
            AppFeedbackType.feature => "feature",
          },
          "description": feedback.description,
          "deviceInfo": feedback.type == AppFeedbackType.bug
              ? {
                  "model": deviceInformations.model,
                  "osVersion": deviceInformations.osVersion,
                  "appVersion": deviceInformations.appVersion,
                }
              : null,
        },
      );
      await timer;
      return response.statusCode == 200;
    } catch (exception, stacktrace) {
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
      await timer;
      return false;
    }
  }
}
