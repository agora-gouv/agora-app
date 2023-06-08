import 'package:agora/agora_app_initializer.dart';
import 'package:agora/firebase_options_dev.dart';

void main() {
  AgoraInitializer.initializeApp(
    AgoraAppConfig(
      baseUrl: "https://agora-dev.osc-secnum-fr1.scalingo.io",
      firebaseOptions: DevFirebaseOptions.currentPlatform,
    ),
  );
}
