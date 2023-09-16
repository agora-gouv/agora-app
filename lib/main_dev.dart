import 'package:agora/agora_app_initializer.dart';

void main() {
  AgoraInitializer.initializeApp(
    AgoraAppConfig(baseUrl: "https://agora-dev.osc-secnum-fr1.scalingo.io"),
  );
}
