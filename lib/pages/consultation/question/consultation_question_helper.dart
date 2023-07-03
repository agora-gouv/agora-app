import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConsultationQuestionHelper {
  static List<Widget> buildBackButton({required int order, required VoidCallback onBackTap}) {
    if (order != 1) {
      return [
        SizedBox(height: AgoraSpacings.x1_5),
        InkWell(
          onTap: () => onBackTap(),
          child: Container(
            padding: EdgeInsets.only(bottom: AgoraSpacings.x0_25),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AgoraColors.primaryBlue, width: 1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset("assets/ic_backward.svg"),
                SizedBox(width: AgoraSpacings.base),
                Flexible(
                  child: Text(
                    ConsultationStrings.previousQuestion,
                    style: AgoraTextStyles.light16.copyWith(color: AgoraColors.primaryBlue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ];
    } else {
      return [];
    }
  }

  static String buildNextButtonLabel({required int order, required totalQuestions}) {
    return order == totalQuestions ? ConsultationStrings.validate : ConsultationStrings.nextQuestion;
  }

  static List<Widget> buildIgnoreButton({required VoidCallback onPressed}) {
    return [
      SizedBox(height: AgoraSpacings.x1_5),
      AgoraButton(
        label: ConsultationStrings.ignoreQuestion,
        style: AgoraButtonStyle.blueBorderButtonStyle,
        onPressed: onPressed,
      )
    ];
  }
}
