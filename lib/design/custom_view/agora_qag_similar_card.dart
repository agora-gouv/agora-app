import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/strings/string_utils.dart';
import 'package:agora/design/custom_view/agora_like_view.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraQagSimilarCard extends StatelessWidget {
  final String id;
  final ThematiqueViewModel thematique;
  final String title;
  final String description;
  final String username;
  final String date;
  final int supportCount;
  final bool isSupported;
  final Function(bool support) onSupportClick;

  AgoraQagSimilarCard({
    required this.id,
    required this.thematique,
    required this.title,
    required this.description,
    required this.username,
    required this.date,
    required this.supportCount,
    required this.isSupported,
    required this.onSupportClick,
  });

  @override
  Widget build(BuildContext context) {
    return AgoraRoundedCard(
      borderColor: AgoraColors.border,
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AgoraSpacings.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ThematiqueHelper.buildCard(context, thematique),
                    SizedBox(width: AgoraSpacings.x0_25),
                    Spacer(),
                    AgoraLikeView(
                      isSupported: isSupported,
                      supportCount: supportCount,
                      onSupportClick: (support) => onSupportClick(support),
                    ),
                  ],
                ),
                SizedBox(height: AgoraSpacings.x0_25),
                Text(title, style: AgoraTextStyles.medium16),
                SizedBox(height: AgoraSpacings.x0_25),
                Text(description, style: AgoraTextStyles.regular14),
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
                  child: Text(StringUtils.authorAndDate.format2(username, date), style: AgoraTextStyles.light12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
