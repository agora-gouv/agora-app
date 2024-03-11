import 'package:agora/agora_app_initializer.dart';
import 'package:agora/design/style/agora_colors.dart';

void main() {
  AgoraInitializer.initializeApp(
    AgoraAppConfig(
      baseUrl: "https://api.agora.beta.gouv.fr",
      environmentName: 'prod',
      sentryDsn: 'https://f3964b7a38e0470a8ab7a23758ceb911@sentry.incubateur.net/122',
      appIcon: "assets/launcher_icons/ic_agora_dev_logo.png",
      appBarColor: AgoraColors.primaryBlue,
    ),
  );
}
