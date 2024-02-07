import 'package:agora/bloc/consultation/consultation_view_model.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/custom_view/agora_consultation_finished_card.dart';
import 'package:agora/design/custom_view/agora_horizontal_scroll_helper.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/finished_paginated/consultation_finished_paginated_page.dart';
import 'package:agora/pages/consultation/summary/consultation_summary_page.dart';
import 'package:flutter/material.dart';

class ConsultationsFinishedSection extends StatelessWidget {
  final List<ConsultationFinishedViewModel> finishedViewModels;
  final bool shouldDisplayAllButton;

  const ConsultationsFinishedSection({
    super.key,
    required this.finishedViewModels,
    required this.shouldDisplayAllButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AgoraSpacings.base),
        Container(
          color: AgoraColors.doctor,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AgoraSpacings.horizontalPadding,
              vertical: AgoraSpacings.x1_25,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AgoraRichText(
                        items: [
                          AgoraRichTextItem(
                            text: "${ConsultationStrings.finishConsultationPart1}\n",
                            style: AgoraRichTextItemStyle.regular,
                          ),
                          AgoraRichTextItem(
                            text: ConsultationStrings.finishConsultationPart2,
                            style: AgoraRichTextItemStyle.bold,
                          ),
                        ],
                      ),
                    ),
                    if (shouldDisplayAllButton) ...[
                      SizedBox(width: AgoraSpacings.x0_75),
                      AgoraRoundedButton(
                        label: GenericStrings.all,
                        style: AgoraRoundedButtonStyle.greyBorderButtonStyle,
                        onPressed: () => Navigator.pushNamed(context, ConsultationFinishedPaginatedPage.routeName),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: AgoraSpacings.base),
                finishedViewModels.isEmpty
                    ? Column(
                        children: [
                          SizedBox(height: AgoraSpacings.x0_5),
                          Text(ConsultationStrings.consultationEmpty, style: AgoraTextStyles.medium14),
                          SizedBox(height: AgoraSpacings.base),
                        ],
                      )
                    : LayoutBuilder(
                        builder: (context, constraint) {
                          final scrollController = ScrollController();
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                controller: scrollController,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(minWidth: constraint.maxWidth),
                                  child: IntrinsicHeight(
                                    child: Row(children: _buildFinishedConsultations(context)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AgoraSpacings.base),
                              HorizontalScrollHelper(
                                itemsCount: finishedViewModels.length,
                                scrollController: scrollController,
                              ),
                            ],
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildFinishedConsultations(BuildContext context) {
    final List<Widget> finishedConsultationsWidget = List.empty(growable: true);
    for (final finishedViewModel in finishedViewModels) {
      finishedConsultationsWidget.add(
        AgoraConsultationFinishedCard(
          id: finishedViewModel.id,
          title: finishedViewModel.title,
          thematique: finishedViewModel.thematique,
          imageUrl: finishedViewModel.coverUrl,
          step: finishedViewModel.step,
          style: AgoraConsultationFinishedStyle.carrousel,
          onClick: () {
            TrackerHelper.trackClick(
              clickName: "${AnalyticsEventNames.finishedConsultation} ${finishedViewModel.id}",
              widgetName: AnalyticsScreenNames.consultationsPage,
            );
            Navigator.pushNamed(
              context,
              ConsultationSummaryPage.routeName,
              arguments: ConsultationSummaryArguments(
                consultationId: finishedViewModel.id,
                shouldReloadConsultationsWhenPop: false,
                initialTab: ConsultationSummaryInitialTab.etEnsuite,
              ),
            );
          },
          index: finishedViewModels.indexOf(finishedViewModel) + 1,
          maxIndex: finishedViewModels.length,
        ),
      );
      finishedConsultationsWidget.add(SizedBox(width: AgoraSpacings.x0_5));
    }
    return finishedConsultationsWidget;
  }
}
