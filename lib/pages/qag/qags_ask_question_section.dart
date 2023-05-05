import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_title_rich_text.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/pages/qag/ask_question/qag_ask_question_page.dart';
import 'package:flutter/material.dart';

class QagsAskQuestionSectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        top: AgoraSpacings.x3,
        right: AgoraSpacings.horizontalPadding,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AgoraRichText(
                  items: [
                    AgoraRichTextTextItem(text: "${QagStrings.allQagPart1}\n", style: AgoraRichTextItemStyle.regular),
                    AgoraRichTextTextItem(text: QagStrings.allQagPart2, style: AgoraRichTextItemStyle.bold),
                  ],
                ),
              ),
              AgoraRoundedButton(
                label: QagStrings.askQuestion,
                onPressed: () {
                  Navigator.pushNamed(context, QagAskQuestionPage.routeName);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
