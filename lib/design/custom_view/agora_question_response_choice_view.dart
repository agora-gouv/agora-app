import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraQuestionResponseChoiceView extends StatelessWidget {
  final String responseId;
  final String responseLabel;
  final bool isSelected;
  final Function(String responseId) onTap;

  const AgoraQuestionResponseChoiceView({
    Key? key,
    required this.responseId,
    required this.responseLabel,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AgoraRoundedCard(
      borderColor: isSelected ? AgoraColors.primaryBlue : AgoraColors.border,
      borderWidth: isSelected ? 2.0 : 1.0,
      cardColor: AgoraColors.white,
      onTap: () => onTap(responseId),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Expanded(child: Text(responseLabel, style: AgoraTextStyles.light14)),
            if (isSelected) ...[
              SizedBox(width: AgoraSpacings.x0_75),
              SvgPicture.asset("assets/ic_check.svg"),
            ],
          ],
        ),
      ),
    );
  }
}
