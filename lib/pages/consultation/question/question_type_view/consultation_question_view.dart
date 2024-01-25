import 'package:agora/design/custom_view/agora_bottom_sheet.dart';
import 'package:agora/design/custom_view/agora_html.dart';
import 'package:agora/design/custom_view/agora_more_information.dart';
import 'package:agora/design/custom_view/agora_questions_progress_bar.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class ConsultationQuestionView extends StatelessWidget {
  final int order;
  final int totalQuestions;
  final String questionProgress;
  final String questionProgressSemanticLabel;
  final String title;
  final String? popupDescription;
  final Widget child;
  final ScrollController? scrollController;

  ConsultationQuestionView({
    super.key,
    required this.order,
    required this.totalQuestions,
    required this.questionProgress,
    required this.questionProgressSemanticLabel,
    required this.title,
    required this.popupDescription,
    required this.child,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AgoraToolbar(style: AgoraToolbarStyle.close, pageLabel: 'Questionnaire de la consultation'),
        Expanded(
          child: AgoraSingleScrollView(
            scrollController: scrollController,
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AgoraQuestionsProgressBar(
                        currentQuestionOrder: order,
                        totalQuestions: totalQuestions,
                      ),
                      SizedBox(height: AgoraSpacings.x0_75),
                      Text(
                        questionProgress,
                        style: AgoraTextStyles.medium16,
                        semanticsLabel: questionProgressSemanticLabel,
                      ),
                      SizedBox(height: AgoraSpacings.base),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child:
                                Text(title, style: AgoraTextStyles.medium20.copyWith(color: AgoraColors.primaryBlue)),
                          ),
                          if (popupDescription != null) ...[
                            SizedBox(width: AgoraSpacings.x0_75),
                            AgoraMoreInformation(
                              onClick: () {
                                showAgoraBottomSheet(
                                  context: context,
                                  columnChildren: [
                                    AgoraHtml(data: popupDescription!),
                                    SizedBox(height: AgoraSpacings.x0_75),
                                  ],
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: AgoraSpacings.x0_75),
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    width: double.infinity,
                    color: AgoraColors.background,
                    child: Padding(
                      padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
