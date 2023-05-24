import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_secondary_style_view.dart';
import 'package:agora/design/custom_view/agora_title_rich_text.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  static const routeName = "/privacyPolicyPage";

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      child: SingleChildScrollView(
        child: AgoraSecondaryStyleView(
          title: AgoraRichText(
            policeStyle: AgoraRichTextPoliceStyle.toolbar,
            items: [
              AgoraRichTextTextItem(
                text: ProfileStrings.policy,
                style: AgoraRichTextItemStyle.regular,
              ),
              AgoraRichTextSpaceItem(),
              AgoraRichTextTextItem(
                text: ProfileStrings.privacy,
                style: AgoraRichTextItemStyle.bold,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: AgoraSpacings.horizontalPadding,
              right: AgoraSpacings.horizontalPadding,
              bottom: AgoraSpacings.x2,
            ),
            child: Column(
              children: [
                Text(
                  "Pharetra amet morbi quis eget. Habitasse neque placerat sagittis sagittis ipsum cursus venenatis sollicitudin neque. Eget.\n\nNibh amet laoreet neque imperdiet nec montes sodales lacinia. Senectus scelerisque risus velit risus accumsan pulvinar. Et suspendisse quis netus curabitur quis facilisi enim nulla facilisis. Proin lectus sapien ultrices ipsum. Tellus a aliquet cum at tellus amet id mi. Aliquam vestibulum.\n\nCondimentum diam nibh in eleifend. Nisi magna leo diam mauris amet feugiat dignissim sed. Rhoncus ultricies pellentesque est est facilisis. Sed feugiat.\n\nSed aliquet ligula viverra ante in. Tincidunt aliquet sit in dui tortor egestas sed augue. Euismod lorem felis mauris aliquam. Posuere orci diam cum sed ullamcorper amet pellentesque commodo. Est sit consectetur platea non ipsum interdum nec urna.\n\nSed aliquet ligula viverra ante in. Tincidunt aliquet sit in dui tortor egestas sed augue. Euismod lorem felis mauris aliquam. Posuere orci diam cum sed ullamcorper amet pellentesque commodo. Est sit consectetur platea non ipsum interdum nec urna.",
                  style: AgoraTextStyles.light16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
