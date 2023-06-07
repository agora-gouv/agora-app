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
  final _controller = PageController(initialPage: 0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      shouldPop: false,
      appBarColor: AgoraColors.primaryBlue,
      child: _handleStep(context),
    );
  }

  Widget _handleStep(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        OnboardingView(onClick: () => _controller.jumpToPage(1)),
        OnboardingStepView(
          step: OnboardingStep.participate,
          onClick: () => _controller.jumpToPage(2),
        ),
        OnboardingStepView(
          step: OnboardingStep.askYourQuestion,
          onClick: () => _controller.jumpToPage(3),
        ),
        OnboardingStepView(
          step: OnboardingStep.invent,
          onClick: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
