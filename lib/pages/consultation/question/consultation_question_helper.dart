import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:flutter/material.dart';

class ConsultationQuestionHelper {
  static Widget buildBackButton({required int order, required VoidCallback onBackTap}) {
    if (order != 1) {
      return AgoraButton(
        label: ConsultationStrings.previousQuestion,
        semanticLabel: SemanticsStrings.previousQuestion,
        style: AgoraButtonStyle.blueBorderButtonStyle,
        onPressed: onBackTap,
      );
    } else {
      return Container();
    }
  }

  static Widget buildNextQuestion({required int order, required totalQuestions, required VoidCallback? onPressed}) {
    return AgoraButton(
      label: order == totalQuestions ? ConsultationStrings.validate : ConsultationStrings.nextQuestion,
      semanticLabel: order == totalQuestions ? ConsultationStrings.validate : SemanticsStrings.nextQuestion,
      style: AgoraButtonStyle.primaryButtonStyle,
      onPressed: onPressed,
    );
  }

  static Widget buildIgnoreButton({required VoidCallback onPressed}) {
    return AgoraButton(
      label: ConsultationStrings.ignoreQuestion,
      semanticLabel: SemanticsStrings.ignoreQuestion,
      style: AgoraButtonStyle.blueBorderButtonStyle,
      onPressed: onPressed,
    );
  }
}
