import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/design/custom_view/agora_menu_item.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_secondary_style_view.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/demographic/demographic_profile_page.dart';
import 'package:agora/pages/onboarding/onboarding_page.dart';
import 'package:agora/pages/profile/delete_account_page.dart';
import 'package:agora/pages/profile/legal_notice_page.dart';
import 'package:agora/pages/profile/moderation_charter_page.dart';
import 'package:agora/pages/profile/privacy_policy_page.dart';
import 'package:agora/pages/profile/terms_of_condition_page.dart';
import 'package:agora/pages/qag/moderation/moderation_page.dart';
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
                  _track(AnalyticsEventNames.myInformation);
                  Navigator.pushNamed(context, DemographicProfilePage.routeName);
                },
              ),
              // AgoraMenuItem(
              //   title: ProfileStrings.notification,
              //   onClick: () {
              //     _track(AnalyticsEventNames.notification);
              //     // TODO
              //   },
              // ),
              AgoraMenuItem(
                title: ProfileStrings.tutorial,
                onClick: () {
                  _track(AnalyticsEventNames.tutorial);
                  Navigator.pushNamed(context, OnboardingPage.routeName);
                },
              ),
              if (HelperManager.getRoleHelper().isModerator() == true)
                AgoraMenuItem(
                  title: ProfileStrings.moderationCapitalize,
                  onClick: () {
                    _track(AnalyticsEventNames.moderationCapitalize);
                    Navigator.pushNamed(context, ModerationPage.routeName);
                  },
                ),
              AgoraMenuItem(
                title: ProfileStrings.deleteAccount,
                onClick: () {
                  _track(AnalyticsEventNames.deleteAccount);
                  Navigator.pushNamed(context, DeleteAccountPage.routeName);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
                child: Divider(color: AgoraColors.divider, thickness: 1),
              ),
              AgoraMenuItem(
                title: ProfileStrings.moderationCharter,
                onClick: () {
                  _track(AnalyticsEventNames.moderationCharter);
                  Navigator.pushNamed(context, ModerationCharterPage.routeName);
                },
              ),
              AgoraMenuItem(
                title: ProfileStrings.privacyPolicy,
                onClick: () {
                  _track(AnalyticsEventNames.privacyPolicy);
                  Navigator.pushNamed(context, PrivacyPolicyPage.routeName);
                },
              ),
              AgoraMenuItem(
                title: ProfileStrings.termsOfService,
                onClick: () {
                  _track(AnalyticsEventNames.termsOfService);
                  Navigator.pushNamed(context, TermsOfConditionPage.routeName);
                },
              ),
              AgoraMenuItem(
                title: ProfileStrings.legalNotice,
                onClick: () {
                  _track(AnalyticsEventNames.legalNotice);
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
                          _track(AnalyticsEventNames.giveFeedback);
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

  void _track(String clickName) {
    TrackerHelper.trackClick(
      clickName: clickName,
      widgetName: AnalyticsScreenNames.profilePage,
    );
  }
}
