import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/pages/qag/ask_question/qag_ask_question_page.dart';
import 'package:flutter/material.dart';

class QagsAskQuestionSectionPage extends StatelessWidget {
  final String? errorCase;

  const QagsAskQuestionSectionPage({super.key, required this.errorCase});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        top: AgoraSpacings.base,
        right: AgoraSpacings.horizontalPadding,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AgoraRichText(
                  items: [
                    AgoraRichTextItem(text: "${QagStrings.allQagPart1}\n", style: AgoraRichTextItemStyle.regular),
                    AgoraRichTextItem(text: QagStrings.allQagPart2, style: AgoraRichTextItemStyle.bold),
                  ],
                ),
              ),
              AgoraRoundedButton(
                label: QagStrings.askQuestion,
                onPressed: () {
                  TrackerHelper.trackClick(
                    clickName: AnalyticsEventNames.askQuestion,
                    widgetName: AnalyticsScreenNames.qagsPage,
                  );
                  Navigator.pushNamed(context, QagAskQuestionPage.routeName, arguments: errorCase);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
