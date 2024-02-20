import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/onboarding/onboarding_auto_scroll_page.dart';
import 'package:agora/pages/onboarding/onboarding_thematique_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingView extends StatefulWidget {
  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(minutes: 2),
      vsync: this,
    );
  }

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
                      GenericStrings.onboardingStep0Title,
                      style: AgoraTextStyles.light28,
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
                        text: GenericStrings.onboardingStep0Description1,
                        style: AgoraRichTextItemStyle.regular,
                      ),
                      AgoraRichTextItem(
                        text: GenericStrings.onboardingStep0Description2,
                        style: AgoraRichTextItemStyle.bold,
                      ),
                      AgoraRichTextItem(
                        text: GenericStrings.onboardingStep0Description3,
                        style: AgoraRichTextItemStyle.regular,
                      ),
                    ],
                  ),
                  SizedBox(height: AgoraSpacings.x2),
                  Spacer(),
                  kIsWeb
                      ? Center(child: Image.asset("assets/ic_onboarding_web.png", width: 460, height: 400))
                      : Column(
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
                                    child: Stack(
                                      children: [
                                        OnboardingAutoScrollPage(
                                          scrollDirection: Axis.horizontal,
                                          reverseScroll: true,
                                          animationController: animationController,
                                          gap: 0,
                                          child: _buildSecondThematiqueList(context),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: AgoraSpacings.x5, left: AgoraSpacings.base),
                                            child: _PauseButton(
                                              onTap: (isPlaying) {
                                                if (isPlaying) {
                                                  animationController.stop();
                                                } else {
                                                  animationController.forward();
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
    return Container(
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
          onTap: () {
            widget.onTap(isPlaying);
            setState(() {
              isPlaying = !isPlaying;
            });
          },
          child: Semantics(
            label: isPlaying ? SemanticsStrings.animPause : SemanticsStrings.animPlay,
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
