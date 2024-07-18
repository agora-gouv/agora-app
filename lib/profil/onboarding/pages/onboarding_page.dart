import 'dart:math';

import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/common/helper/semantics_helper.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/common/strings/tutoriel_strings.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/profil/onboarding/pages/onboarding_step_view.dart';
import 'package:agora/profil/onboarding/pages/onboarding_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPage extends StatefulWidget {
  static const routeName = "/onboardingPage";

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with SingleTickerProviderStateMixin {
  static const totalStep = 4;
  final _controller = PageController(initialPage: 0);
  int step = 0;
  AnimationController? animationController;
  final backButtonFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(minutes: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    animationController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      shouldPop: false,
      appBarType: AppBarColorType.primaryColor,
      child: _handleStep(context),
    );
  }

  Widget _floatingButton(BuildContext context) {
    if (step == 0) return _FloatingNextButton(step: step, onTap: () => _nextPage(context));
    if (step == 3) {
      return _FloatingNextButton(step: step, onTap: () => _nextPage(context));
    }
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _BackFloatingButton(backButtonFocusNode: backButtonFocusNode, onTap: () => _previousPage(context)),
        const SizedBox(width: AgoraSpacings.base),
        Flexible(child: _NextFloatingActionButton(onTap: () => _nextPage(context))),
      ],
    );
  }

  void _nextPage(BuildContext context) {
    backButtonFocusNode.requestFocus();
    setState(() => step++);
    if (step >= totalStep) {
      Navigator.pop(context);
    } else {
      _controller.jumpToPage(step);
    }
  }

  void _previousPage(BuildContext context) {
    backButtonFocusNode.requestFocus();
    setState(() => step--);
    _controller.jumpToPage(step);
  }

  Widget _handleStep(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
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
                    OnboardingView(animationController),
                    OnboardingStepView(step: OnboardingStep.question),
                    OnboardingStepView(step: OnboardingStep.reponse),
                    OnboardingStepView(step: OnboardingStep.consultation),
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
          if (step == 3)
            Positioned(
              left: AgoraSpacings.base,
              bottom: AgoraSpacings.base * 2 + 56,
              child: _BackFloatingButton(backButtonFocusNode: backButtonFocusNode, onTap: () => _previousPage(context)),
            ),
          if (step == 0)
            Positioned(
              left: AgoraSpacings.base,
              bottom: AgoraSpacings.base * 2 + 56,
              child: _PauseButton(
                onTap: (isPlaying) {
                  if (isPlaying) {
                    animationController?.stop();
                  } else {
                    animationController?.forward();
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _BackFloatingButton extends StatelessWidget {
  final FocusNode backButtonFocusNode;
  final void Function() onTap;

  _BackFloatingButton({
    required this.backButtonFocusNode,
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
          focusNode: backButtonFocusNode,
          borderRadius: BorderRadius.circular(14),
          focusColor: AgoraColors.neutral400,
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
      focusColor: AgoraColors.neutral400,
      backgroundColor: AgoraColors.primaryBlue,
      onPressed: onTap,
      child: Semantics(
        label: SemanticsStrings.nextPage,
        child: SvgPicture.asset("assets/ic_forward.svg", excludeFromSemantics: true),
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
        focusColor: AgoraColors.neutral400,
        backgroundColor: AgoraColors.primaryBlue,
        label: Text(
          step == 0 ? TutorielStrings.beginButton : TutorielStrings.tutoStep3LetsGo,
          semanticsLabel: step == 0 ? SemanticsStrings.onboardingBegin : SemanticsStrings.onboardingLastStepButton,
          style: AgoraTextStyles.primaryFloatingButton,
        ),
        onPressed: onTap,
      ),
    );
  }
}

class _PauseButton extends StatefulWidget {
  final void Function(bool) onTap;

  _PauseButton({
    required this.onTap,
  });

  @override
  State<_PauseButton> createState() => _PauseButtonState();
}

class _PauseButtonState extends State<_PauseButton> {
  bool isPlaying = true;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isPlaying ? SemanticsStrings.animPause : SemanticsStrings.animPlay,
      button: true,
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AgoraColors.primaryBlue, width: 2),
          color: AgoraColors.white,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            focusColor: AgoraColors.neutral400,
            onTap: () {
              SemanticsHelper.announceOnboardingAnimationStatus(isPlaying);
              widget.onTap(isPlaying);
              setState(() {
                isPlaying = !isPlaying;
              });
            },
            child: Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow_sharp,
                  color: AgoraColors.primaryBlue,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
