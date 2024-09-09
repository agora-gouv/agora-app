import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:flutter/material.dart';

class ConsultationQuestionHelper {
  static Widget buildBackButton({required int order, required VoidCallback onBackTap}) {
    if (order != 1) {
      return AgoraButton.withLabel(
        label: ConsultationStrings.previousQuestion,
        semanticLabel: SemanticsStrings.previousQuestion,
        buttonStyle: AgoraButtonStyle.secondary,
        onPressed: onBackTap,
      );
    } else {
      return Container();
    }
  }

  static Widget buildNextQuestion({
    required bool isLastQuestion,
    required VoidCallback? onPressed,
  }) {
    return AgoraButton.withLabel(
      label: isLastQuestion ? ConsultationStrings.validate : ConsultationStrings.nextQuestion,
      semanticLabel: isLastQuestion ? ConsultationStrings.validate : SemanticsStrings.nextQuestion,
      buttonStyle: AgoraButtonStyle.primary,
      onPressed: onPressed,
    );
  }

  static Widget buildIgnoreButton({required VoidCallback onPressed}) {
    return AgoraButton.withLabel(
      label: ConsultationStrings.ignoreQuestion,
      semanticLabel: SemanticsStrings.ignoreQuestion,
      buttonStyle: AgoraButtonStyle.secondary,
      onPressed: onPressed,
    );
  }
}
