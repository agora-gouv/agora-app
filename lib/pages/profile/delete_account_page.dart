import 'package:agora/common/helper/clipboard_helper.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_secondary_style_view.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeleteAccountPage extends StatelessWidget {
  static const routeName = "/deleteAccountPage";

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      child: AgoraSecondaryStyleView(
        pageLabel: DemographicStrings.delete + DemographicStrings.myAccount,
        scrollType: AgoraSecondaryScrollType.custom,
        title: AgoraRichText(
          policeStyle: AgoraRichTextPoliceStyle.toolbar,
          items: [
            AgoraRichTextItem(
              text: DemographicStrings.delete,
              style: AgoraRichTextItemStyle.bold,
            ),
            AgoraRichTextItem(
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
              final userId = snapshot.data;
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(height: AgoraSpacings.base),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(width: AgoraSpacings.x0_75),
                                    Expanded(
                                      child: Text(
                                        GenericStrings.mailSupport,
                                        style: AgoraTextStyles.medium16,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    SizedBox(width: AgoraSpacings.x0_75),
                                    buildCopyButton(
                                      semanticsLabel: SemanticsStrings.copyMail,
                                      onTap: () => _copySupportEmail(context),
                                    ),
                                  ],
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(height: AgoraSpacings.base),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(width: AgoraSpacings.x0_75),
                                    Expanded(
                                      child: Text(
                                        snapshot.data ?? "",
                                        style: AgoraTextStyles.medium16,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    SizedBox(width: AgoraSpacings.x0_75),
                                    buildCopyButton(
                                      semanticsLabel: SemanticsStrings.copyCode,
                                      onTap: () => _copyUserId(userId, context),
                                    ),
                                  ],
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
    );
  }

  Semantics buildCopyButton({required String semanticsLabel, required VoidCallback onTap}) {
    return Semantics(
      button: true,
      label: semanticsLabel,
      child: AgoraRoundedCard(
        cardColor: AgoraColors.transparent,
        cornerRadius: AgoraCorners.rounded50,
        onTap: () => onTap(),
        padding: const EdgeInsets.all(AgoraSpacings.x0_5),
        child: SvgPicture.asset("assets/ic_copy.svg", excludeFromSemantics: true),
      ),
    );
  }

  void _copySupportEmail(BuildContext context) {
    ClipboardHelper.copy(context, GenericStrings.mailSupport);
  }

  void _copyUserId(String? userId, BuildContext context) {
    if (userId != null) {
      ClipboardHelper.copy(context, userId);
    }
  }
}
