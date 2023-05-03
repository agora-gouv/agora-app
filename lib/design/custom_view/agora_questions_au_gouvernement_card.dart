import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/domain/thematique/thematique.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraQuestionAuGouvernementCard extends StatelessWidget {
  final String image;
  final Thematique thematique;
  final String nombrePouce;
  final String titre;
  final String nom;
  final String date;

  AgoraQuestionAuGouvernementCard({
    required this.image,
    required this.thematique,
    required this.nombrePouce,
    required this.titre,
    required this.nom,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return AgoraRoundedCard(
      borderColor: AgoraColors.border,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // AgoraThematiqueCard(thematique: thematique),
              Spacer(),
              SvgPicture.asset("assets/$image"),
              SizedBox(width: AgoraSpacings.x0_25),
              Text(nombrePouce, style: AgoraTextStyles.lightGreyButton),
            ],
          ),
          SizedBox(height: AgoraSpacings.x0_25),
          Text(titre, style: AgoraTextStyles.medium16),
          SizedBox(height: AgoraSpacings.x0_25),
          Text("Par $nom le $date", style: AgoraTextStyles.lightItalic14),
        ],
      ),
    );
  }
}
