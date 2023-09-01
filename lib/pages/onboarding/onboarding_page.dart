import 'dart:math';

import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
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
      floatingActionButton: Theme(
        data: _floatingButtonStyle(context),
        child: _floatingButton(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      child: _handleStep(context),
    );
  }

  ThemeData _floatingButtonStyle(BuildContext context) {
    return Theme.of(context).copyWith(
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: _isSmallFloatingButtonStyle()
            ? null
            : RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded)),
        extendedSizeConstraints: BoxConstraints.tightFor(height: AgoraSpacings.x3),
        extendedPadding: EdgeInsets.symmetric(horizontal: AgoraSpacings.x0_75),
        extendedTextStyle: AgoraTextStyles.primaryFloatingButton,
      ),
    );
  }

  Widget _floatingButton(BuildContext context) {
    if (_isSmallFloatingButtonStyle()) {
      return _smallFloatingActionButton(context);
    } else {
      return _largeFloatingActionButton(context);
    }
  }

  bool _isSmallFloatingButtonStyle() => step == 1 || step == 2;

  Widget _smallFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AgoraColors.primaryBlue,
      child: Semantics(
        label: SemanticsStrings.nextPage,
        child: SvgPicture.asset("assets/ic_forward.svg", excludeFromSemantics: true),
      ),
      onPressed: () => _nextPage(context),
    );
  }

  Widget _largeFloatingActionButton(BuildContext context) {
    return SizedBox(
      width: kIsWeb
          ? min(MediaQuery.of(context).size.width, ResponsiveHelper.maxScreenSize) - AgoraSpacings.horizontalPadding * 2
          : MediaQuery.of(context).size.width - AgoraSpacings.horizontalPadding * 2,
      child: FloatingActionButton.extended(
        backgroundColor: AgoraColors.primaryBlue,
        label: Text(step == 0 ? ConsultationStrings.beginButton : GenericStrings.onboardingStep3LetsGo),
        onPressed: () => _nextPage(context),
      ),
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

  Widget _handleStep(BuildContext context) {
    return PageView(
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
    );
  }
}
