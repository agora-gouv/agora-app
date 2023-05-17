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
                  // TODO
                },
              ),
              AgoraMenuItem(
                title: ProfileStrings.privacyPolicy,
                onClick: () {
                  // TODO
                },
              ),
              AgoraMenuItem(
                title: ProfileStrings.termsOfService,
                onClick: () {
                  // TODO
                },
              ),
              AgoraMenuItem(
                title: ProfileStrings.legalNotice,
                onClick: () {
                  // TODO
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
                      Text(ProfileStrings.helpTipsTitle, style: AgoraTextStyles.medium18),
                      SizedBox(height: AgoraSpacings.x0_75),
                      Text(ProfileStrings.helpTipsDescription, style: AgoraTextStyles.light14),
                      SizedBox(height: AgoraSpacings.x1_25),
                      AgoraButton(
                        label: ProfileStrings.helpTipsButton,
                        style: AgoraButtonStyle.primaryButtonStyle,
                        onPressed: () {
                          // TODO
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
