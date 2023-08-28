import 'package:agora/common/helper/clipboard_helper.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/profile/participation_charter_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QagsModeratedErrorContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          AgoraToolbar(),
          Spacer(flex: 1),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AgoraSpacings.horizontalPadding,
              vertical: AgoraSpacings.x1_5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: SvgPicture.asset("assets/ic_oops.svg", excludeFromSemantics: true)),
                SizedBox(height: AgoraSpacings.x1_25),
                Center(child: Text(QagStrings.qagModerateTitle, style: AgoraTextStyles.medium18)),
                SizedBox(height: AgoraSpacings.x1_25),
                _buildRichText(
                  context,
                  [
                    TextSpan(text: QagStrings.qagModerateDescription1_1),
                    WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                    TextSpan(
                      text: QagStrings.qagModerateDescription1_2,
                      style: AgoraTextStyles.light14Underline.copyWith(color: AgoraColors.primaryBlue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushNamed(context, ParticipationCharterPage.routeName),
                    ),
                    WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                    TextSpan(text: QagStrings.qagModerateDescription1_3),
                  ],
                ),
                SizedBox(height: AgoraSpacings.base),
                _buildRichText(
                  context,
                  [
                    TextSpan(text: QagStrings.qagModerateDescription2),
                    WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                    TextSpan(
                      text: GenericStrings.mailSupport,
                      style: AgoraTextStyles.light14Underline.copyWith(color: AgoraColors.primaryBlue),
                      recognizer: LongPressGestureRecognizer()
                        ..onLongPress = () => ClipboardHelper.copy(context, GenericStrings.mailSupport),
                    ),
                  ],
                ),
                SizedBox(height: AgoraSpacings.x2),
                AgoraButton(
                  label: QagStrings.qagModerateSeeOther,
                  style: AgoraButtonStyle.blueBorderButtonStyle,
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
          Spacer(flex: 3),
        ],
      ),
    );
  }

  Widget _buildRichText(
    BuildContext context,
    List<InlineSpan> spans, {
    TextStyle style = AgoraTextStyles.light14,
  }) {
    return RichText(
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      text: TextSpan(style: style, children: spans),
    );
  }
}
