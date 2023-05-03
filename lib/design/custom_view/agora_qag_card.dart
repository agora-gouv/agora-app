import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
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

  AgoraQagCard({
    required this.id,
    required this.thematique,
    required this.title,
    required this.username,
    required this.date,
    required this.supportCount,
    required this.isSupported,
  });

  @override
  Widget build(BuildContext context) {
    return AgoraRoundedCard(
      borderColor: AgoraColors.border,
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
      onTap: () {
        Navigator.pushNamed(
          context,
          QagDetailsPage.routeName,
          arguments: QagDetailsArguments(qagId: id),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AgoraSpacings.base),
            child: Column(
              children: [
                Row(
                  children: [
                    ThematiqueHelper.buildCard(context, thematique),
                    SizedBox(width: AgoraSpacings.x0_25),
                    Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SvgPicture.asset("assets/ic_heard.svg"),
                        SizedBox(width: AgoraSpacings.x0_25),
                        Text(supportCount.toString(), style: AgoraTextStyles.medium14),
                        SizedBox(width: AgoraSpacings.x0_5),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AgoraSpacings.x0_25),
                Text(title, style: AgoraTextStyles.regular14),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: AgoraRoundedCard(
                  cardColor: AgoraColors.whiteEdgar,
                  padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
                  roundedCorner: AgoraRoundedCorner.bottomRounded,
                  child: RichText(
                    text: TextSpan(
                      style: AgoraTextStyles.medium11.copyWith(color: AgoraColors.primaryGreen),
                      children: [
                        TextSpan(text: QagStrings.de),
                        WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                        TextSpan(text: username, style: AgoraTextStyles.medium12),
                        WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                        TextSpan(text: QagStrings.at),
                        WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                        TextSpan(text: date, style: AgoraTextStyles.medium12),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
