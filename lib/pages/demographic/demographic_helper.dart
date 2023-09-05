import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
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

  static Widget buildIgnoreButton({required VoidCallback onPressed}) {
    return AgoraButton(
      label: DemographicStrings.ignoreQuestion,
      style: AgoraButtonStyle.blueBorderButtonStyle,
      onPressed: onPressed,
    );
  }

  static Widget buildBackButton({required int step, required VoidCallback onBackTap}) {
    if (step != 1) {
      return AgoraButton(
        label: DemographicStrings.previousQuestion,
        style: AgoraButtonStyle.blueBorderButtonStyle,
        onPressed: onBackTap,
      );
    } else {
      return Container();
    }
  }

  static Widget buildNextButton({required int step, required int totalStep, required VoidCallback onPressed}) {
    return AgoraButton(
      label: step == totalStep ? DemographicStrings.send : DemographicStrings.nextQuestion,
      style: AgoraButtonStyle.primaryButtonStyle,
      onPressed: onPressed,
    );
  }
}
