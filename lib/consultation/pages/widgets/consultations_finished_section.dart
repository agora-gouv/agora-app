import 'dart:math';

import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/list_extension.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/consultation/bloc/consultation_view_model.dart';
import 'package:agora/consultation/dynamic/pages/dynamic_consultation_page.dart';
import 'package:agora/consultation/finished_paginated/pages/consultation_finished_paginated_page.dart';
import 'package:agora/design/custom_view/agora_focus_helper.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/card/agora_consultation_finished_card.dart';
import 'package:agora/design/custom_view/card/agora_rounded_card.dart';
import 'package:agora/design/custom_view/scroll/agora_horizontal_scroll_helper.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intersperse/intersperse.dart';

class ConsultationsFinishedSection extends StatelessWidget {
  final List<ConsultationViewModel> finishedViewModels;
  final bool shouldDisplayAllButton;

  ConsultationsFinishedSection({
    required this.finishedViewModels,
    required this.shouldDisplayAllButton,
  });

  final firstFocusableElementKey = GlobalKey();

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
                        semantic: AgoraRichTextSemantic(label: SemanticsStrings.consultationTerminees),
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
                      AgoraButton.withLabel(
                        label: GenericStrings.all,
                        semanticLabel: "voir toutes les consultations terminées",
                        buttonStyle: AgoraButtonStyle.tertiary,
                        onPressed: () => Navigator.pushNamed(
                          context,
                          ConsultationFinishedPaginatedPage.routeName,
                          arguments: ConsultationPaginatedPageType.finished,
                        ),
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
                              AgoraFocusHelper(
                                elementKey: firstFocusableElementKey,
                                child: SingleChildScrollView(
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
                              ),
                              const SizedBox(height: AgoraSpacings.base),
                              ExcludeSemantics(
                                child: HorizontalScrollHelper(
                                  itemsCount: finishedViewModels.length,
                                  scrollController: scrollController,
                                  key: _consultationScrollHelperKey,
                                ),
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
    return finishedViewModels
        .mapIndexed<Widget>((index, finishedViewModel) {
          return AgoraConsultationFinishedCard(
            key: index == 0 ? firstFocusableElementKey : null,
            id: finishedViewModel.id,
            titre: finishedViewModel.title,
            thematique: finishedViewModel.thematique,
            imageUrl: finishedViewModel.coverUrl,
            flammeLabel: finishedViewModel.label,
            style: AgoraConsultationFinishedStyle.carrousel,
            onTap: () {
              TrackerHelper.trackClick(
                clickName: "${AnalyticsEventNames.finishedConsultation} ${finishedViewModel.id}",
                widgetName: AnalyticsScreenNames.consultationsPage,
              );
              if (finishedViewModel is ConsultationFinishedViewModel) {
                Navigator.pushNamed(
                  context,
                  DynamicConsultationPage.routeName,
                  arguments: DynamicConsultationPageArguments(
                    consultationIdOrSlug: finishedViewModel.id,
                    consultationTitle: finishedViewModel.title,
                    shouldReloadConsultationsWhenPop: false,
                  ),
                );
              } else if (finishedViewModel is ConcertationViewModel) {
                LaunchUrlHelper.webview(context, finishedViewModel.externalLink);
              }
            },
            isExternalLink: finishedViewModel is ConcertationViewModel,
            index: finishedViewModels.indexOf(finishedViewModel) + 1,
            maxIndex: finishedViewModels.length + 1,
            badgeLabel: finishedViewModel.badgeLabel,
            badgeColor: finishedViewModel.badgeColor,
            badgeTextColor: finishedViewModel.badgeTextColor,
          );
        })
        .plus(_ViewAllCard(finishedViewModels.length + 1))
        .intersperse(SizedBox(width: AgoraSpacings.x0_5))
        .plus(SizedBox(width: AgoraSpacings.x0_5))
        .toList();
  }
}

class _ViewAllCard extends StatelessWidget {
  final int maxIndex;

  _ViewAllCard(this.maxIndex);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: max(MediaQuery.of(context).size.width * 0.5, AgoraSpacings.carrouselMinWidth),
      child: Semantics(
        tooltip: "Élément $maxIndex sur $maxIndex",
        button: true,
        child: AgoraRoundedCard(
          borderColor: AgoraColors.border,
          cardColor: AgoraColors.white,
          onTap: () {
            Navigator.pushNamed(
              context,
              ConsultationFinishedPaginatedPage.routeName,
              arguments: ConsultationPaginatedPageType.finished,
            );
          },
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Voir toutes les consultations',
                  style: AgoraTextStyles.regular16,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AgoraSpacings.base),
                SvgPicture.asset(
                  "assets/ic_forward.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(AgoraColors.primaryGreyOpacity70, BlendMode.srcIn),
                  excludeFromSemantics: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final _consultationScrollHelperKey = GlobalKey();
