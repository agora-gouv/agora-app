import 'package:agora/common/strings/qag_strings.dart';
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
    SemanticsService.announce('La liste des questions au gouvernement a changé', TextDirection.ltr);
  }

  static void announceEmptyResult() {
    SemanticsService.announce('Pas de résultats', TextDirection.ltr);
  }

  static void announceThematicChosen(String? thematic, int size) {
    SemanticsService.announce('Filtré par $thematic, $size résultats', TextDirection.ltr);
  }

  static void announceCollapsing(bool isCollapsed) {
    if (isCollapsed) {
      SemanticsService.announce('Catégorie depliée', TextDirection.ltr);
    } else {
      SemanticsService.announce('Catégorie repliée', TextDirection.ltr);
    }
  }

  static void announceErrorInQuestion() {
    SemanticsService.announce(QagStrings.questionRequiredCondition, TextDirection.ltr);
  }

  static void announceGenericError() {
    SemanticsService.announce('Une erreur est survenue', TextDirection.ltr);
  }

  static void announcePlayPause(bool isPlaying) {
    if (isPlaying) {
      SemanticsService.announce('Pause', TextDirection.ltr);
    } else {
      SemanticsService.announce('Lecture', TextDirection.ltr);
    }
  }

  static void announceMuteUnmute(bool isMuted) {
    if (isMuted) {
      SemanticsService.announce('Son activé', TextDirection.ltr);
    } else {
      SemanticsService.announce('Son désactivé', TextDirection.ltr);
    }
  }

  static void announceSubtitles(bool areSubtitleEnabled) {
    if (areSubtitleEnabled) {
      SemanticsService.announce('Sous-titres désactivés', TextDirection.ltr);
    } else {
      SemanticsService.announce('Sous-titres sactivés', TextDirection.ltr);
    }
  }
}

class SemanticsHelperWrapper {
  const SemanticsHelperWrapper();

  void announceThematicChosen(String? thematic, int size) {
    SemanticsHelper.announceThematicChosen(thematic, size);
  }
}
