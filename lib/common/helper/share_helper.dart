import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  static void shareConsultation({required String title, required String id}) {
    Share.share(ConsultationStrings.shareDeeplinkText.format2(title, id));
  }

  static void shareQag({required String title, required String id}) {
    Share.share(QagStrings.shareDeeplinkText.format2(title, id));
  }
}
