import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/pages/onboarding/onboarding_step0_view.dart';
import 'package:agora/pages/onboarding/onboarding_step1_view.dart';
import 'package:agora/pages/onboarding/onboarding_step2_view.dart';
import 'package:agora/pages/onboarding/onboarding_step3_view.dart';
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
      child: _handleStep(context),
    );
  }

  Widget _handleStep(BuildContext context) {
    switch (step) {
      case 0:
        return OnboardingStep0View(onClick: () => setState(() => step = 1));
      case 1:
        return OnboardingStep1View(onClick: () => setState(() => step = 2));
      case 2:
        return OnboardingStep2View(onClick: () => setState(() => step = 3));
      case 3:
        return OnboardingStep3View(onClick: () => Navigator.pop(context));
      default:
        throw Exception("Onboarding: step not handle");
    }
  }
}
