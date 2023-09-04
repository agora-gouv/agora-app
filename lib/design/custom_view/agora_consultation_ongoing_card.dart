import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/share_helper.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/custom_view/agora_thematique_card.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_icon_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/details/consultation_details_page.dart';
import 'package:agora/pages/consultation/summary/consultation_summary_page.dart';
import 'package:flutter/material.dart';

enum AgoraConsultationOngoingCardStyle { column, gridLeft, gridRight }

class AgoraConsultationOngoingCard extends StatelessWidget {
  final String consultationId;
  final String imageUrl;
  final ThematiqueViewModel thematique;
  final String title;
  final String endDate;
  final bool hasAnswered;
  final String? highlightLabel;
  final AgoraConsultationOngoingCardStyle style;

  AgoraConsultationOngoingCard({
    required this.consultationId,
    required this.imageUrl,
    required this.thematique,
    required this.title,
    required this.endDate,
    required this.hasAnswered,
    required this.highlightLabel,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return highlightLabel != null
        ? Stack(
            children: [
              _buildCard(context),
              Padding(
                padding: EdgeInsets.only(
                  top: AgoraSpacings.base,
                  left: _getHighLightLeftPadding(),
                  right: AgoraSpacings.x2,
                ),
                child: AgoraRoundedCard(
                  cardColor: AgoraColors.fluorescentRed,
                  padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.x0_5, vertical: AgoraSpacings.x0_25),
                  child: Text(highlightLabel!, style: AgoraTextStyles.medium14.copyWith(color: AgoraColors.white)),
                ),
              ),
            ],
          )
        : _buildCard(context);
  }

  Widget _buildCard(BuildContext context) {
    final isColumnStyle = style == AgoraConsultationOngoingCardStyle.column;
    final screenWidth = isColumnStyle ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 2;
    final screenHeight = screenWidth * 0.55;
    return Padding(
      padding: _getCardPadding(),
      child: Semantics(
        button: true,
        child: AgoraRoundedCard(
          borderColor: AgoraColors.border,
          onTap: () {
            TrackerHelper.trackClick(
              clickName: AnalyticsEventNames.participateConsultationByCard.format(consultationId),
              widgetName: AnalyticsScreenNames.consultationsPage,
            );
            _participate(context);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.fitWidth,
                width: screenWidth,
                height: screenHeight,
                excludeFromSemantics: true,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  return Center(
                    child: loadingProgress == null
                        ? child
                        : SizedBox(
                            width: screenWidth,
                            height: screenHeight,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Spacer(),
                                CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                  );
                },
              ),
              SizedBox(height: AgoraSpacings.base),
              ThematiqueHelper.buildCard(context, thematique, size: AgoraThematiqueSize.large),
              SizedBox(height: AgoraSpacings.x0_25),
              isColumnStyle
                  ? Text(title, style: AgoraTextStyles.medium22)
                  : Expanded(child: Text(title, style: AgoraTextStyles.medium22)),
              SizedBox(height: AgoraSpacings.x0_5),
              Text(
                ConsultationStrings.endDate.format(endDate),
                style: AgoraTextStyles.medium12.copyWith(color: AgoraColors.rhineCastle),
              ),
              SizedBox(height: AgoraSpacings.x1_25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: ExcludeSemantics(
                      child: AgoraButton(
                        label: hasAnswered ? ConsultationStrings.seeResults : ConsultationStrings.participate,
                        icon: hasAnswered ? "ic_list.svg" : "ic_bubble.svg",
                        style: AgoraButtonStyle.blueBorderButtonStyle,
                        onPressed: () {
                          if (hasAnswered) {
                            TrackerHelper.trackClick(
                              clickName: "${AnalyticsEventNames.seeResultsConsultation} $consultationId",
                              widgetName: AnalyticsScreenNames.consultationsPage,
                            );
                            Navigator.pushNamed(
                              context,
                              ConsultationSummaryPage.routeName,
                              arguments: ConsultationSummaryArguments(
                                consultationId: consultationId,
                                shouldReloadConsultationsWhenPop: false,
                                initialTab: ConsultationSummaryInitialTab.results,
                              ),
                            );
                          } else {
                            TrackerHelper.trackClick(
                              clickName: "${AnalyticsEventNames.participateConsultation} $consultationId",
                              widgetName: AnalyticsScreenNames.consultationsPage,
                            );
                            _participate(context);
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: AgoraSpacings.base),
                  AgoraIconButton(
                    icon: "ic_share.svg",
                    semanticLabel: "${SemanticsStrings.share} $title",
                    onClick: () {
                      TrackerHelper.trackClick(
                        clickName: "${AnalyticsEventNames.shareConsultation} $consultationId",
                        widgetName: AnalyticsScreenNames.consultationsPage,
                      );
                      ShareHelper.shareConsultation(context: context, title: title, id: consultationId);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  EdgeInsets _getCardPadding() {
    switch (style) {
      case AgoraConsultationOngoingCardStyle.column:
        return const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding);
      case AgoraConsultationOngoingCardStyle.gridLeft:
        return const EdgeInsets.only(left: AgoraSpacings.horizontalPadding, right: AgoraSpacings.horizontalPadding / 2);
      case AgoraConsultationOngoingCardStyle.gridRight:
        return const EdgeInsets.only(left: AgoraSpacings.horizontalPadding / 2, right: AgoraSpacings.horizontalPadding);
    }
  }

  double _getHighLightLeftPadding() {
    switch (style) {
      case AgoraConsultationOngoingCardStyle.column:
        return AgoraSpacings.base;
      case AgoraConsultationOngoingCardStyle.gridLeft:
        return AgoraSpacings.base;
      case AgoraConsultationOngoingCardStyle.gridRight:
        return AgoraSpacings.x0_375;
    }
  }

  void _participate(BuildContext context) {
    Navigator.pushNamed(
      context,
      ConsultationDetailsPage.routeName,
      arguments: ConsultationDetailsArguments(consultationId: consultationId),
    );
  }
}
