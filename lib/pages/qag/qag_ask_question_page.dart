import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/design/agora_button.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/pages/qag/qag_ask_question_details_page.dart';
import 'package:flutter/material.dart';

class QagAskQuestionPage extends StatelessWidget {
  static const routeName = "/qagAskQuestionPage";

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      child: Column(
        children: [
          AgoraToolbar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Poser une question au gouvernement", style: AgoraTextStyles.medium18),
                SizedBox(height: AgoraSpacings.base),
                Text(
                  "Durant la phase d’expérimentation, nous vous proposons d’envoyer votre question par email. Elle apparaîtra dans les 48h sur l’application.",
                  style: AgoraTextStyles.light14,
                ),
                SizedBox(height: AgoraSpacings.base),
                AgoraButton(
                  label: "Lire la charte",
                  style: AgoraButtonStyle.lightGreyButtonStyle,
                  onPressed: () {
                    showAgoraDialog(
                      context: context,
                      columnChildren: [
                        Text(
                          "Les questions posées doivent respecter la charte de participation : ",
                          style: AgoraTextStyles.medium16,
                        ),
                        SizedBox(height: AgoraSpacings.x0_5),
                        Text("\u2022 Porter sur un sujet d’intérêt général,", style: AgoraTextStyles.light14),
                        SizedBox(height: AgoraSpacings.x0_5),
                        Text("\u2022 Avoir un ton respectueux.", style: AgoraTextStyles.light14),
                        SizedBox(height: AgoraSpacings.base),
                        AgoraButton(
                          label: "C'est compris",
                          style: AgoraButtonStyle.primaryButtonStyle,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    );
                  },
                ),
                AgoraButton(
                  label: "Poser ma question",
                  style: AgoraButtonStyle.primaryButtonStyle,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      QagAskQuestionDetailsPage.routeName,
                      arguments: ModalRoute.of(context)!.settings.arguments as List<ThematiqueViewModel>,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
