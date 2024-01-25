import 'package:agora/common/strings/semantics_strings.dart';
import 'package:flutter/semantics.dart';

class SemanticsHelper {
  static String cardResponse({
    required String responseLabel,
    required int currentStep,
    required int totalStep,
  }) {
    return "$responseLabel, ${step(currentStep, totalStep)}";
  }

  static String selected(bool isSelected) {
    return isSelected ? SemanticsStrings.select : SemanticsStrings.noSelect;
  }

  static String step(int currentStep, int totalStep) {
    return "$currentStep sur $totalStep";
  }

  static void announceNewQagsInList() {
    SemanticsService.announce('La liste des questions au gourvernement a changé', TextDirection.ltr);
  }
}
