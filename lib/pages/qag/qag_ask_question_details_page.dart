import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/design/agora_button.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_drop_down.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_text_field.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class QagAskQuestionDetailsPage extends StatefulWidget {
  static const routeName = "/qagAskQuestionDetailsPage";

  @override
  State<QagAskQuestionDetailsPage> createState() => _QagAskQuestionDetailsPageState();
}

class _QagAskQuestionDetailsPageState extends State<QagAskQuestionDetailsPage> {
  String question = "";
  String details = "";
  String username = "";
  String thematique = "";

  @override
  Widget build(BuildContext context) {
    final thematiqueViewModels = ModalRoute.of(context)!.settings.arguments as List<ThematiqueViewModel>;
    if (thematique == "") {
      thematique = thematiqueViewModels.first.label;
    }
    return AgoraScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AgoraToolbar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Question", style: AgoraTextStyles.medium18),
                  SizedBox(height: AgoraSpacings.x0_5),
                  AgoraTextField(
                    maxLength: 200,
                    onChanged: (input) {
                      question = input;
                    },
                  ),
                  SizedBox(height: AgoraSpacings.x0_5),
                  Text("Details supplémentaires (optionnel)", style: AgoraTextStyles.medium18),
                  SizedBox(height: AgoraSpacings.x0_5),
                  AgoraTextField(
                    maxLength: 400,
                    onChanged: (input) {
                      details = input;
                    },
                  ),
                  SizedBox(height: AgoraSpacings.x0_5),
                  Text("Choisissez votre thématiques", style: AgoraTextStyles.medium18),
                  AgoraThematiquesDropDown(
                    elements: thematiqueViewModels,
                    onSelected: (value) {
                      thematique = value.label;
                    },
                  ),
                  SizedBox(height: AgoraSpacings.x0_5),
                  Text("Prénom et la première lettre de votre nom de famille", style: AgoraTextStyles.medium18),
                  SizedBox(height: AgoraSpacings.x0_5),
                  AgoraTextField(
                    maxLength: 50,
                    hintText: "David L.",
                    onChanged: (input) {
                      username = input;
                    },
                  ),
                  SizedBox(height: AgoraSpacings.x0_5),
                  AgoraButton(
                    label: "Envoyer par mail",
                    style: AgoraButtonStyle.primaryButtonStyle,
                    onPressed: () async {
                      if (couldSend()) {
                        final email = Email(
                          body:
                              "Question : $question \n\n details: $details\n\n thematique:$thematique\n\n username:$username\n\n",
                          subject: "Poser une question au gouverment",
                          recipients: ["ziyu.ye@octo.com"],
                          isHTML: false,
                        );
                        try {
                          await FlutterEmailSender.send(email);
                        } catch (error) {
                          showAgoraDialog(
                            context: context,
                            columnChildren: [
                              Text("Veuillez configurer l'application Mail par défaut de votre appareil."),
                              SizedBox(height: AgoraSpacings.base),
                              AgoraButton(
                                label: "C'est compris",
                                style: AgoraButtonStyle.primaryButtonStyle,
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  bool couldSend() {
    return question.isNotEmpty && username.isNotEmpty && thematique.isNotEmpty;
  }
}
