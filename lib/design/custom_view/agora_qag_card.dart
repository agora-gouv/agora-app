import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraQagCard extends StatelessWidget {
  final String id;
  final ThematiqueViewModel thematique;
  final String title;
  final String username;
  final String date;
  final int supportCount;
  final bool isSupported;
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
    required this.onSupportClick,
    required this.onCardClick,
  });

  @override
  Widget build(BuildContext context) {
    return AgoraRoundedCard(
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
                Row(
                  children: [
                    Expanded(child: ThematiqueHelper.buildCard(context, thematique)),
                    SizedBox(width: AgoraSpacings.x0_25),
                    GestureDetector(
                      onTap: () => onSupportClick(!isSupported),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          isSupported
                              ? SvgPicture.asset("assets/ic_heart_full.svg")
                              : SvgPicture.asset("assets/ic_heart.svg"),
                          SizedBox(width: AgoraSpacings.x0_25),
                          Text(supportCount.toString(), style: AgoraTextStyles.medium14),
                        ],
                      ),
                    ),
                    SizedBox(width: AgoraSpacings.x0_5),
                  ],
                ),
                SizedBox(height: AgoraSpacings.x0_25),
                Text(title, style: AgoraTextStyles.medium16),
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
    );
  }
}
