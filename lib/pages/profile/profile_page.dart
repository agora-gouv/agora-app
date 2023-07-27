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
import 'package:agora/pages/profile/notification_page.dart';
import 'package:agora/pages/profile/participation_charter_page.dart';
import 'package:agora/pages/qag/moderation/moderation_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = "/profilePage";

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var shouldReloadQagsPage = false;

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      popAction: () {
        _onBackClick(context);
        return true;
      },
      child: AgoraSecondaryStyleView(
        onBackClick: () => _onBackClick(context),
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
            AgoraMenuItem(
              title: ProfileStrings.notification,
              onClick: () {
                _track(AnalyticsEventNames.notification);
                Navigator.pushNamed(context, NotificationPage.routeName);
              },
            ),
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
                  Navigator.pushNamed(context, ModerationPage.routeName).then(
                    (value) {
                      final previousShouldReloadQagsPage = value as bool;
                      if (!shouldReloadQagsPage && previousShouldReloadQagsPage) {
                        setState(() => shouldReloadQagsPage = true);
                      }
                    },
                  );
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
              title: ProfileStrings.participationCharter,
              onClick: () {
                _track(AnalyticsEventNames.participationCharter);
                Navigator.pushNamed(context, ParticipationCharterPage.routeName);
              },
            ),
            AgoraMenuItem(
              title: ProfileStrings.privacyPolicy,
              onClick: () {
                _track(AnalyticsEventNames.privacyPolicy);
                LaunchUrlHelper.webview(context, ProfileStrings.privacyPolicyLink);
              },
            ),
            AgoraMenuItem(
              title: ProfileStrings.termsOfService,
              onClick: () {
                _track(AnalyticsEventNames.termsOfService);
                LaunchUrlHelper.webview(context, ProfileStrings.cguLink);
              },
            ),
            AgoraMenuItem(
              title: ProfileStrings.legalNotice,
              onClick: () {
                _track(AnalyticsEventNames.legalNotice);
                LaunchUrlHelper.webview(context, ProfileStrings.legalNoticeLink);
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
                        LaunchUrlHelper.webview(context, ProfileStrings.feedbackLink);
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
    );
  }

  void _onBackClick(BuildContext context) {
    Navigator.pop(context, shouldReloadQagsPage);
  }

  void _track(String clickName) {
    TrackerHelper.trackClick(
      clickName: clickName,
      widgetName: AnalyticsScreenNames.profilePage,
    );
  }
}
