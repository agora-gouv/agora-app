import 'package:agora/common/helper/clipboard_helper.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/privacy_policy_strings.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_secondary_style_view.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  static const routeName = "/privacyPolicyPage";

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      child: AgoraSecondaryStyleView(
        title: AgoraRichText(
          policeStyle: AgoraRichTextPoliceStyle.toolbar,
          items: [
            AgoraRichTextItem(
              text: ProfileStrings.policy,
              style: AgoraRichTextItemStyle.regular,
            ),
            AgoraRichTextItem(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _paragraph1() +
                _paragraph2() +
                _paragraph3(context) +
                _paragraph4() +
                _paragraph5() +
                _paragraph6(context) +
                _paragraph7() +
                _paragraph8() +
                _paragraph9(context) +
                _paragraph10(context) +
                _paragraph11(context) +
                [
                  AgoraButton(
                    label: GenericStrings.back,
                    style: AgoraButtonStyle.primaryButtonStyle,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
          ),
        ),
      ),
    );
  }

  List<Widget> _paragraph1() {
    // Qui est responsable d'Agora ?
    return [
      Text(PrivacyPolicyStrings.title1, style: AgoraTextStyles.medium16),
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description1_1, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_25),
      Text(PrivacyPolicyStrings.description1_2, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_25),
      Text(PrivacyPolicyStrings.description1_3, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_25),
      Text(PrivacyPolicyStrings.description1_4, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.base),
    ];
  }

  List<Widget> _paragraph2() {
    // Pourquoi manipulons-nous ces données ?
    return [
      Text(PrivacyPolicyStrings.title2, style: AgoraTextStyles.medium16),
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description2_1, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description2_2),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description2_3),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description2_4),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description2_5),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description2_6, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.base),
    ];
  }

  List<Widget> _paragraph3(BuildContext context) {
    // Quelles sont les données que nous manipulons ?;
    return [
      Text(PrivacyPolicyStrings.title3, style: AgoraTextStyles.medium16),
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description3_1, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      _buildRichText(
        context,
        [
          TextSpan(text: PrivacyPolicyStrings.description3_2_1, style: AgoraTextStyles.medium14),
          WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
          TextSpan(text: PrivacyPolicyStrings.description3_2_2),
        ],
      ),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description3_3, style: AgoraTextStyles.medium14),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description3_4, style: AgoraTextStyles.medium14),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description3_5),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description3_6, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.base),
    ];
  }

  List<Widget> _paragraph4() {
    // Qu'est-ce qui nous autorise à manipuler ces données ?;
    return [
      Text(PrivacyPolicyStrings.title4, style: AgoraTextStyles.medium16),
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description4_1, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description4_2, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.base),
    ];
  }

  List<Widget> _paragraph5() {
    // Pendant combien de temps conservons-nous ces données ?
    return [
      Text(PrivacyPolicyStrings.title5, style: AgoraTextStyles.medium16),
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description5_1, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description5_2, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description5_3),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description5_4),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description5_5),
      SizedBox(height: AgoraSpacings.base),
    ];
  }

  List<Widget> _paragraph6(BuildContext context) {
    // Quels droits avez-vous ?
    return [
      Text(PrivacyPolicyStrings.title6, style: AgoraTextStyles.medium16),
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description6_1, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description6_2),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description6_3),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description6_4),
      SizedBox(height: AgoraSpacings.x0_5),
      _buildRichText(
        context,
        [
          TextSpan(text: PrivacyPolicyStrings.description6_5),
          WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
          TextSpan(
            text: GenericStrings.mailSupport,
            style: AgoraTextStyles.light14Underline.copyWith(color: AgoraColors.primaryBlue),
            recognizer: LongPressGestureRecognizer()
              ..onLongPress = () => ClipboardHelper.copy(context, GenericStrings.mailSupport),
          ),
        ],
        withBulletPoint: false,
      ),
      SizedBox(height: AgoraSpacings.x0_5),
      _buildRichText(
        context,
        [
          TextSpan(text: PrivacyPolicyStrings.description6_6),
          WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
          TextSpan(
            text: GenericStrings.address,
            style: AgoraTextStyles.light14Italic,
            recognizer: LongPressGestureRecognizer()
              ..onLongPress = () => ClipboardHelper.copy(context, GenericStrings.address),
          ),
        ],
        withBulletPoint: false,
      ),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description6_7, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description6_8, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      _buildRichText(
        context,
        [
          TextSpan(text: PrivacyPolicyStrings.description6_9),
          WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
          TextSpan(
            text: GenericStrings.cnil,
            style: AgoraTextStyles.light14Underline.copyWith(color: AgoraColors.primaryBlue),
            recognizer: TapGestureRecognizer()..onTap = () => LaunchUrlHelper.webview(context, GenericStrings.cnil),
          ),
        ],
        withBulletPoint: false,
      ),
      SizedBox(height: AgoraSpacings.base),
    ];
  }

  List<Widget> _paragraph7() {
    // Qui va avoir accès à ces données ?
    return [
      Text(PrivacyPolicyStrings.title7, style: AgoraTextStyles.medium16),
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description7_1, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description7_2, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description7_3),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description7_4),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description7_5),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description7_6, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.base),
    ];
  }

  List<Widget> _paragraph8() {
    // Quelles mesures de sécurité mettons-nous en place ?
    return [
      Text(PrivacyPolicyStrings.title8, style: AgoraTextStyles.medium16),
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description8_1, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description8_2),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description8_3),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description8_4),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description8_5),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description8_6),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description8_7),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description8_8),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description8_9, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.base),
    ];
  }

  List<Widget> _paragraph9(BuildContext context) {
    // Qui nous aide à manipuler les données ?
    return [
      Text(PrivacyPolicyStrings.title9, style: AgoraTextStyles.medium16),
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description9_1, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      // Matomo
      Text(PrivacyPolicyStrings.description9_2, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description9_3),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description9_4),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildRichText(
        context,
        [
          TextSpan(text: PrivacyPolicyStrings.descriptionGuaranty),
          WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
          TextSpan(
            text: PrivacyPolicyStrings.descriptionMatomoLink,
            style: AgoraTextStyles.light14Underline.copyWith(color: AgoraColors.primaryBlue),
            recognizer: TapGestureRecognizer()
              ..onTap = () => LaunchUrlHelper.webview(context, PrivacyPolicyStrings.descriptionMatomoLink),
          ),
          WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
          TextSpan(text: PrivacyPolicyStrings.description9_5_3),
        ],
      ),
      SizedBox(height: AgoraSpacings.x0_5),
      // Scalingo
      Text(PrivacyPolicyStrings.description9_6, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description9_7),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description9_8),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildRichText(
        context,
        [
          TextSpan(text: PrivacyPolicyStrings.descriptionGuaranty),
          WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
          TextSpan(
            text: PrivacyPolicyStrings.description9_9,
            style: AgoraTextStyles.light14Underline.copyWith(color: AgoraColors.primaryBlue),
            recognizer: TapGestureRecognizer()
              ..onTap = () => LaunchUrlHelper.webview(context, PrivacyPolicyStrings.description9_9),
          ),
        ],
      ),
      SizedBox(height: AgoraSpacings.x0_5),
      // Outscale
      Text(PrivacyPolicyStrings.description9_10, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description9_11),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description9_12),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildRichText(
        context,
        [
          TextSpan(text: PrivacyPolicyStrings.descriptionGuaranty),
          WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
          TextSpan(
            text: PrivacyPolicyStrings.description9_13,
            style: AgoraTextStyles.light14Underline.copyWith(color: AgoraColors.primaryBlue),
            recognizer: TapGestureRecognizer()
              ..onTap = () => LaunchUrlHelper.webview(context, PrivacyPolicyStrings.description9_13),
          ),
        ],
      ),
      SizedBox(height: AgoraSpacings.x0_5),
      // Tally
      Text(PrivacyPolicyStrings.description9_14, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description9_15),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description9_16),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildRichText(
        context,
        [
          TextSpan(text: PrivacyPolicyStrings.descriptionGuaranty),
          WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
          TextSpan(
            text: PrivacyPolicyStrings.description9_17,
            style: AgoraTextStyles.light14Underline.copyWith(color: AgoraColors.primaryBlue),
            recognizer: TapGestureRecognizer()
              ..onTap = () => LaunchUrlHelper.webview(context, PrivacyPolicyStrings.description9_17),
          ),
        ],
      ),
      SizedBox(height: AgoraSpacings.base),
    ];
  }

  List<Widget> _paragraph10(BuildContext context) {
    // Cookies
    return [
      Text(PrivacyPolicyStrings.title10, style: AgoraTextStyles.medium16),
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description10_1, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description10_2),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description10_3),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description10_4, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_25),
      Text(PrivacyPolicyStrings.description10_5, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description10_6),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description10_7),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description10_8),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildRichText(
        context,
        [
          TextSpan(text: PrivacyPolicyStrings.descriptionGuaranty),
          WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
          TextSpan(
            text: PrivacyPolicyStrings.descriptionMatomoLink,
            style: AgoraTextStyles.light14Underline.copyWith(color: AgoraColors.primaryBlue),
            recognizer: TapGestureRecognizer()
              ..onTap = () => LaunchUrlHelper.webview(context, PrivacyPolicyStrings.descriptionMatomoLink),
          ),
        ],
      ),
      SizedBox(height: AgoraSpacings.base),
    ];
  }

  List<Widget> _paragraph11(BuildContext context) {
    // Pour aller plus loin
    return [
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description11, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      _buildRichText(
        context,
        [
          TextSpan(
            text: PrivacyPolicyStrings.description11_1_1,
            style: AgoraTextStyles.light14Underline.copyWith(color: AgoraColors.primaryBlue),
            recognizer: TapGestureRecognizer()
              ..onTap = () => LaunchUrlHelper.webview(context, PrivacyPolicyStrings.description11_1_2),
          ),
        ],
      ),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildRichText(
        context,
        [
          TextSpan(
            text: PrivacyPolicyStrings.description11_2_1,
            style: AgoraTextStyles.light14Underline.copyWith(color: AgoraColors.primaryBlue),
            recognizer: TapGestureRecognizer()
              ..onTap = () => LaunchUrlHelper.webview(context, PrivacyPolicyStrings.description11_2_2),
          ),
        ],
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
    BuildContext context,
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
          Expanded(
            child: RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(style: style, children: spans),
            ),
          ),
        ],
      );
    } else {
      return RichText(
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        text: TextSpan(style: style, children: spans),
      );
    }
  }
}
