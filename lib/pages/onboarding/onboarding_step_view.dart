import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/agora_step_circle.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_next_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class OnboardingStepView extends StatelessWidget {
  final int step;
  final Function(int step) onClick;

  const OnboardingStepView({super.key, required this.step, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return AgoraSingleScrollView(
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
                AgoraRichText(
                  policeStyle: AgoraRichTextPoliceStyle.police28,
                  items: _buildTitle(),
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
          AgoraStepCircle(currentStep: step, style: AgoraStepCircleStyle.single),
          SizedBox(height: AgoraSpacings.x0_5),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AgoraSpacings.horizontalPadding,
              vertical: AgoraSpacings.base,
            ),
            child: _buildButton(),
          ),
        ],
      ),
    );
  }

  List<AgoraRichTextItem> _buildTitle() {
    switch (step) {
      case 1:
        return [
          AgoraRichTextTextItem(
            text: GenericStrings.onboardingStep1Title1,
            style: AgoraRichTextItemStyle.bold,
          ),
          AgoraRichTextSpaceItem(),
          AgoraRichTextTextItem(
            text: GenericStrings.onboardingStep1Title2,
            style: AgoraRichTextItemStyle.regular,
          ),
        ];
      case 2:
        return [
          AgoraRichTextTextItem(
            text: GenericStrings.onboardingStep2Title1,
            style: AgoraRichTextItemStyle.bold,
          ),
          AgoraRichTextSpaceItem(),
          AgoraRichTextTextItem(
            text: GenericStrings.onboardingStep2Title2,
            style: AgoraRichTextItemStyle.regular,
          ),
        ];
      case 3:
        return [
          AgoraRichTextTextItem(
            text: GenericStrings.onboardingStep3Title1,
            style: AgoraRichTextItemStyle.bold,
          ),
          AgoraRichTextSpaceItem(),
          AgoraRichTextTextItem(
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
      case 1:
        return GenericStrings.onboardingStep1Description;
      case 2:
        return GenericStrings.onboardingStep2Description;
      case 3:
        return GenericStrings.onboardingStep3Description;
      default:
        throw Exception("onboarding : step $step not exists error ");
    }
  }

  String _buildImage() {
    switch (step) {
      case 1:
        return "assets/ic_onboarding_step1.png";
      case 2:
        return "assets/ic_onboarding_step2.png";
      case 3:
        return "assets/ic_onboarding_step3.png";
      default:
        throw Exception("onboarding : step $step not exists error ");
    }
  }

  Widget _buildButton() {
    if (step == 1 || step == 2) {
      return Row(
        children: [
          Spacer(),
          AgoraNextButton(
            icon: "ic_forward.svg",
            onPressed: () => onClick(step),
          ),
        ],
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: AgoraButton(
          label: GenericStrings.onboardingStep0LetsGo,
          style: AgoraButtonStyle.primaryButtonStyle,
          onPressed: () => onClick(step),
        ),
      );
    }
  }
}
