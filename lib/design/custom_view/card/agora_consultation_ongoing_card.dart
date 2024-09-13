import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/feature_flipping_helper.dart';
import 'package:agora/common/helper/share_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/consultation/bloc/consultation_bloc.dart';
import 'package:agora/consultation/bloc/consultation_event.dart';
import 'package:agora/consultation/dynamic/pages/dynamic_consultation_page.dart';
import 'package:agora/design/custom_view/agora_badge.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_icon_button.dart';
import 'package:agora/design/custom_view/card/agora_highlight_card.dart';
import 'package:agora/design/custom_view/card/agora_rounded_card.dart';
import 'package:agora/design/custom_view/card/agora_thematique_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/thematique/bloc/thematique_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AgoraConsultationOngoingCardStyle { column, gridLeft, gridRight }

class AgoraConsultationOngoingCard extends StatelessWidget {
  final String consultationId;
  final String consultationSlug;
  final String imageUrl;
  final ThematiqueViewModel thematique;
  final String title;
  final String endDate;
  final String? highlightLabel;
  final AgoraConsultationOngoingCardStyle style;
  final String semanticTooltip;
  final String badgeLabel;
  final Color badgeColor;
  final Color badgeTextColor;

  AgoraConsultationOngoingCard({
    super.key,
    required this.consultationId,
    required this.consultationSlug,
    required this.imageUrl,
    required this.thematique,
    required this.title,
    required this.endDate,
    required this.highlightLabel,
    required this.style,
    required this.semanticTooltip,
    required this.badgeLabel,
    required this.badgeColor,
    required this.badgeTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final isColumnStyle = style == AgoraConsultationOngoingCardStyle.column;
    final screenWidth = isColumnStyle ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 2;
    final screenHeight = screenWidth * 0.55;
    return Semantics(
      tooltip: semanticTooltip,
      button: true,
      label: 'Participer à la consultation',
      child: Stack(
        children: [
          Padding(
            padding: _getCardPadding(style),
            child: AgoraRoundedCard(
              borderColor: AgoraColors.border,
              onTap: () {
                TrackerHelper.trackClick(
                  clickName: AnalyticsEventNames.participateConsultationByCard.format(consultationId),
                  widgetName: AnalyticsScreenNames.consultationsPage,
                );
                _participate(context, consultationId, title);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Image(imageUrl: imageUrl, screenWidth: screenWidth, screenHeight: screenHeight),
                  SizedBox(height: AgoraSpacings.x0_5),
                  if (isTerritorialisationEnabled())
                    AgoraBadge(
                      label: badgeLabel,
                      backgroundColor: badgeColor,
                      textColor: badgeTextColor,
                    ),
                  SizedBox(height: AgoraSpacings.x0_5),
                  AgoraThematiqueLabel(
                    picto: thematique.picto,
                    label: thematique.label,
                    size: AgoraThematiqueSize.large,
                  ),
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
                  _Boutons(consultationId: consultationId, title: title, consultationSlug: consultationSlug),
                ],
              ),
            ),
          ),
          if (highlightLabel != null)
            Padding(
              padding: EdgeInsets.only(
                top: AgoraSpacings.base,
                left: _getHighLightLeftPadding(style),
                right: AgoraSpacings.x2,
              ),
              child: AgoraHighLightCard(label: highlightLabel!),
            ),
        ],
      ),
    );
  }
}

class _Boutons extends StatelessWidget {
  final String consultationId;
  final String title;
  final String consultationSlug;

  const _Boutons({
    required this.consultationId,
    required this.title,
    required this.consultationSlug,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: ExcludeSemantics(
            child: AgoraButton.withLabel(
              prefixIcon: "ic_question_confirmation.svg",
              label: ConsultationStrings.participate,
              buttonStyle: AgoraButtonStyle.primary,
              onPressed: () {
                TrackerHelper.trackClick(
                  clickName: "${AnalyticsEventNames.participateConsultation} $consultationId",
                  widgetName: AnalyticsScreenNames.consultationsPage,
                );
                _participate(context, consultationId, title);
              },
            ),
          ),
        ),
        SizedBox(width: AgoraSpacings.base),
        AgoraIconButton(
          icon: "ic_share.svg",
          focusColor: AgoraColors.neutral400,
          semanticLabel: "${SemanticsStrings.shareConsultation} $title",
          onClick: () {
            TrackerHelper.trackClick(
              clickName: "${AnalyticsEventNames.shareConsultation} $consultationId",
              widgetName: AnalyticsScreenNames.consultationsPage,
            );
            ShareHelper.shareConsultation(context: context, title: title, slug: consultationSlug);
          },
        ),
      ],
    );
  }
}

class _Image extends StatelessWidget {
  final String imageUrl;
  final double screenWidth;
  final double screenHeight;

  const _Image({
    required this.imageUrl,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
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
    );
  }
}

EdgeInsets _getCardPadding(AgoraConsultationOngoingCardStyle style) {
  switch (style) {
    case AgoraConsultationOngoingCardStyle.column:
      return const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding);
    case AgoraConsultationOngoingCardStyle.gridLeft:
      return const EdgeInsets.only(left: AgoraSpacings.horizontalPadding, right: AgoraSpacings.horizontalPadding / 2);
    case AgoraConsultationOngoingCardStyle.gridRight:
      return const EdgeInsets.only(left: AgoraSpacings.horizontalPadding / 2, right: AgoraSpacings.horizontalPadding);
  }
}

double _getHighLightLeftPadding(AgoraConsultationOngoingCardStyle style) {
  switch (style) {
    case AgoraConsultationOngoingCardStyle.column:
      return AgoraSpacings.base;
    case AgoraConsultationOngoingCardStyle.gridLeft:
      return AgoraSpacings.base;
    case AgoraConsultationOngoingCardStyle.gridRight:
      return AgoraSpacings.x0_375;
  }
}

void _participate(BuildContext context, String consultationId, String title) {
  Navigator.pushNamed(
    context,
    DynamicConsultationPage.routeName,
    arguments: DynamicConsultationPageArguments(consultationIdOrSlug: consultationId, consultationTitle: title),
  ).then((value) => context.read<ConsultationBloc>().add(FetchConsultationsEvent()));
}
