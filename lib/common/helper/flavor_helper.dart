import 'package:agora/common/log/log.dart';

enum AgoraFlavor { dev, prod }

class FlavorHelper {
  static AgoraFlavor getFlavor() {
    const environment = String.fromEnvironment('app.flavor');
    switch (environment) {
      case "Dev":
        Log.d("Flavor : Dev");
        return AgoraFlavor.dev;
      case "Prod":
        Log.d("Flavor : Prod");
        return AgoraFlavor.prod;
      default:
        throw Exception(
          "Flavor not define error : you need to define --dart-define=app.flavor=Dev when you run the app",
        );
    }
  }
}
