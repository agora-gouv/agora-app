import 'package:agora/agora_app_initializer.dart';

void main() {
  AgoraInitializer.initializeApp(
    AgoraAppConfig(baseUrl: "https://agora-prod.osc-secnum-fr1.scalingo.io"),
  );
}
