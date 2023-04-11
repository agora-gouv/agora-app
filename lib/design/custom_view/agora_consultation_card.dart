import 'package:agora/design/agora_button.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/domain/thematique/thematique.dart';
import 'package:flutter/material.dart';

class AgoraConsultationCard extends StatelessWidget {
  final String image;
  final Thematique thematique;
  final String titre;
  final String description;
  final String dateFin;
  final VoidCallback onPartipationClick;
  final VoidCallback onPartagerClick;

  AgoraConsultationCard({
    required this.image,
    required this.thematique,
    required this.titre,
    required this.description,
    required this.dateFin,
    required this.onPartipationClick,
    required this.onPartagerClick,
  });

  @override
  Widget build(BuildContext context) {
    return AgoraRoundedCard(
      borderColor: AgoraColors.border,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Image.asset("assets/$image")),
          SizedBox(height: AgoraSpacings.base),
          // AgoraThematiqueCard(thematique: thematique),
          SizedBox(height: AgoraSpacings.x0_25),
          Text(titre, style: AgoraTextStyles.medium16),
          SizedBox(height: AgoraSpacings.x0_25),
          Text(description, style: AgoraTextStyles.light14),
          SizedBox(height: AgoraSpacings.x0_25),
          Text(dateFin, style: AgoraTextStyles.lightItalic14),
          SizedBox(height: AgoraSpacings.x3),
          Row(
            children: [
              AgoraButton(
                label: "Participer",
                style: AgoraButtonStyle.primaryButtonStyle,
                onPressed: () {
                  onPartipationClick();
                },
              ),
              Spacer(),
              AgoraButton(
                icon: "ic_partager.svg",
                label: "Partager",
                style: AgoraButtonStyle.lightGreyButtonStyle,
                onPressed: () {
                  onPartagerClick();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
