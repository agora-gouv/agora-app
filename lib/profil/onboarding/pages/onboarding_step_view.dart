import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/common/strings/tutoriel_strings.dart';
import 'package:agora/design/custom_view/agora_step_circle.dart';
import 'package:agora/design/custom_view/scroll/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

enum OnboardingStep { consultation, question, reponse }

class OnboardingStepView extends StatelessWidget {
  final OnboardingStep step;

  const OnboardingStepView({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    final largerThanMobile = ResponsiveHelper.isLargerThanMobile(context);
    return AgoraSingleScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AgoraSpacings.horizontalPadding,
              vertical: AgoraSpacings.x1_25,
            ),
            child: Column(
              crossAxisAlignment: largerThanMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: [
                Semantics(
                  focused: true,
                  label: 'Tutoriel, ${_getLabelNumberPage(step)} partie',
                  child: AgoraRichText(
                    policeStyle: AgoraRichTextPoliceStyle.police28,
                    items: _buildTitle(),
                    textAlign: largerThanMobile ? TextAlign.center : TextAlign.start,
                  ),
                ),
                SizedBox(height: AgoraSpacings.x1_5),
                Text(
                  _buildDescription(),
                  style: AgoraTextStyles.light18,
                  textAlign: largerThanMobile ? TextAlign.center : TextAlign.start,
                ),
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
          ExcludeSemantics(child: AgoraStepCircle(currentStep: _buildStep(), style: AgoraStepCircleStyle.single)),
          SizedBox(height: AgoraSpacings.x0_5),
          Spacer(),
          SizedBox(height: AgoraSpacings.x3),
        ],
      ),
    );
  }

  List<AgoraRichTextItem> _buildTitle() {
    switch (step) {
      case OnboardingStep.question:
        return [
          AgoraRichTextItem(
            text: TutorielStrings.tutoQuestionTitre1,
            style: AgoraRichTextItemStyle.bold,
          ),
          AgoraRichTextItem(
            text: TutorielStrings.tutoQuestionTitre2,
            style: AgoraRichTextItemStyle.regular,
          ),
        ];
      case OnboardingStep.reponse:
        return [
          AgoraRichTextItem(
            text: TutorielStrings.tutoReponseTitre1,
            style: AgoraRichTextItemStyle.bold,
          ),
          AgoraRichTextItem(
            text: TutorielStrings.tutoReponseTitre2,
            style: AgoraRichTextItemStyle.regular,
          ),
        ];
      case OnboardingStep.consultation:
        return [
          AgoraRichTextItem(
            text: TutorielStrings.tutoConsultationTitre1,
            style: AgoraRichTextItemStyle.bold,
          ),
          AgoraRichTextItem(
            text: TutorielStrings.tutoConsultationTitre2,
            style: AgoraRichTextItemStyle.regular,
          ),
        ];
      default:
        throw Exception("onboarding : step $step not exists error ");
    }
  }

  String _buildDescription() {
    switch (step) {
      case OnboardingStep.consultation:
        return TutorielStrings.tutoConsultationDescription;
      case OnboardingStep.reponse:
        return TutorielStrings.tutoReponseDescription;
      case OnboardingStep.question:
        return TutorielStrings.tutoQuestionDescription;
    }
  }

  String _buildImage() {
    switch (step) {
      case OnboardingStep.consultation:
        return "assets/tuto_consultations.png";
      case OnboardingStep.reponse:
        return "assets/tuto_reponses.png";
      case OnboardingStep.question:
        return "assets/tuto_questions.png";
    }
  }

  int _buildStep() {
    switch (step) {
      case OnboardingStep.question:
        return 1;
      case OnboardingStep.reponse:
        return 2;
      case OnboardingStep.consultation:
        return 3;
    }
  }
}

String _getLabelNumberPage(OnboardingStep step) {
  switch (step) {
    case OnboardingStep.question:
      return 'première';
    case OnboardingStep.reponse:
      return 'deuxième';
    case OnboardingStep.consultation:
      return 'troisième';
  }
}
