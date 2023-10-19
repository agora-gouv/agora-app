import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_highlight_card.dart';
import 'package:agora/design/custom_view/agora_like_view.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraQagCard extends StatelessWidget {
  final String id;
  final ThematiqueViewModel thematique;
  final String title;
  final String username;
  final String date;
  final int supportCount;
  final bool isSupported;
  final bool isAuthor;
  final Function(bool support) onSupportClick;
  final VoidCallback onCardClick;

  AgoraQagCard({
    required this.id,
    required this.thematique,
    required this.title,
    required this.username,
    required this.date,
    required this.supportCount,
    required this.isSupported,
    required this.isAuthor,
    required this.onSupportClick,
    required this.onCardClick,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: Stack(
        children: [
          _buildCard(context),
          if (isAuthor)
            Padding(
              padding: EdgeInsets.only(top: AgoraSpacings.x0_75, left: AgoraSpacings.base),
              child: AgoraHighLightCard(label: QagStrings.yourQuestion),
            ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
      child: AgoraRoundedCard(
        borderColor: AgoraColors.border,
        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
        onTap: () => onCardClick(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AgoraSpacings.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildYourQuestion(context),
                  if (isAuthor) ThematiqueHelper.buildCard(context, thematique),
                  SizedBox(height: AgoraSpacings.x0_25),
                  Text(title, style: AgoraTextStyles.regular16),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: AgoraRoundedCard(
                    cardColor: AgoraColors.doctor,
                    padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
                    roundedCorner: AgoraRoundedCorner.bottomRounded,
                    child: Text(QagStrings.authorAndDate.format2(username, date), style: AgoraTextStyles.light12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYourQuestion(BuildContext context) {
    if (isAuthor) {
      return Row(
        children: [
          Expanded(child: Container(height: AgoraSpacings.x2)),
          SizedBox(width: AgoraSpacings.x0_25),
          AgoraLikeView(
            isSupported: isSupported,
            supportCount: supportCount,
            shouldHaveVerticalPadding: true,
            onSupportClick: (support) => onSupportClick(support),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(child: ThematiqueHelper.buildCard(context, thematique)),
          SizedBox(width: AgoraSpacings.x0_25),
          AgoraLikeView(
            isSupported: isSupported,
            supportCount: supportCount,
            shouldHaveVerticalPadding: true,
            onSupportClick: (support) => onSupportClick(support),
          ),
        ],
      );
    }
  }
}
