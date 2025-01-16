import 'package:agora/common/log/log.dart';

enum AgoraFlavor { dev, sandbox, prod, local }

class FlavorHelper {
  static AgoraFlavor getFlavor() {
    switch (const String.fromEnvironment('app.flavor')) {
      case "Local":
        Log.debug("Flavor : Local");
        return AgoraFlavor.local;
      case "Dev":
        Log.debug("Flavor : Dev");
        return AgoraFlavor.dev;
      case "Sandbox":
        Log.debug("Flavor : Sandbox");
        return AgoraFlavor.sandbox;
      case "Prod":
        Log.debug("Flavor : Prod");
        return AgoraFlavor.prod;
      default:
        throw Exception(
          "Flavor not define error : you need to define --dart-define=app.flavor=XX when you run the app => see agora/README.md - Compile the project",
        );
    }
  }
}
