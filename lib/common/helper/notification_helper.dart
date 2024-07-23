import 'package:agora/common/helper/platform_helper.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class NotificationHelper {
  static void displayNotificationWithDialog({
    required BuildContext context,
    required String? notificationTitle,
    required String? notificationDescription,
  }) {
    if (PlatformStaticHelper.isAndroid() && notificationTitle != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        showAgoraDialog(
          context: context,
          columnChildren: [
            Text(notificationTitle, style: AgoraTextStyles.light16),
            SizedBox(height: AgoraSpacings.x0_75),
            if (notificationDescription != null) ...[
              Text(notificationDescription, style: AgoraTextStyles.light16),
              SizedBox(height: AgoraSpacings.x0_75),
            ],
            AgoraButton(
              label: GenericStrings.close,
              style: AgoraButtonStyle.primary,
              onTap: () => Navigator.pop(context),
            ),
          ],
        );
      });
    }
  }
}
