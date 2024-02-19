import 'package:agora/agora_app_initializer.dart';

void main() {
  AgoraInitializer.initializeApp(
    AgoraAppConfig(
      baseUrl: "https://sandboxapi.agora.incubateur.net", // TODO: decide and put correct URL
      environmentName: 'sandbox',
      sentryDsn: 'https://f3964b7a38e0470a8ab7a23758ceb911@sentry.incubateur.net/122',
      appIcon: "assets/launcher_icons/ic_agora_sandbox_logo.png",
    ),
  );
}
