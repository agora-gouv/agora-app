import 'package:agora/agora_app_initializer.dart';

void main() {
  AgoraInitializer.initializeApp(
    AgoraAppConfig(baseUrl: "https://agora-proxy.osc-fr1.scalingo.io"),
  );
}
