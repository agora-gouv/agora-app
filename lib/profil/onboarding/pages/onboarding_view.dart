import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/common/strings/tutoriel_strings.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/custom_view/scroll/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/profil/onboarding/pages/onboarding_auto_scroll_page.dart';
import 'package:agora/profil/onboarding/pages/onboarding_thematique_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingView extends StatelessWidget {
  final AnimationController? animationController;

  OnboardingView(this.animationController);

  @override
  Widget build(BuildContext context) {
    final largerThanMobile = ResponsiveHelper.isLargerThanMobile(context);
    return AgoraSingleScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          AgoraTopDiagonal(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AgoraSpacings.horizontalPadding,
                vertical: AgoraSpacings.x1_25,
              ),
              child: Column(
                crossAxisAlignment: largerThanMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AgoraSpacings.x2),
                  Align(
                    alignment: Alignment.topLeft,
                    child: SvgPicture.asset("assets/ic_marianne.svg", excludeFromSemantics: true),
                  ),
                  SizedBox(height: AgoraSpacings.base),
                  Semantics(
                    header: true,
                    focused: true,
                    child: Text(
                      TutorielStrings.tutoAccueilTitre,
                      style:
                          AgoraTextStyles.light30.copyWith(color: AgoraColors.primaryBlue, fontWeight: FontWeight.w600),
                      textAlign: largerThanMobile ? TextAlign.center : TextAlign.start,
                    ),
                  ),
                  SizedBox(height: AgoraSpacings.x1_5),
                  AgoraRichText(
                    policeStyle: AgoraRichTextPoliceStyle.police22,
                    semantic: AgoraRichTextSemantic(header: false),
                    textAlign: largerThanMobile ? TextAlign.center : TextAlign.start,
                    items: [
                      AgoraRichTextItem(
                        text: TutorielStrings.tutoAccueilDescription1,
                        style: AgoraRichTextItemStyle.regular,
                      ),
                      AgoraRichTextItem(
                        text: TutorielStrings.tutoAccueilDescription2,
                        style: AgoraRichTextItemStyle.bold,
                      ),
                      AgoraRichTextItem(
                        text: TutorielStrings.tutoAccueilDescription3,
                        style: AgoraRichTextItemStyle.regular,
                      ),
                    ],
                  ),
                  SizedBox(height: AgoraSpacings.x2),
                  Spacer(),
                  kIsWeb
                      ? Center(child: Image.asset("assets/ic_onboarding_web.png", width: 460, height: 400))
                      : MergeSemantics(
                          child: Semantics(
                            label:
                                "Animation montrant les différentes thématiques de l'application qui sont : la Transition écologique, la Santé, les Transports, l'Éducation et la jeunesse, le Travail, l'Europe et l'international, la Sécurité et la défense, la Démocratie",
                            child: Column(
                              children: [
                                ExcludeSemantics(
                                  child: OnboardingAutoScrollPage(
                                    scrollDirection: Axis.horizontal,
                                    gap: 0,
                                    animationController: animationController,
                                    child: _buildFirstThematiqueList(context),
                                  ),
                                ),
                                SizedBox(height: AgoraSpacings.base),
                                ExcludeSemantics(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: OnboardingAutoScrollPage(
                                          scrollDirection: Axis.horizontal,
                                          reverseScroll: true,
                                          animationController: animationController,
                                          gap: 0,
                                          child: _buildSecondThematiqueList(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  Spacer(),
                  SizedBox(height: AgoraSpacings.x3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstThematiqueList(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          _buildThematiqueCard(context, "🌱", "Transition écologique"),
          SizedBox(width: AgoraSpacings.base),
          _buildThematiqueCard(context, "🏥", "Santé"),
          SizedBox(width: AgoraSpacings.base),
          _buildThematiqueCard(context, "🚊", "Transports"),
          SizedBox(width: AgoraSpacings.base),
          _buildThematiqueCard(context, "🎓", "Education & jeunesse"),
          SizedBox(width: AgoraSpacings.base),
        ],
      ),
    );
  }

  Widget _buildSecondThematiqueList(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          _buildThematiqueCard(context, "💼", "Travail"),
          SizedBox(width: AgoraSpacings.base),
          _buildThematiqueCard(context, "🌏", "Europe & international"),
          SizedBox(width: AgoraSpacings.base),
          _buildThematiqueCard(context, "🛡", "Sécurité & défense"),
          SizedBox(width: AgoraSpacings.base),
          _buildThematiqueCard(context, "🗳", "Démocratie"),
          SizedBox(width: AgoraSpacings.base),
        ],
      ),
    );
  }

  Widget _buildThematiqueCard(BuildContext context, String picto, String label) {
    final width = MediaQuery.of(context).size.width * 0.32;
    return SizedBox(
      width: width,
      child: OnboardingThematiqueCard(picto: picto, label: label),
    );
  }
}
