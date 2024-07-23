import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/scroll/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/text/agora_link_text.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/profil/demographic/pages/demographic_profil_page.dart';
import 'package:agora/profil/demographic/pages/demographic_question_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilInformationsPage extends StatefulWidget {
  static const routeName = "/profilInformationPage";

  @override
  State<ProfilInformationsPage> createState() => _ProfilInformationsPageState();
}

class _ProfilInformationsPageState extends State<ProfilInformationsPage> {
  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      shouldPop: false,
      child: AgoraSingleScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AgoraSpacings.x1_5),
            _Title(),
            SizedBox(height: AgoraSpacings.x1_5),
            _Content(),
          ],
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        color: AgoraColors.background,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AgoraSpacings.horizontalPadding,
                vertical: AgoraSpacings.base,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Description1(),
                  SizedBox(height: AgoraSpacings.x1_25),
                  _Description2(),
                  SizedBox(height: AgoraSpacings.x0_75),
                  _Description3(),
                  SizedBox(height: AgoraSpacings.x0_75),
                  _Description4(),
                  SizedBox(height: AgoraSpacings.x1_25),
                  _Description5(),
                  SizedBox(height: AgoraSpacings.x1_25),
                  _ChoixBoutons(),
                ],
              ),
            ),
            SizedBox(height: AgoraSpacings.x3),
            SvgPicture.asset(
              "assets/ic_demographic_information.svg",
              width: MediaQuery.of(context).size.width,
              excludeFromSemantics: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
      child: Semantics(
        focused: true,
        child: RichText(
          textScaler: MediaQuery.textScalerOf(context),
          text: TextSpan(
            style: AgoraTextStyles.light20,
            children: [
              TextSpan(text: ProfileStrings.demographicInformationTitle1, style: AgoraTextStyles.medium20),
              TextSpan(text: ProfileStrings.demographicInformationTitle2),
            ],
          ),
        ),
      ),
    );
  }
}

class _Description1 extends StatelessWidget {
  const _Description1();

  @override
  Widget build(BuildContext context) {
    return Text(
      ProfileStrings.demographicInformationDescription1,
      style: AgoraTextStyles.regular14,
    );
  }
}

class _Description2 extends StatelessWidget {
  const _Description2();

  @override
  Widget build(BuildContext context) {
    return Text(
      ProfileStrings.demographicInformationDescription2,
      style: AgoraTextStyles.regular14,
    );
  }
}

class _Description3 extends StatelessWidget {
  const _Description3();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(child: Text("\u2022", style: AgoraTextStyles.regular14)),
        SizedBox(width: AgoraSpacings.x0_5),
        Expanded(
          child: Text(
            ProfileStrings.demographicInformationDescription3,
            style: AgoraTextStyles.regular14,
          ),
        ),
      ],
    );
  }
}

class _Description4 extends StatelessWidget {
  const _Description4();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(child: Text("\u2022", style: AgoraTextStyles.regular14)),
        SizedBox(width: AgoraSpacings.x0_5),
        Expanded(
          child: Text(
            ProfileStrings.demographicInformationDescription4,
            style: AgoraTextStyles.regular14,
          ),
        ),
      ],
    );
  }
}

class _Description5 extends StatelessWidget {
  const _Description5();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(ProfileStrings.demographicInformationDescription5, style: AgoraTextStyles.regular14),
        SizedBox(height: AgoraSpacings.x0_75),
        AgoraLinkText(
          highlightColor: AgoraColors.neutral300,
          splashColor: AgoraColors.neutral300,
          onTap: () => LaunchUrlHelper.webview(context, ProfileStrings.privacyPolicyLink),
          textItems: [
            TextSpan(text: ProfileStrings.demographicInformationDescription6, style: AgoraTextStyles.regular14),
            TextSpan(
              text: ProfileStrings.demographicInformationDescription7,
              style: AgoraTextStyles.light14UnderlineBlue,
            ),
          ],
        ),
      ],
    );
  }
}

class _ChoixBoutons extends StatelessWidget {
  const _ChoixBoutons();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AgoraButton(
          label: DemographicStrings.begin,
          style: AgoraButtonStyle.primary,
          onTap: () {
            TrackerHelper.trackClick(
              clickName: AnalyticsEventNames.beginDemographic,
              widgetName: AnalyticsScreenNames.profileDemographicInformationPage,
            );
            Navigator.pushNamed(context, DemographicQuestionPage.routeName);
          },
        ),
        SizedBox(width: AgoraSpacings.base),
        Flexible(
          child: AgoraButton(
            label: DemographicStrings.toNoAnswer,
            style: AgoraButtonStyle.blueBorder,
            onTap: () {
              TrackerHelper.trackClick(
                clickName: AnalyticsEventNames.ignoreDemographic,
                widgetName: AnalyticsScreenNames.profileDemographicInformationPage,
              );
              Navigator.pushReplacementNamed(context, DemographicProfilPage.routeName);
            },
          ),
        ),
      ],
    );
  }
}
