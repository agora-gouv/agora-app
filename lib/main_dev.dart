import 'package:agora/agora_app_initializer.dart';

void main() {
  AgoraInitializer.initializeApp(
    AgoraAppConfig(baseUrl: "https://app.agora.incubateur.net"),
  );
}
