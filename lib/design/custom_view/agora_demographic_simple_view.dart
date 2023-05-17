import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum DemographicSelectedIconPlace { right, centerBottom }

class AgoraDemographicResponseCard extends StatelessWidget {
  final String responseLabel;
  final TextAlign textAlign;
  final bool isSelected;
  final VoidCallback onTap;
  final DemographicSelectedIconPlace iconPlace;

  const AgoraDemographicResponseCard({
    Key? key,
    required this.responseLabel,
    this.textAlign = TextAlign.start,
    this.iconPlace = DemographicSelectedIconPlace.right,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

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
          SvgPicture.asset("assets/ic_check.svg"),
      ],
    );
  }

  AgoraRoundedCard buildCard() {
    return AgoraRoundedCard(
      borderColor: isSelected ? AgoraColors.primaryGreen : AgoraColors.border,
      borderWidth: isSelected ? 2.0 : 1.0,
      cardColor: AgoraColors.white,
      onTap: () => onTap(),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: Text(
                responseLabel,
                style: AgoraTextStyles.light14,
                textAlign: textAlign,
              ),
            ),
            if (iconPlace == DemographicSelectedIconPlace.right && isSelected) ...[
              SizedBox(width: AgoraSpacings.x0_75),
              SvgPicture.asset("assets/ic_check.svg"),
            ],
          ],
        ),
      ),
    );
  }
}
