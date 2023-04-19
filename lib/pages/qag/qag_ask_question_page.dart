import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/agora_button.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_text_field.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/pages/qag/qag_thematiques_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class QagAskQuestionPage extends StatefulWidget {
  static const routeName = "/qagAskQuestionPage";

  @override
  State<QagAskQuestionPage> createState() => _QagAskQuestionPageState();
}

class _QagAskQuestionPageState extends State<QagAskQuestionPage> {
  String question = "";
  String details = "";
  String username = "";
  String? thematique;

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
                  Text(QagStrings.askQuestionTitle, style: AgoraTextStyles.medium18),
                  SizedBox(height: AgoraSpacings.base),
                  Text(QagStrings.askQuestionDescription, style: AgoraTextStyles.light14),
                  SizedBox(height: AgoraSpacings.base),
                  AgoraButton(
                    label: QagStrings.readNotice,
                    style: AgoraButtonStyle.lightGreyButtonStyle,
                    onPressed: () {
                      showAgoraDialog(
                        context: context,
                        columnChildren: [
                          Text(QagStrings.noticeTitle, style: AgoraTextStyles.medium16),
                          SizedBox(height: AgoraSpacings.x0_5),
                          Text(QagStrings.noticeDescription, style: AgoraTextStyles.light14),
                          SizedBox(height: AgoraSpacings.x0_5),
                          AgoraButton(
                            label: QagStrings.agree,
                            style: AgoraButtonStyle.primaryButtonStyle,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: AgoraSpacings.base),
                  Text(QagStrings.questionTitle, style: AgoraTextStyles.medium18),
                  SizedBox(height: AgoraSpacings.x0_75),
                  AgoraTextField(
                    maxLength: 200,
                    hintText: QagStrings.questionHint,
                    onChanged: (input) {
                      question = input;
                    },
                  ),
                  SizedBox(height: AgoraSpacings.x0_75),
                  Text(QagStrings.detailsTitle, style: AgoraTextStyles.medium18),
                  SizedBox(height: AgoraSpacings.x0_75),
                  AgoraTextField(
                    maxLength: 400,
                    hintText: QagStrings.detailsHint,
                    onChanged: (input) {
                      details = input;
                    },
                  ),
                  SizedBox(height: AgoraSpacings.x0_75),
                  Text(QagStrings.thematiqueTitle, style: AgoraTextStyles.medium18),
                  SizedBox(height: AgoraSpacings.x0_5),
                  QagThematiquesDropDown(
                    firstValue: null,
                    elements: thematiqueViewModels,
                    hintText: QagStrings.thematiqueHint,
                    onSelected: (value) {
                      thematique = value?.label;
                    },
                  ),
                  SizedBox(height: AgoraSpacings.x1_5),
                  Text(QagStrings.yourNameTitle, style: AgoraTextStyles.medium18),
                  SizedBox(height: AgoraSpacings.x0_75),
                  AgoraTextField(
                    maxLength: 50,
                    hintText: QagStrings.yourNameHint,
                    onChanged: (input) {
                      username = input;
                    },
                  ),
                  SizedBox(height: AgoraSpacings.base),
                  Text(QagStrings.askQuestionInformation, style: AgoraTextStyles.light14),
                  SizedBox(height: AgoraSpacings.base),
                  AgoraButton(
                    label: QagStrings.sendByEmail,
                    style: AgoraButtonStyle.primaryButtonStyle,
                    onPressed: () async {
                      if (_couldSend()) {
                        final email = Email(
                          body:
                              "Question : $question \n\nDétails : $details\n\nThématique : $thematique\n\nPrénom : $username\n\n",
                          subject: QagStrings.askQuestionMailSubject,
                          recipients: ["penelope.liot@beta.gouv.fr"],
                          isHTML: false,
                        );
                        try {
                          await FlutterEmailSender.send(email);
                        } catch (error) {
                          showAgoraDialog(
                            context: context,
                            columnChildren: [
                              Text(QagStrings.askQuestionConfigureMail, style: AgoraTextStyles.medium16),
                              SizedBox(height: AgoraSpacings.base),
                              AgoraButton(
                                label: QagStrings.agree,
                                style: AgoraButtonStyle.primaryButtonStyle,
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          );
                        }
                      }
                    },
                  ),
                  SizedBox(height: AgoraSpacings.x2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _couldSend() {
    return question.isNotBlank() && username.isNotBlank() && thematique != null;
  }
}
