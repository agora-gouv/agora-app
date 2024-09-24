import 'package:agora/common/helper/share_helper.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_like_view.dart';
import 'package:agora/design/custom_view/button/agora_icon_button.dart';
import 'package:agora/design/custom_view/card/agora_highlight_card.dart';
import 'package:agora/design/custom_view/card/agora_rounded_card.dart';
import 'package:agora/design/custom_view/card/agora_thematique_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/thematique/bloc/thematique_view_model.dart';
import 'package:flutter/material.dart';

class AgoraQuestionCard extends StatelessWidget {
  final String id;
  final ThematiqueViewModel thematique;
  final String titre;
  final String nom;
  final String date;
  final int supportCount;
  final bool isSupported;
  final bool isAuthor;
  final Function(bool support) onSupportClick;
  final void Function() onCardClick;
  final GlobalKey? likeViewKey;

  AgoraQuestionCard({
    required this.id,
    required this.thematique,
    required this.titre,
    required this.nom,
    required this.date,
    required this.supportCount,
    required this.isSupported,
    required this.isAuthor,
    required this.onSupportClick,
    required this.onCardClick,
    this.likeViewKey,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
            child: AgoraRoundedCard(
              borderColor: AgoraColors.border,
              padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
              onTap: () => onCardClick(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Content(
                    id: id,
                    thematique: thematique,
                    titre: titre,
                    nom: nom,
                    date: date,
                    isAuthor: isAuthor,
                  ),
                  _AuteurEtDate(
                    nom: nom,
                    date: date,
                    supportCount: supportCount,
                    isSupported: isSupported,
                    onSupportClick: onSupportClick,
                    likeViewKey: likeViewKey,
                  ),
                ],
              ),
            ),
          ),
          if (isAuthor)
            Padding(
              padding: EdgeInsets.only(top: AgoraSpacings.x0_75, left: AgoraSpacings.base),
              child: AgoraHighLightCard(label: QagStrings.yourQuestion),
            ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final String id;
  final ThematiqueViewModel thematique;
  final String titre;
  final String nom;
  final String date;
  final bool isAuthor;

  const _Content({
    required this.id,
    required this.thematique,
    required this.titre,
    required this.nom,
    required this.date,
    required this.isAuthor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AgoraSpacings.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isAuthor)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AgoraThematiqueLabel(
                  picto: thematique.picto,
                  label: thematique.label,
                  size: AgoraThematiqueSize.medium,
                ),
              ],
            ),
          SizedBox(height: isAuthor ? AgoraSpacings.x2 : AgoraSpacings.x0_5),
          Text(titre.trim(), style: AgoraTextStyles.regular15),
          SizedBox(height: AgoraSpacings.x0_25),
          Text(
            "Voir plus",
            style: AgoraTextStyles.regular15Underline.copyWith(
              color: AgoraColors.greySeeMore,
              decorationColor: AgoraColors.greySeeMore,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuteurEtDate extends StatelessWidget {
  final String nom;
  final String date;
  final int supportCount;
  final bool isSupported;
  final void Function(bool support) onSupportClick;
  final GlobalKey? likeViewKey;

  const _AuteurEtDate({
    required this.nom,
    required this.date,
    required this.supportCount,
    required this.isSupported,
    required this.onSupportClick,
    required this.likeViewKey,
  });

  @override
  Widget build(BuildContext context) {
    return AgoraRoundedCard(
      cardColor: AgoraColors.doctor,
      padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_25, horizontal: AgoraSpacings.x0_75),
      roundedCorner: AgoraRoundedCorner.bottomRounded,
      child: Row(
        children: [
          SizedBox(width: AgoraSpacings.x0_5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nom, style: AgoraTextStyles.medium12),
                Text('le $date', style: AgoraTextStyles.medium12.copyWith(color: AgoraColors.blue525)),
              ],
            ),
          ),
          AgoraLikeView(
            shouldHaveHorizontalPadding: false,
            style: AgoraLikeStyle.police16,
            isSupported: isSupported,
            supportCount: supportCount,
            shouldHaveVerticalPadding: true,
            onSupportClick: (support) => onSupportClick(support),
            likeViewKey: likeViewKey,
            withContour: false,
          ),
          AgoraIconButton(
            icon: "ic_share.svg",
            semanticLabel: 'Partager',
            borderColor: AgoraColors.transparent,
            onClick: () => ShareHelper.shareQag(context: context, title: "title", id: "id"),
          ),
        ],
      ),
    );
  }
}
