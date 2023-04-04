import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:flutter/material.dart';

class AgoraParticipantsProgressBar extends StatelessWidget {
  final int currentNbParticipants;
  final int objectiveNbParticipants;
  final double? minusPadding;

  const AgoraParticipantsProgressBar({
    Key? key,
    required this.currentNbParticipants,
    required this.objectiveNbParticipants,
    this.minusPadding,
  }) : super(key: key);

  static const _barHeight = AgoraSpacings.x0_5;

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    if (minusPadding != null) {
      totalWidth = totalWidth - minusPadding!;
    }
    final participantsPercentage = currentNbParticipants / objectiveNbParticipants;
    return Stack(
      children: [
        AgoraRoundedCard(
          cardColor: AgoraColors.grey,
          padding: null,
          child: SizedBox(
            height: _barHeight,
            width: totalWidth,
          ),
        ),
        AgoraRoundedCard(
          cardColor: AgoraColors.turquoise,
          padding: null,
          child: SizedBox(
            height: _barHeight,
            width: totalWidth * participantsPercentage,
          ),
        ),
      ],
    );
  }
}
