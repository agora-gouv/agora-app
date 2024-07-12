import 'package:agora/common/helper/semantics_helper.dart';
import 'package:agora/design/custom_view/card/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum DemographicSelectedIconPlace { right, centerBottom }

class DemographicResponseCardSemantic {
  final int currentIndex;
  final int totalIndex;

  DemographicResponseCardSemantic({required this.currentIndex, required this.totalIndex});
}

class AgoraDemographicResponseCard extends StatelessWidget {
  final String responseLabel;
  final TextAlign textAlign;
  final bool isSelected;
  final EdgeInsetsGeometry padding;
  final VoidCallback onTap;
  final DemographicSelectedIconPlace iconPlace;
  final DemographicResponseCardSemantic semantic;

  const AgoraDemographicResponseCard({
    super.key,
    required this.responseLabel,
    this.textAlign = TextAlign.start,
    this.iconPlace = DemographicSelectedIconPlace.right,
    required this.isSelected,
    this.padding = const EdgeInsets.all(AgoraSpacings.base),
    required this.semantic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AgoraSpacings.x0_75),
          child: buildCard(),
        ),
        if (iconPlace == DemographicSelectedIconPlace.centerBottom && isSelected)
          SvgPicture.asset("assets/ic_check.svg", excludeFromSemantics: true),
      ],
    );
  }

  Widget buildCard() {
    return Semantics(
      toggled: isSelected,
      button: true,
      child: AgoraRoundedCard(
        borderColor: isSelected ? AgoraColors.primaryBlue : AgoraColors.border,
        borderWidth: isSelected ? 2.0 : 1.0,
        cardColor: AgoraColors.white,
        padding: padding,
        onTap: () => onTap(),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  responseLabel,
                  style: AgoraTextStyles.light14.copyWith(height: 0),
                  textAlign: textAlign,
                  semanticsLabel: SemanticsHelper.cardResponse(
                    responseLabel: responseLabel,
                    currentStep: semantic.currentIndex,
                    totalStep: semantic.totalIndex,
                  ),
                ),
              ),
              if (iconPlace == DemographicSelectedIconPlace.right && isSelected) ...[
                SizedBox(width: AgoraSpacings.x0_75),
                SvgPicture.asset("assets/ic_check.svg", excludeFromSemantics: true),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
