import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:flutter/material.dart';

class AgoraParticipantsProgressBar extends StatelessWidget {
  const AgoraParticipantsProgressBar({
    Key? key,
    required this.nbParticipantActuel,
    required this.nbParticipantObjectif,
  }) : super(key: key);

  final int nbParticipantActuel;
  final int nbParticipantObjectif;

  static const _barHeight = AgoraSpacings.x0_5;
  static const _barPadding = 0.0; //CustomSpacings.base;

  @override
  Widget build(BuildContext context) {
    final totalWidth = MediaQuery.of(context).size.width - (2 * _barPadding);
    final participantsPourcentage = nbParticipantActuel / nbParticipantObjectif;
    return Padding(
      padding: const EdgeInsets.all(_barPadding),
      child: Stack(
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
              width: totalWidth * participantsPourcentage,
            ),
          ),
        ],
      ),
    );
  }
}
