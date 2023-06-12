import 'package:url_launcher/url_launcher.dart';

class LaunchUrlHelper {
  static void launch(String? url) async {
    if (url != null) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      }
    }
  }
}
