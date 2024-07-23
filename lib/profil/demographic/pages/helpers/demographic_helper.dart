import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:flutter/material.dart';

class DemographicHelper {
  static String getQuestionTitle(int step) {
    switch (step) {
      case 1:
        return DemographicStrings.question1;
      case 2:
        return DemographicStrings.question2;
      case 3:
        return DemographicStrings.question3;
      case 4:
        return DemographicStrings.question4;
      case 5:
        return DemographicStrings.question5;
      case 6:
        return DemographicStrings.question6;
      default:
        throw Exception("Demographic question title step not exists error");
    }
  }

  static Widget buildBackButton({required int step, required VoidCallback onBackTap}) {
    if (step != 1) {
      return AgoraButton(
        label: DemographicStrings.previousQuestion,
        semanticLabel: SemanticsStrings.previousQuestion,
        style: AgoraButtonStyle.blueBorder,
        onTap: onBackTap,
      );
    } else {
      return Container();
    }
  }

  static Widget buildNextButton({required int step, required int totalStep, required VoidCallback onPressed}) {
    return AgoraButton(
      label: step == totalStep ? DemographicStrings.send : DemographicStrings.nextQuestion,
      semanticLabel: step == totalStep ? DemographicStrings.send : SemanticsStrings.nextQuestion,
      style: AgoraButtonStyle.primary,
      onTap: onPressed,
    );
  }

  static Widget buildIgnoreButton({required VoidCallback onPressed}) {
    return AgoraButton(
      label: DemographicStrings.ignoreQuestion,
      semanticLabel: SemanticsStrings.ignoreQuestion,
      style: AgoraButtonStyle.blueBorder,
      onTap: onPressed,
    );
  }
}
