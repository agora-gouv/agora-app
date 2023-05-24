import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/design/custom_view/agora_menu_item.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_secondary_style_view.dart';
import 'package:agora/design/custom_view/agora_title_rich_text.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/demographic/demographic_profile_page.dart';
import 'package:agora/pages/profile/legal_notice_page.dart';
import 'package:agora/pages/profile/moderation_charter_page.dart';
import 'package:agora/pages/profile/privacy_policy_page.dart';
import 'package:agora/pages/profile/terms_of_condition_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = "/profilePage";

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      child: SingleChildScrollView(
        child: AgoraSecondaryStyleView(
          title: AgoraRichText(
            policeStyle: AgoraRichTextPoliceStyle.toolbar,
            items: [
              AgoraRichTextTextItem(
                text: ProfileStrings.my,
                style: AgoraRichTextItemStyle.regular,
              ),
              AgoraRichTextSpaceItem(),
              AgoraRichTextTextItem(
                text: ProfileStrings.profile,
                style: AgoraRichTextItemStyle.bold,
              ),
            ],
          ),
          child: Column(
            children: [
              AgoraMenuItem(
                title: ProfileStrings.myInformation,
                onClick: () {
                  Navigator.pushNamed(context, DemographicProfilePage.routeName);
                },
              ),
              AgoraMenuItem(
                title: ProfileStrings.notification,
                onClick: () {
                  // TODO
                },
              ),
              AgoraMenuItem(
                title: ProfileStrings.tutorial,
                onClick: () {
                  // TODO
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
                child: Divider(color: AgoraColors.divider, thickness: 1),
              ),
              AgoraMenuItem(
                title: ProfileStrings.moderationCharter,
                onClick: () {
                  Navigator.pushNamed(context, ModerationCharterPage.routeName);
                },
              ),
              AgoraMenuItem(
                title: ProfileStrings.privacyPolicy,
                onClick: () {
                  Navigator.pushNamed(context, PrivacyPolicyPage.routeName);
                },
              ),
              AgoraMenuItem(
                title: ProfileStrings.termsOfService,
                onClick: () {
                  Navigator.pushNamed(context, TermsOfConditionPage.routeName);
                },
              ),
              AgoraMenuItem(
                title: ProfileStrings.legalNotice,
                onClick: () {
                  Navigator.pushNamed(context, LegalNoticePage.routeName);
                },
              ),
              SizedBox(height: AgoraSpacings.base),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
                child: AgoraRoundedCard(
                  cardColor: AgoraColors.doctor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ProfileStrings.feedbackTipsTitle, style: AgoraTextStyles.medium18),
                      SizedBox(height: AgoraSpacings.x0_75),
                      Text(ProfileStrings.feedbackTipsDescription, style: AgoraTextStyles.light14),
                      SizedBox(height: AgoraSpacings.x1_25),
                      AgoraButton(
                        label: ProfileStrings.feedbackTipsButton,
                        style: AgoraButtonStyle.primaryButtonStyle,
                        onPressed: () {
                          LaunchUrlHelper.launch(ProfileStrings.feedbackUrl);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AgoraSpacings.x1_5),
            ],
          ),
        ),
      ),
    );
  }
}
