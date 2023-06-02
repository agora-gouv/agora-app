import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/pages/onboarding/onboarding_step_view.dart';
import 'package:agora/pages/onboarding/onboarding_view.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  static const routeName = "/onboardingPage";

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int step = 0;

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      appBarColor: AgoraColors.primaryBlue,
      child: _handleStep(context),
    );
  }

  Widget _handleStep(BuildContext context) {
    if (step == 0) {
      return OnboardingView(onClick: () => setState(() => step = 1));
    } else {
      return OnboardingStepView(
        step: step,
        onClick: (currentStep) {
          if (currentStep == 1) {
            setState(() => step = 2);
          } else if (currentStep == 2) {
            setState(() => step = 3);
          } else {
            Navigator.pop(context);
          }
        },
      );
    }
  }
}
