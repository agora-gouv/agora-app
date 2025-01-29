import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/design/custom_view/card/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraNotificationCard extends StatelessWidget {
  final String titre;
  final String description;
  final String type;
  final String date;

  AgoraNotificationCard({
    required this.titre,
    required this.description,
    required this.type,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return AgoraRoundedCard(
      borderColor: AgoraColors.border,
      padding: EdgeInsets.symmetric(vertical: AgoraSpacings.base, horizontal: AgoraSpacings.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: double.infinity),
          Text(titre, style: description.isNotEmpty ? AgoraTextStyles.medium15 : AgoraTextStyles.light14),
          SizedBox(height: AgoraSpacings.x0_5),
          if (description.isNotEmpty) ...[
            Text(description, style: AgoraTextStyles.light14),
            SizedBox(height: AgoraSpacings.base),
          ],
          RichText(
            textScaler: MediaQuery.textScalerOf(context),
            text: TextSpan(
              style: AgoraTextStyles.medium13.copyWith(color: AgoraColors.primaryGrey),
              children: [
                if (type != "Réponse du support") TextSpan(text: ProfileStrings.inType),
                TextSpan(text: type, style: AgoraTextStyles.medium13.copyWith(color: AgoraColors.primaryBlue)),
                TextSpan(text: ProfileStrings.byDate),
                TextSpan(text: date, style: AgoraTextStyles.medium13.copyWith(color: AgoraColors.primaryBlue)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
