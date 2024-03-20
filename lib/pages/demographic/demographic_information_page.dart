import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/dynamic/dynamic_consultation_page.dart';
import 'package:agora/pages/demographic/demographic_question_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DemographicInformationArguments {
  final String consultationId;
  final String consultationTitle;

  DemographicInformationArguments({required this.consultationId, required this.consultationTitle});
}

class DemographicInformationPage extends StatefulWidget {
  static const routeName = "/demographicInformationPage";

  @override
  State<DemographicInformationPage> createState() => _DemographicInformationPageState();
}

class _DemographicInformationPageState extends State<DemographicInformationPage> {
  bool isReadMore = false;

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as DemographicInformationArguments;
    return AgoraScaffold(
      shouldPop: false,
      appBarType: AppBarColorType.primaryColor,
      child: AgoraSingleScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AgoraTopDiagonal(),
            SizedBox(height: AgoraSpacings.x1_5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
              child: Semantics(
                focused: true,
                child: Text(
                  DemographicStrings.informationTitle,
                  style: AgoraTextStyles.medium20,
                  semanticsLabel: SemanticsStrings.informationTitle,
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
                            DemographicStrings.informationShortDescription,
                            style: AgoraTextStyles.regular14,
                            semanticsLabel:
                                "${DemographicStrings.informationShortDescription}\n\n${DemographicStrings.informationLongDescription1}${DemographicStrings.informationLongDescription2}${DemographicStrings.informationLongDescription3}\n${DemographicStrings.informationLongDescription4}",
                          ),
                          SizedBox(height: AgoraSpacings.x1_25),
                          if (isReadMore)
                            ExcludeSemantics(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DemographicStrings.informationLongDescription1,
                                    style: AgoraTextStyles.regular14,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ExcludeSemantics(child: Text("\u2022", style: AgoraTextStyles.regular14)),
                                      SizedBox(width: AgoraSpacings.x0_5),
                                      Expanded(
                                        child: Text(
                                          DemographicStrings.informationLongDescription2,
                                          style: AgoraTextStyles.regular14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ExcludeSemantics(child: Text("\u2022", style: AgoraTextStyles.regular14)),
                                      SizedBox(width: AgoraSpacings.x0_5),
                                      Expanded(
                                        child: Text(
                                          DemographicStrings.informationLongDescription3,
                                          style: AgoraTextStyles.regular14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    DemographicStrings.informationLongDescription4,
                                    style: AgoraTextStyles.regular14,
                                  ),
                                  SizedBox(height: AgoraSpacings.x1_25),
                                  RichText(
                                    textScaler: MediaQuery.of(context).textScaler,
                                    text: TextSpan(
                                      style: AgoraTextStyles.regular14,
                                      children: [
                                        TextSpan(text: DemographicStrings.moreInformations),
                                        TextSpan(
                                          text: DemographicStrings.moreInformationsLink,
                                          style:
                                              AgoraTextStyles.light14Underline.copyWith(color: AgoraColors.primaryBlue),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () =>
                                                LaunchUrlHelper.webview(context, ProfileStrings.privacyPolicyLink),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            ExcludeSemantics(
                              child: InkWell(
                                onTap: () {
                                  TrackerHelper.trackClick(
                                    clickName: AnalyticsEventNames.readMore,
                                    widgetName: AnalyticsScreenNames.demographicInformationPage,
                                  );
                                  setState(() => isReadMore = true);
                                },
                                child: Text(
                                  DemographicStrings.readMore,
                                  style: AgoraTextStyles.regular14Underline.copyWith(color: AgoraColors.primaryBlue),
                                ),
                              ),
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
                                    widgetName: AnalyticsScreenNames.demographicInformationPage,
                                  );
                                  Navigator.pushReplacementNamed(
                                    context,
                                    DemographicQuestionPage.routeName,
                                    arguments: DemographicQuestionArgumentsFromQuestion(
                                      consultationId: arguments.consultationId,
                                      consultationTitle: arguments.consultationTitle,
                                    ),
                                  );
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
                                      widgetName: AnalyticsScreenNames.demographicInformationPage,
                                    );
                                    Navigator.pushReplacementNamed(
                                      context,
                                      DynamicConsultationPage.routeName,
                                      arguments: DynamicConsultationPageArguments(
                                        consultationId: arguments.consultationId,
                                      ),
                                    );
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
