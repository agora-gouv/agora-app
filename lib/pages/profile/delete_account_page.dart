import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_secondary_style_view.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                                    onLongPress: () {
                                      Clipboard.setData(ClipboardData(text: ProfileStrings.deleteAccountEmail));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "${ProfileStrings.deleteAccountEmail} est copié.",
                                            style: AgoraTextStyles.light14.copyWith(color: AgoraColors.white),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Center(
                                      child: Text(
                                        ProfileStrings.deleteAccountEmail,
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
                                      Clipboard.setData(ClipboardData(text: snapshot.data));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "${snapshot.data} est copié.",
                                            style: AgoraTextStyles.light14.copyWith(color: AgoraColors.white),
                                          ),
                                        ),
                                      );
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
