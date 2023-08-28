import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/demographic/demographic_profile_page.dart';
import 'package:agora/pages/demographic/demographic_question_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileDemographicInformationPage extends StatefulWidget {
  static const routeName = "/profileDemographicInformationPage";

  @override
  State<ProfileDemographicInformationPage> createState() => _ProfileDemographicInformationPageState();
}

class _ProfileDemographicInformationPageState extends State<ProfileDemographicInformationPage> {
  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      shouldPop: false,
      appBarColor: AgoraColors.primaryBlue,
      child: AgoraSingleScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AgoraTopDiagonal(),
            SizedBox(height: AgoraSpacings.x1_5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
              child: RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  style: AgoraTextStyles.light20,
                  children: [
                    TextSpan(text: ProfileStrings.demographicInformationTitle1, style: AgoraTextStyles.medium20),
                    TextSpan(text: ProfileStrings.demographicInformationTitle2),
                  ],
                ),
              ),
            ),
            SizedBox(height: AgoraSpacings.x1_5),
            Flexible(
              child: Container(
                width: double.infinity,
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
                          Text(
                            ProfileStrings.demographicInformationDescription1,
                            style: AgoraTextStyles.regular14,
                          ),
                          SizedBox(height: AgoraSpacings.x1_25),
                          Text(
                            ProfileStrings.demographicInformationDescription2,
                            style: AgoraTextStyles.regular14,
                          ),
                          SizedBox(height: AgoraSpacings.x0_75),
                          Row(
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
                          ),
                          SizedBox(height: AgoraSpacings.x0_75),
                          Row(
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
                          ),
                          SizedBox(height: AgoraSpacings.x1_25),
                          Text(
                            ProfileStrings.demographicInformationDescription5,
                            style: AgoraTextStyles.regular14,
                          ),
                          SizedBox(height: AgoraSpacings.x1_25),
                          Row(
                            children: [
                              AgoraButton(
                                label: DemographicStrings.begin,
                                style: AgoraButtonStyle.primaryButtonStyle,
                                onPressed: () {
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
                                  style: AgoraButtonStyle.blueBorderButtonStyle,
                                  onPressed: () {
                                    TrackerHelper.trackClick(
                                      clickName: AnalyticsEventNames.ignoreDemographic,
                                      widgetName: AnalyticsScreenNames.profileDemographicInformationPage,
                                    );
                                    Navigator.pushReplacementNamed(context, DemographicProfilePage.routeName);
                                  },
                                ),
                              ),
                            ],
                          ),
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
            ),
          ],
        ),
      ),
    );
  }
}
