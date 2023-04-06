import 'package:agora/design/agora_button.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:agora/string/consultation_strings.dart';
import 'package:flutter/material.dart';

class ConsultationQuestionConfirmationPage extends StatelessWidget {
  static const routeName = "/consultationQuestionConfirmationPage";

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      shouldPop: false,
      child: Column(
        children: [
          AgoraTopDiagonal(),
          Image.asset("assets/ic_question_confirmation.png"),
          Padding(
            padding: const EdgeInsets.all(AgoraSpacings.x1_5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ConsultationString.confirmationTitle,
                  style: AgoraTextStyles.medium19,
                ),
                SizedBox(height: AgoraSpacings.base),
                Text(
                  ConsultationString.confirmationDescription,
                  style: AgoraTextStyles.light16,
                ),
                SizedBox(height: AgoraSpacings.x1_5),
                AgoraButton(
                  label: ConsultationString.goToResult,
                  style: AgoraButtonStyle.primaryButtonStyle,
                  onPressed: () {
                    // TODO next ticket go to result
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      LoadingPage.routeName,
                      (route) => false,
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
