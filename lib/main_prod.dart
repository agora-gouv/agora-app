import 'package:agora/agora_app_initializer.dart';
import 'package:agora/firebase_options_prod.dart';

void main() {
  AgoraInitializer.initializeApp(
    AgoraAppConfig(
      baseUrl: "https://agora-prod.osc-secnum-fr1.scalingo.io",
      firebaseOptions: ProdFirebaseOptions.currentPlatform,
    ),
  );
}
