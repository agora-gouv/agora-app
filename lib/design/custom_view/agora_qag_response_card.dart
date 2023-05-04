import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/custom_view/agora_rounded_image.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraQagResponseCard extends StatelessWidget {
  final ThematiqueViewModel thematique;
  final String title;
  final String authorImageUrl;
  final String author;
  final String date;
  final VoidCallback onClick;

  AgoraQagResponseCard({
    required this.thematique,
    required this.title,
    required this.authorImageUrl,
    required this.author,
    required this.date,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: AgoraRoundedCard(
        borderColor: AgoraColors.border,
        cardColor: AgoraColors.white,
        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
        onTap: () => onClick(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ThematiqueHelper.buildCard(context, thematique),
                  SizedBox(height: AgoraSpacings.x0_25),
                  Text(title, style: AgoraTextStyles.regular14),
                  SizedBox(height: AgoraSpacings.x0_25),
                ],
              ),
            ),
            SizedBox(height: AgoraSpacings.x0_25),
            Spacer(),
            AgoraRoundedCard(
              cardColor: AgoraColors.whiteEdgar,
              padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
              roundedCorner: AgoraRoundedCorner.bottomRounded,
              child: Row(
                children: [
                  AgoraRoundedImage(imageUrl: authorImageUrl),
                  SizedBox(width: AgoraSpacings.x0_5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(author, style: AgoraTextStyles.medium12),
                        Text(date, style: AgoraTextStyles.medium12.copyWith(color: AgoraColors.primaryGreen)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
