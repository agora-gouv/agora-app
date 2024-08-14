import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/consultation/bloc/consultation_view_model.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/custom_view/card/agora_consultation_ongoing_card.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/qag/pages/qags_page.dart';
import 'package:flutter/material.dart';

class ConsultationsOngoingSection extends StatelessWidget {
  final List<ConsultationOngoingViewModel> ongoingViewModels;
  final bool answeredSectionEmpty;

  const ConsultationsOngoingSection({
    required this.ongoingViewModels,
    required this.answeredSectionEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildOngoingConsultations(context),
    );
  }

  List<Widget> _buildOngoingConsultations(BuildContext context) {
    final List<Widget> ongoingConsultationsWidgets = [
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AgoraSpacings.horizontalPadding,
          vertical: AgoraSpacings.base,
        ),
        child: AgoraRichText(
          items: [
            AgoraRichTextItem(
              text: "${ConsultationStrings.ongoingConsultationPart1}\n",
              style: AgoraRichTextItemStyle.regular,
            ),
            AgoraRichTextItem(
              text: ConsultationStrings.ongoingConsultationPart2,
              style: AgoraRichTextItemStyle.bold,
            ),
          ],
        ),
      ),
    ];

    if (ongoingViewModels.isEmpty) {
      ongoingConsultationsWidgets.add(Container(width: double.infinity));
      ongoingConsultationsWidgets.add(
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AgoraSpacings.horizontalPadding,
              vertical: AgoraSpacings.x0_75,
            ),
            child: Column(
              children: [
                Image.asset(
                  "assets/ic_consultation_ongoing_empty.png",
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
                SizedBox(height: AgoraSpacings.x1_5),
                Text(
                  answeredSectionEmpty
                      ? ConsultationStrings.noOngoingConsultation
                      : ConsultationStrings.ongoingConsultationEmpty,
                  semanticsLabel: SemanticsStrings.ongoingConsultationEmpty,
                  style: AgoraTextStyles.medium14,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AgoraSpacings.base),
                AgoraRoundedButton(
                  label: ConsultationStrings.gotoQags,
                  style: AgoraRoundedButtonStyle.greyBorderButtonStyle,
                  onPressed: () {
                    TrackerHelper.trackClick(
                      clickName: AnalyticsEventNames.gotoQagsFromConsultations,
                      widgetName: AnalyticsScreenNames.consultationsPage,
                    );
                    Navigator.pushNamed(context, QagsPage.routeName);
                  },
                ),
              ],
            ),
          ),
        ),
      );
      ongoingConsultationsWidgets.add(SizedBox(height: AgoraSpacings.base));
    }
    final largerThanMobile = ResponsiveHelper.isLargerThanMobile(context);
    if (largerThanMobile) {
      for (var index = 0; index < ongoingViewModels.length; index = index + 2) {
        final ongoingViewModel1 = ongoingViewModels[index];
        ConsultationOngoingViewModel? ongoingViewModel2;
        if (index + 1 < ongoingViewModels.length) {
          ongoingViewModel2 = ongoingViewModels[index + 1];
        }
        ongoingConsultationsWidgets.add(
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: AgoraConsultationOngoingCard(
                    consultationId: ongoingViewModel1.id,
                    imageUrl: ongoingViewModel1.coverUrl,
                    thematique: ongoingViewModel1.thematique,
                    title: ongoingViewModel1.title,
                    endDate: ongoingViewModel1.endDate,
                    highlightLabel: ongoingViewModel1.label,
                    style: AgoraConsultationOngoingCardStyle.gridLeft,
                  ),
                ),
                ongoingViewModel2 != null
                    ? Expanded(
                        child: AgoraConsultationOngoingCard(
                          consultationId: ongoingViewModel2.id,
                          imageUrl: ongoingViewModel2.coverUrl,
                          thematique: ongoingViewModel2.thematique,
                          title: ongoingViewModel2.title,
                          endDate: ongoingViewModel2.endDate,
                          highlightLabel: ongoingViewModel2.label,
                          style: AgoraConsultationOngoingCardStyle.gridRight,
                        ),
                      )
                    : Expanded(child: Container()),
              ],
            ),
          ),
        );
        ongoingConsultationsWidgets.add(SizedBox(height: AgoraSpacings.base));
      }
    } else {
      for (final ongoingViewModel in ongoingViewModels) {
        ongoingConsultationsWidgets.add(
          AgoraConsultationOngoingCard(
            consultationId: ongoingViewModel.id,
            imageUrl: ongoingViewModel.coverUrl,
            thematique: ongoingViewModel.thematique,
            title: ongoingViewModel.title,
            endDate: ongoingViewModel.endDate,
            highlightLabel: ongoingViewModel.label,
            style: AgoraConsultationOngoingCardStyle.column,
          ),
        );
        ongoingConsultationsWidgets.add(SizedBox(height: AgoraSpacings.base));
      }
    }
    return ongoingConsultationsWidgets;
  }
}
