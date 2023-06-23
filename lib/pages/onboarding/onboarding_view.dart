import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/onboarding/onboarding_auto_scroll_page.dart';
import 'package:agora/pages/onboarding/onboarding_thematique_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingView extends StatelessWidget {
  final VoidCallback onClick;

  const OnboardingView({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset("assets/ic_marianne.svg"),
                  SizedBox(height: AgoraSpacings.x2),
                  Text(GenericStrings.onboardingStep0Title, style: AgoraTextStyles.light28),
                  SizedBox(height: AgoraSpacings.x1_5),
                  AgoraRichText(
                    policeStyle: AgoraRichTextPoliceStyle.police22,
                    items: [
                      AgoraRichTextTextItem(
                        text: GenericStrings.onboardingStep0Description1,
                        style: AgoraRichTextItemStyle.regular,
                      ),
                      AgoraRichTextSpaceItem(),
                      AgoraRichTextTextItem(
                        text: GenericStrings.onboardingStep0Description2,
                        style: AgoraRichTextItemStyle.bold,
                      ),
                      AgoraRichTextSpaceItem(),
                      AgoraRichTextTextItem(
                        text: GenericStrings.onboardingStep0Description3,
                        style: AgoraRichTextItemStyle.regular,
                      ),
                    ],
                  ),
                  SizedBox(height: AgoraSpacings.x2),
                  Spacer(),
                  ExcludeSemantics(
                    child: OnboardingAutoScrollPage(
                      scrollDirection: Axis.horizontal,
                      gap: 0,
                      child: _buildFirstThematiqueList(context),
                    ),
                  ),
                  SizedBox(height: AgoraSpacings.base),
                  ExcludeSemantics(
                    child: Row(
                      children: [
                        Expanded(
                          child: OnboardingAutoScrollPage(
                            scrollDirection: Axis.horizontal,
                            reverseScroll: true,
                            gap: 0,
                            child: _buildSecondThematiqueList(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  SizedBox(height: AgoraSpacings.x3),
                  SizedBox(
                    width: double.infinity,
                    child: AgoraButton(
                      label: GenericStrings.onboardingStep0Begin,
                      style: AgoraButtonStyle.onboardingButtonStyle,
                      onPressed: () => onClick(),
                    ),
                  ),
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
