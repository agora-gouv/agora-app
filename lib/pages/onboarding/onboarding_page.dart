import 'dart:math';

import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/onboarding/onboarding_step_view.dart';
import 'package:agora/pages/onboarding/onboarding_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPage extends StatefulWidget {
  static const routeName = "/onboardingPage";

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const totalStep = 4;
  final _controller = PageController(initialPage: 0);
  int step = 0;

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

  Widget _floatingButton(BuildContext context) {
    if (step == 0) return _FloatingNextButton(step: step, onTap: () => _nextPage(context));
    if (step == 3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _LargeFloatingBackActionButton(onTap: () => _previousPage(context)),
          const SizedBox(height: AgoraSpacings.base),
          _FloatingNextButton(step: step, onTap: () => _nextPage(context)),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _BackFloatingButton(onTap: () => _previousPage(context)),
        const SizedBox(width: AgoraSpacings.base),
        Flexible(child: _NextFloatingActionButton(onTap: () => _nextPage(context))),
      ],
    );
  }

  void _nextPage(BuildContext context) {
    setState(() => step++);
    if (step >= totalStep) {
      Navigator.pop(context);
    } else {
      _controller.jumpToPage(step);
    }
  }

  void _previousPage(BuildContext context) {
    setState(() => step--);
    _controller.jumpToPage(step);
  }

  Widget _handleStep(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  step = index;
                });
                _controller.jumpToPage(step);
              },
              children: [
                OnboardingView(),
                OnboardingStepView(step: OnboardingStep.participate),
                OnboardingStepView(step: OnboardingStep.askYourQuestion),
                OnboardingStepView(step: OnboardingStep.invent),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.base),
            child: _floatingButton(context),
          ),
          const SizedBox(height: AgoraSpacings.base),
        ],
      ),
    );
  }
}

class _BackFloatingButton extends StatelessWidget {
  final void Function() onTap;

  _BackFloatingButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AgoraColors.primaryBlue),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Semantics(
            label: SemanticsStrings.previousPage,
            child: Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: SvgPicture.asset(
                  "assets/ic_backward.svg",
                  excludeFromSemantics: true,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NextFloatingActionButton extends StatelessWidget {
  final void Function() onTap;

  _NextFloatingActionButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AgoraColors.primaryBlue,
      onPressed: onTap,
      child: Semantics(
        label: SemanticsStrings.nextPage,
        child: SvgPicture.asset("assets/ic_forward.svg", excludeFromSemantics: true),
      ),
    );
  }
}

class _LargeFloatingBackActionButton extends StatelessWidget {
  final void Function() onTap;

  _LargeFloatingBackActionButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AgoraColors.primaryBlue),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              height: 56,
              width: kIsWeb
                  ? min(MediaQuery.of(context).size.width, ResponsiveHelper.maxScreenSize) -
                  AgoraSpacings.horizontalPadding * 2
                  : MediaQuery.of(context).size.width - AgoraSpacings.horizontalPadding * 2,
              child:
              Center(child: Text('Précédent', style: AgoraTextStyles.primaryBlueTextButton.copyWith(fontSize: 14))),
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingNextButton extends StatelessWidget {
  final int step;
  final void Function() onTap;

  _FloatingNextButton({
    required this.step,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kIsWeb
          ? min(MediaQuery.of(context).size.width, ResponsiveHelper.maxScreenSize) - AgoraSpacings.horizontalPadding * 2
          : MediaQuery.of(context).size.width - AgoraSpacings.horizontalPadding * 2,
      child: FloatingActionButton.extended(
        backgroundColor: AgoraColors.primaryBlue,
        label: Text(step == 0 ? ConsultationStrings.beginButton : GenericStrings.onboardingStep3LetsGo),
        onPressed: onTap,
      ),
    );
  }
}
