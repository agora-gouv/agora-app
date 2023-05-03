import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraQuestionResponseChoiceView extends StatelessWidget {
  final String responseId;
  final String response;
  final bool isSelected;
  final Function(String) onTap;

  const AgoraQuestionResponseChoiceView({
    Key? key,
    required this.responseId,
    required this.response,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AgoraRoundedCard(
      borderColor: AgoraColors.border,
      cardColor: isSelected ? AgoraColors.primaryGreenOpacity15 : AgoraColors.white,
      onTap: () => onTap(responseId),
      child: SizedBox(
        width: double.infinity,
        child: Text(response, style: AgoraTextStyles.light14),
      ),
    );
  }
}
