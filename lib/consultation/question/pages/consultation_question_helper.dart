import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:flutter/material.dart';

class ConsultationQuestionHelper {
  static Widget buildBackButton({required int order, required VoidCallback onBackTap}) {
    if (order != 1) {
      return AgoraButton(
        label: ConsultationStrings.previousQuestion,
        semanticLabel: SemanticsStrings.previousQuestion,
        style: AgoraButtonStyle.blueBorder,
        onTap: onBackTap,
      );
    } else {
      return Container();
    }
  }

  static Widget buildNextQuestion({
    required bool isLastQuestion,
    required void Function() onTap,
  }) {
    return AgoraButton(
      label: isLastQuestion ? ConsultationStrings.validate : ConsultationStrings.nextQuestion,
      semanticLabel: isLastQuestion ? ConsultationStrings.validate : SemanticsStrings.nextQuestion,
      style: AgoraButtonStyle.primary,
      onTap: onTap,
    );
  }

  static Widget buildIgnoreButton({required VoidCallback onPressed}) {
    return AgoraButton(
      label: ConsultationStrings.ignoreQuestion,
      semanticLabel: SemanticsStrings.ignoreQuestion,
      style: AgoraButtonStyle.blueBorder,
      onTap: onPressed,
    );
  }
}
