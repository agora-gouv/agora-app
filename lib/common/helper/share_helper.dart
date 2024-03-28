import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/clipboard_helper.dart';
import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

/// see https://pub.dev/packages/share_plus
class ShareHelper {
  static void shareConsultation({required BuildContext context, required String title, required String id}) {
    _share(context, shareText: ConsultationStrings.shareConsultationDeeplink.format2(title, id));
  }

  static void shareQag({required BuildContext context, required String title, required String id}) {
    _share(context, shareText: QagStrings.shareQaGDeeplink.format2(title, id));
  }

  static void shareQagAnswered({required BuildContext context, required String title, required String id}) {
    _share(context, shareText: QagStrings.shareQaGAnsweredDeeplink.format2(title, id));
  }

  static void sharePreformatted({
    required BuildContext context,
    required String data,
  }) {
    _share(context, shareText: data);
  }

  static void _share(BuildContext context, {required String shareText}) async {
    if (kIsWeb) {
      ClipboardHelper.copy(context, shareText);
    } else {
      final Size size = MediaQuery.of(context).size;
      await Share.share(
        shareText,
        sharePositionOrigin: await HelperManager.getDeviceInfoHelper().isIpad()
            ? Rect.fromLTWH(0, 0, size.width, size.height / 2)
            : null,
      );
    }
  }
}
