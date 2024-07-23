import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/consultation/dynamic/pages/dynamic_consultation_page.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/scroll/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/text/agora_link_text.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/profil/demographic/pages/demographic_question_page.dart';
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
                          Text(DemographicStrings.informationShortDescription, style: AgoraTextStyles.regular14),
                          SizedBox(height: AgoraSpacings.x0_5),
                          if (isReadMore)
                            _LireLaSuiteContent()
                          else
                            AgoraLinkText(
                              label: DemographicStrings.readMore,
                              textPadding: EdgeInsets.zero,
                              onTap: () {
                                TrackerHelper.trackClick(
                                  clickName: AnalyticsEventNames.readMore,
                                  widgetName: AnalyticsScreenNames.demographicInformationPage,
                                );
                                setState(() => isReadMore = true);
                              },
                            ),
                          SizedBox(height: AgoraSpacings.base),
                          _SuiteBoutons(arguments: arguments),
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

class _LireLaSuiteContent extends StatelessWidget {
  const _LireLaSuiteContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MergeSemantics(
          child: Semantics(
            label:
                "${DemographicStrings.informationLongDescription1}\n${DemographicStrings.informationLongDescription2}\n${DemographicStrings.informationLongDescription3}\n${DemographicStrings.informationLongDescription4}\n",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: AgoraSpacings.x0_75),
                ExcludeSemantics(
                  child: Text(
                    DemographicStrings.informationLongDescription1,
                    style: AgoraTextStyles.regular14,
                  ),
                ),
                ExcludeSemantics(
                  child: Row(
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
                ),
                ExcludeSemantics(
                  child: Row(
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
                ),
                ExcludeSemantics(
                  child: Text(
                    DemographicStrings.informationLongDescription4,
                    style: AgoraTextStyles.regular14,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AgoraSpacings.x0_75),
        AgoraLinkText(
          textItems: [
            TextSpan(
              text: DemographicStrings.moreInformations,
              style: AgoraTextStyles.regular14,
            ),
            TextSpan(
              text: DemographicStrings.moreInformationsLink,
              style: AgoraTextStyles.light14UnderlineBlue,
            ),
          ],
          onTap: () => LaunchUrlHelper.webview(context, ProfileStrings.privacyPolicyLink),
        ),
      ],
    );
  }
}

class _SuiteBoutons extends StatelessWidget {
  const _SuiteBoutons({required this.arguments});

  final DemographicInformationArguments arguments;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CommencerBouton(arguments: arguments),
        SizedBox(width: AgoraSpacings.base),
        _NePasRepondreBouton(arguments: arguments),
      ],
    );
  }
}

class _NePasRepondreBouton extends StatelessWidget {
  final DemographicInformationArguments arguments;

  const _NePasRepondreBouton({required this.arguments});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: AgoraButton(
        label: DemographicStrings.toNoAnswer,
        semanticLabel: DemographicStrings.toNoAnswerSemantic,
        style: AgoraButtonStyle.blueBorder,
        onTap: () {
          TrackerHelper.trackClick(
            clickName: AnalyticsEventNames.ignoreDemographic,
            widgetName: AnalyticsScreenNames.demographicInformationPage,
          );
          Navigator.pushNamed(
            context,
            DynamicConsultationPage.routeName,
            arguments: DynamicConsultationPageArguments(
              consultationId: arguments.consultationId,
              shouldLaunchCongratulationAnimation: true,
            ),
          ).then((value) => Navigator.of(context).pop());
        },
      ),
    );
  }
}

class _CommencerBouton extends StatelessWidget {
  final DemographicInformationArguments arguments;

  const _CommencerBouton({required this.arguments});

  @override
  Widget build(BuildContext context) {
    return AgoraButton(
      label: DemographicStrings.begin,
      semanticLabel: DemographicStrings.beginSemantic,
      style: AgoraButtonStyle.primary,
      onTap: () {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.beginDemographic,
          widgetName: AnalyticsScreenNames.demographicInformationPage,
        );
        Navigator.pushNamed(
          context,
          DemographicQuestionPage.routeName,
          arguments: DemographicQuestionArgumentsFromQuestion(
            consultationId: arguments.consultationId,
            consultationTitle: arguments.consultationTitle,
          ),
        ).then((value) => Navigator.of(context).pop());
      },
    );
  }
}
