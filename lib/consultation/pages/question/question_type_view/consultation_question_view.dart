import 'package:agora/design/custom_view/agora_bottom_sheet.dart';
import 'package:agora/design/custom_view/agora_html.dart';
import 'package:agora/design/custom_view/agora_more_information.dart';
import 'package:agora/design/custom_view/agora_questions_progress_bar.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/common/parser/string_parser.dart';
import 'package:flutter/material.dart';

final _barKey = GlobalKey();

class ConsultationQuestionView extends StatelessWidget {
  final int order;
  final int currentQuestionIndex;
  final int totalQuestions;
  final bool isLastQuestion;
  final List<StringSegment> title;
  final String? popupDescription;
  final Widget child;
  final ScrollController? scrollController;

  ConsultationQuestionView({
    super.key,
    required this.order,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.isLastQuestion,
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
                        key: _barKey,
                        currentQuestionIndex: currentQuestionIndex,
                        totalQuestions: totalQuestions,
                        isLastQuestion: isLastQuestion,
                      ),
                      SizedBox(height: AgoraSpacings.x0_75),
                      Text(
                        'Question $currentQuestionIndex',
                        style: AgoraTextStyles.medium16,
                      ),
                      SizedBox(height: AgoraSpacings.base),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: AgoraSpacings.textAlignment),
                              child: _Title(
                                texte: title,
                                textStyle: AgoraTextStyles.medium20.copyWith(color: AgoraColors.primaryBlue),
                              ),
                            ),
                          ),
                          if (popupDescription != null) ...[
                            SizedBox(width: AgoraSpacings.x0_25),
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
                      SizedBox(height: AgoraSpacings.x0_5),
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

class _Title extends StatelessWidget {
  final List<StringSegment> texte;
  final TextStyle textStyle;

  const _Title({required this.texte, this.textStyle = AgoraTextStyles.medium19});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: texte
            .map(
              (segment) => TextSpan(
                text: segment.text,
                style: textStyle,
                semanticsLabel: segment.isEmoji ? '' : segment.text,
              ),
            )
            .toList(),
      ),
    );
  }
}
