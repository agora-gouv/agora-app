import 'package:agora/common/helper/clipboard_helper.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_secondary_style_view.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class DeleteAccountPage extends StatelessWidget {
  static const routeName = "/deleteAccountPage";

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      child: AgoraSingleScrollView(
        child: AgoraSecondaryStyleView(
          title: AgoraRichText(
            policeStyle: AgoraRichTextPoliceStyle.toolbar,
            items: [
              AgoraRichTextTextItem(
                text: DemographicStrings.delete,
                style: AgoraRichTextItemStyle.bold,
              ),
              AgoraRichTextSpaceItem(),
              AgoraRichTextTextItem(
                text: DemographicStrings.myAccount,
                style: AgoraRichTextItemStyle.regular,
              ),
            ],
          ),
          child: FutureBuilder<String?>(
            future: StorageManager.getLoginStorageClient().getUserId(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: ProfileStrings.deleteAccount1,
                              style: AgoraTextStyles.light16,
                            ),
                            WidgetSpan(
                              child: Column(
                                children: [
                                  SizedBox(height: AgoraSpacings.base),
                                  GestureDetector(
                                    onLongPress: () => ClipboardHelper.copy(context, GenericStrings.mailSupport),
                                    child: Center(
                                      child: Text(
                                        GenericStrings.mailSupport,
                                        style: AgoraTextStyles.medium16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: AgoraSpacings.base),
                                ],
                              ),
                            ),
                            TextSpan(
                              text: ProfileStrings.deleteAccount2,
                              style: AgoraTextStyles.light16,
                            ),
                            WidgetSpan(
                              child: Column(
                                children: [
                                  SizedBox(height: AgoraSpacings.base),
                                  GestureDetector(
                                    onLongPress: () {
                                      final userId = snapshot.data;
                                      if (userId != null) {
                                        ClipboardHelper.copy(context, userId);
                                      }
                                    },
                                    child: Center(
                                      child: Text(
                                        snapshot.data ?? "",
                                        style: AgoraTextStyles.medium16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: AgoraSpacings.base),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
