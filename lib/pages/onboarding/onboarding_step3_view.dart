import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/agora_step_circle.dart';
import 'package:agora/design/custom_view/agora_title_rich_text.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class OnboardingStep3View extends StatelessWidget {
  final VoidCallback onClick;

  const OnboardingStep3View({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return AgoraSingleScrollView(
      child: Column(
        children: [
          AgoraTopDiagonal(),
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
                  items: [
                    AgoraRichTextTextItem(
                      text: GenericStrings.onboardingStep3Title1,
                      style: AgoraRichTextItemStyle.bold,
                    ),
                    AgoraRichTextSpaceItem(),
                    AgoraRichTextTextItem(
                      text: GenericStrings.onboardingStep3Title2,
                      style: AgoraRichTextItemStyle.regular,
                    ),
                  ],
                ),
                SizedBox(height: AgoraSpacings.base),
                Text(GenericStrings.onboardingStep3Description, style: AgoraTextStyles.light18),
              ],
            ),
          ),
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.55,
                color: AgoraColors.doctor,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                child: Image.asset("assets/ic_onboarding_step3.png", excludeFromSemantics: true),
              ),
            ],
          ),
          SizedBox(height: AgoraSpacings.base),
          AgoraStepCircle(currentStep: 3),
          SizedBox(height: AgoraSpacings.x0_5),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AgoraSpacings.horizontalPadding,
              vertical: AgoraSpacings.base,
            ),
            child: SizedBox(
              width: double.infinity,
              child: AgoraButton(
                label: GenericStrings.onboardingStep0LetsGo,
                style: AgoraButtonStyle.primaryButtonStyle,
                onPressed: () => onClick(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
