import 'package:agora/common/log/log.dart';

enum AgoraFlavor { dev, prod }

class FlavorHelper {
  static AgoraFlavor getFlavor() {
    switch (const String.fromEnvironment('app.flavor')) {
      case "Dev":
        Log.d("Flavor : Dev");
        return AgoraFlavor.dev;
      case "Prod":
        Log.d("Flavor : Prod");
        return AgoraFlavor.prod;
      default:
        throw Exception(
          "Flavor not define error : you need to define --dart-define=app.flavor=XX when you run the app => see docs/1_README.md - Compile the project",
        );
    }
  }
}
