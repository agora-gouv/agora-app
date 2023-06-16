import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/summary/consultation_summary_page.dart';
import 'package:agora/pages/demographic/demographic_question_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DemographicInformationPage extends StatefulWidget {
  static const routeName = "/demographicInformationPage";

  @override
  State<DemographicInformationPage> createState() => _DemographicInformationPageState();
}

class _DemographicInformationPageState extends State<DemographicInformationPage> {
  bool isReadMore = false;

  @override
  Widget build(BuildContext context) {
    final consultationId = ModalRoute.of(context)!.settings.arguments as String;
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
              child: Text(DemographicStrings.informationTitle, style: AgoraTextStyles.medium20),
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
                          ),
                          SizedBox(height: AgoraSpacings.x1_25),
                          if (isReadMore) ...[
                            Text(
                              DemographicStrings.informationLongDescription1,
                              style: AgoraTextStyles.regular14,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("\u2022", style: AgoraTextStyles.regular14),
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
                                Text("\u2022", style: AgoraTextStyles.regular14),
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
                          ] else
                            InkWell(
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
                                  Navigator.pushNamed(
                                    context,
                                    DemographicQuestionPage.routeName,
                                    arguments: consultationId,
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
                                    Navigator.pushNamed(
                                      context,
                                      ConsultationSummaryPage.routeName,
                                      arguments: ConsultationSummaryArguments(consultationId: consultationId),
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
