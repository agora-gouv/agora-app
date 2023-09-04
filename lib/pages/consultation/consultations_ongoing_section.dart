import 'package:agora/bloc/consultation/consultation_view_model.dart';
import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/agora_consultation_ongoing_card.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class ConsultationsOngoingSection extends StatelessWidget {
  final List<ConsultationOngoingViewModel> ongoingViewModels;

  const ConsultationsOngoingSection({super.key, required this.ongoingViewModels});

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
                  ConsultationStrings.ongoingConsultationEmpty,
                  semanticsLabel: SemanticsStrings.ongoingConsultationEmpty,
                  style: AgoraTextStyles.medium14,
                  textAlign: TextAlign.center,
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
                    hasAnswered: ongoingViewModel1.hasAnswered,
                    highlightLabel: ongoingViewModel1.highlightLabel,
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
                          hasAnswered: ongoingViewModel2.hasAnswered,
                          highlightLabel: ongoingViewModel2.highlightLabel,
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
            hasAnswered: ongoingViewModel.hasAnswered,
            highlightLabel: ongoingViewModel.highlightLabel,
            style: AgoraConsultationOngoingCardStyle.column,
          ),
        );
        ongoingConsultationsWidgets.add(SizedBox(height: AgoraSpacings.base));
      }
    }
    return ongoingConsultationsWidgets;
  }
}
