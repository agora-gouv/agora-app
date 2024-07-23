import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/text/agora_link_text.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/profil/participation_charter/pages/participation_charter_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QagsModeratedErrorContent extends StatelessWidget {
  const QagsModeratedErrorContent();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          AgoraToolbar(pageLabel: 'Erreur'),
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
                AgoraLinkText(
                  textPadding: EdgeInsets.zero,
                  textItems: [
                    TextSpan(text: QagStrings.qagModerateDescription1_1, style: AgoraTextStyles.light14),
                    TextSpan(text: QagStrings.qagModerateDescription1_2, style: AgoraTextStyles.light14UnderlineBlue),
                    TextSpan(text: QagStrings.qagModerateDescription1_3, style: AgoraTextStyles.light14),
                  ],
                  onTap: () => Navigator.pushNamed(context, ParticipationCharterPage.routeName),
                ),
                SizedBox(height: AgoraSpacings.base),
                AgoraLinkText(
                  textPadding: EdgeInsets.zero,
                  textItems: [
                    TextSpan(text: QagStrings.qagModerateDescription2, style: AgoraTextStyles.light14),
                    TextSpan(text: GenericStrings.mailSupport, style: AgoraTextStyles.light14UnderlineBlue),
                  ],
                  onTap: () => LaunchUrlHelper.mailtoAgora(),
                ),
                SizedBox(height: AgoraSpacings.x2),
                AgoraButton(
                  label: QagStrings.qagModerateSeeOther,
                  style: AgoraButtonStyle.blueBorder,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Spacer(flex: 3),
        ],
      ),
    );
  }
}
