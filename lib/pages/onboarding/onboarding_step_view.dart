import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/agora_step_circle.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

enum OnboardingStep { participate, askYourQuestion, invent }

class OnboardingStepView extends StatelessWidget {
  final OnboardingStep step;

  const OnboardingStepView({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return AgoraSingleScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          AgoraTopDiagonal(),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AgoraSpacings.horizontalPadding,
              vertical: AgoraSpacings.x1_25,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  focused: true,
                  child: AgoraRichText(
                    policeStyle: AgoraRichTextPoliceStyle.police28,
                    items: _buildTitle(),
                  ),
                ),
                SizedBox(height: AgoraSpacings.x1_5),
                Text(_buildDescription(), style: AgoraTextStyles.light18),
              ],
            ),
          ),
          SizedBox(height: AgoraSpacings.base),
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                color: AgoraColors.doctor,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Image.asset(_buildImage(), excludeFromSemantics: true),
              ),
            ],
          ),
          SizedBox(height: AgoraSpacings.x2),
          AgoraStepCircle(currentStep: _buildStep(), style: AgoraStepCircleStyle.single),
          SizedBox(height: AgoraSpacings.x0_5),
          Spacer(),
          SizedBox(height: AgoraSpacings.x3),
        ],
      ),
    );
  }

  List<AgoraRichTextItem> _buildTitle() {
    switch (step) {
      case OnboardingStep.participate:
        return [
          AgoraRichTextItem(
            text: GenericStrings.onboardingStep1Title1,
            style: AgoraRichTextItemStyle.bold,
          ),
          AgoraRichTextItem(
            text: GenericStrings.onboardingStep1Title2,
            style: AgoraRichTextItemStyle.regular,
          ),
        ];
      case OnboardingStep.askYourQuestion:
        return [
          AgoraRichTextItem(
            text: GenericStrings.onboardingStep2Title1,
            style: AgoraRichTextItemStyle.bold,
          ),
          AgoraRichTextItem(
            text: GenericStrings.onboardingStep2Title2,
            style: AgoraRichTextItemStyle.regular,
          ),
        ];
      case OnboardingStep.invent:
        return [
          AgoraRichTextItem(
            text: GenericStrings.onboardingStep3Title1,
            style: AgoraRichTextItemStyle.bold,
          ),
          AgoraRichTextItem(
            text: GenericStrings.onboardingStep3Title2,
            style: AgoraRichTextItemStyle.regular,
          ),
        ];
      default:
        throw Exception("onboarding : step $step not exists error ");
    }
  }

  String _buildDescription() {
    switch (step) {
      case OnboardingStep.participate:
        return GenericStrings.onboardingStep1Description;
      case OnboardingStep.askYourQuestion:
        return GenericStrings.onboardingStep2Description;
      case OnboardingStep.invent:
        return GenericStrings.onboardingStep3Description;
    }
  }

  String _buildImage() {
    switch (step) {
      case OnboardingStep.participate:
        return "assets/ic_onboarding_step1.png";
      case OnboardingStep.askYourQuestion:
        return "assets/ic_onboarding_step2.png";
      case OnboardingStep.invent:
        return "assets/ic_onboarding_step3.png";
    }
  }

  int _buildStep() {
    switch (step) {
      case OnboardingStep.participate:
        return 1;
      case OnboardingStep.askYourQuestion:
        return 2;
      case OnboardingStep.invent:
        return 3;
    }
  }
}
