import 'package:agora/common/helper/clipboard_helper.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/participate_charter_strings.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_secondary_style_view.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ParticipationCharterPage extends StatelessWidget {
  static const routeName = "/participationCharterPage";

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      child: SingleChildScrollView(
        child: AgoraSecondaryStyleView(
          title: AgoraRichText(
            policeStyle: AgoraRichTextPoliceStyle.toolbar,
            items: [
              AgoraRichTextTextItem(
                text: ProfileStrings.charter,
                style: AgoraRichTextItemStyle.regular,
              ),
              AgoraRichTextSpaceItem(),
              AgoraRichTextTextItem(
                text: ProfileStrings.participation,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _paragraph1() +
                  _paragraph2() +
                  _paragraph3(context) +
                  _paragraph4() +
                  _paragraph5() +
                  _paragraph6(context) +
                  [
                    AgoraButton(
                      label: GenericStrings.back,
                      style: AgoraButtonStyle.primaryButtonStyle,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _paragraph1() {
    return [
      Text(PrivacyPolicyStrings.title1, style: AgoraTextStyles.medium18),
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description1_1, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description1_2, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description1_3, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_3_1),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_3_2),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_3_3),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildRichText([
        TextSpan(text: PrivacyPolicyStrings.description1_3_4_1),
        WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
        TextSpan(text: PrivacyPolicyStrings.description1_3_4_2, style: AgoraTextStyles.light14Italic),
        WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
        TextSpan(text: PrivacyPolicyStrings.description1_3_4_3),
        WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
      ]),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_3_5),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_3_6),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description1_4, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_4_1),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_4_2),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_4_3),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_4_4),
      SizedBox(height: AgoraSpacings.base),
    ];
  }

  List<Widget> _paragraph2() {
    return [
      Text(PrivacyPolicyStrings.title2, style: AgoraTextStyles.medium18),
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description2_1, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description2_2, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description2_3, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description2_4, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description2_4_1),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description2_4_2),
      SizedBox(height: AgoraSpacings.base),
    ];
  }

  List<Widget> _paragraph3(BuildContext context) {
    return [
      Text(PrivacyPolicyStrings.title3, style: AgoraTextStyles.medium16),
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description3_1, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description3_2, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description3_3, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description3_4, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description3_4_1),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description3_4_2),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description3_4_3),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildRichText([
        TextSpan(text: PrivacyPolicyStrings.description3_4_4_1),
        WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
        TextSpan(text: PrivacyPolicyStrings.description3_4_4_2, style: AgoraTextStyles.light14Italic),
        WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
        TextSpan(text: PrivacyPolicyStrings.description3_4_4_3),
        WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
      ]),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description3_4_5),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildRichText([
        TextSpan(text: PrivacyPolicyStrings.description3_4_6_1),
        WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
        TextSpan(text: PrivacyPolicyStrings.description3_4_6_2, style: AgoraTextStyles.light14Italic),
        WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
        TextSpan(text: PrivacyPolicyStrings.description3_4_6_3),
        WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
      ]),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description3_4_7),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description3_4_8),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description3_5, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      _buildRichText(
        [
          TextSpan(text: PrivacyPolicyStrings.description3_6),
          WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
          TextSpan(
            text: GenericStrings.mailSupport,
            style: AgoraTextStyles.light14Underline,
            recognizer: LongPressGestureRecognizer()
              ..onLongPress = () => ClipboardHelper.copy(context, GenericStrings.mailSupport),
          ),
        ],
        withBulletPoint: false,
      ),
      SizedBox(height: AgoraSpacings.base),
    ];
  }

  List<Widget> _paragraph4() {
    return [
      Text(PrivacyPolicyStrings.title4, style: AgoraTextStyles.medium16),
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description4_1, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.base),
    ];
  }

  List<Widget> _paragraph5() {
    return [
      Text(PrivacyPolicyStrings.title5, style: AgoraTextStyles.medium16),
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description5_1, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description5_1_1),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description5_1_2),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description5_1_3),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description5_1_4),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description5_1_5),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description5_1_6),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description5_1_7),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description5_2, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description5_2_1),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description5_2_2),
      SizedBox(height: AgoraSpacings.base),
    ];
  }

  List<Widget> _paragraph6(BuildContext context) {
    return [
      Text(PrivacyPolicyStrings.title6, style: AgoraTextStyles.medium16),
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description6_1, style: AgoraTextStyles.regular16),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description6_1_1, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description6_1_2, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description6_1_3, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description6_2, style: AgoraTextStyles.regular16),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description6_2_1, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description6_2_2_1),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description6_2_2_2),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description6_2_2_3),
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description6_3, style: AgoraTextStyles.regular16),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description6_3_1, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description6_3_2, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description6_4, style: AgoraTextStyles.regular16),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description6_4_1, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description6_4_2, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description6_4_3, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      _buildRichText(
        [
          TextSpan(text: PrivacyPolicyStrings.description6_4_4),
          WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
          TextSpan(
            text: GenericStrings.mailSupport,
            style: AgoraTextStyles.light14Underline,
            recognizer: LongPressGestureRecognizer()
              ..onLongPress = () => ClipboardHelper.copy(context, GenericStrings.mailSupport),
          ),
        ],
        withBulletPoint: false,
      ),
      SizedBox(height: AgoraSpacings.base),
    ];
  }

  Widget _buildTextWithBulletPoint(String text, {TextStyle style = AgoraTextStyles.light14}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("  \u2022", style: style),
        SizedBox(width: AgoraSpacings.x0_5),
        Expanded(child: Text(text, style: style)),
      ],
    );
  }

  Widget _buildRichText(
    List<InlineSpan> spans, {
    TextStyle style = AgoraTextStyles.light14,
    bool withBulletPoint = true,
  }) {
    if (withBulletPoint) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("  \u2022", style: style),
          SizedBox(width: AgoraSpacings.x0_5),
          Expanded(child: RichText(text: TextSpan(style: style, children: spans))),
        ],
      );
    } else {
      return RichText(text: TextSpan(style: style, children: spans));
    }
  }
}
