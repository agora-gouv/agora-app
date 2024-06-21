import 'package:agora/app_feedback/pages/app_feedback_page.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
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
import 'package:agora/pages/demographic/demographic_profil_page.dart';
import 'package:agora/pages/onboarding/onboarding_page.dart';
import 'package:agora/pages/profile/delete_account_page.dart';
import 'package:agora/pages/profile/notification_page.dart';
import 'package:agora/pages/profile/participation_charter_page.dart';
import 'package:agora/pages/profile/profil_information_page.dart';
import 'package:agora/pages/qag/moderation/moderation_page.dart';
import 'package:flutter/material.dart';

class ProfilPage extends StatefulWidget {
  static const routeName = "/profilPage";

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  var shouldReloadQagsPage = false;

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      popAction: () {
        _onBackClick(context);
        return false;
      },
      child: AgoraSecondaryStyleView(
        onBackClick: () => _onBackClick(context),
        pageLabel: ProfileStrings.my + ProfileStrings.profile,
        title: AgoraRichText(
          policeStyle: AgoraRichTextPoliceStyle.toolbar,
          items: [
            AgoraRichTextItem(
              text: ProfileStrings.my,
              style: AgoraRichTextItemStyle.regular,
            ),
            AgoraRichTextItem(
              text: ProfileStrings.profile,
              style: AgoraRichTextItemStyle.bold,
            ),
          ],
        ),
        child: Column(
          children: [
            FutureBuilder<bool>(
              future: StorageManager.getProfileDemographicStorageClient().isFirstDisplay(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                final isFirstDisplay = snapshot.data!;
                return AgoraMenuItem(
                  title: ProfileStrings.myInformation,
                  onClick: () {
                    _track(AnalyticsEventNames.myInformation);
                    if (isFirstDisplay) {
                      StorageManager.getProfileDemographicStorageClient().save(false);
                      Navigator.pushNamed(context, ProfilInformationsPage.routeName);
                      setState(() {
                        // utils to reload isFirstDisplay after saving in storage client
                      });
                    } else {
                      Navigator.pushNamed(context, DemographicProfilPage.routeName);
                    }
                  },
                );
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
                        Navigator.of(context).pushNamed(AppFeedbackPage.routeName);
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
