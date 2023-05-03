import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/bloc/thematique/thematique_event.dart';
import 'package:agora/bloc/thematique/thematique_state.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_text_field.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/pages/qag/qag_thematiques_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class QagAskQuestionPage extends StatefulWidget {
  static const routeName = "/qagAskQuestionPage";

  @override
  State<QagAskQuestionPage> createState() => _QagAskQuestionPageState();
}

class _QagAskQuestionPageState extends State<QagAskQuestionPage> {
  String question = "";
  String details = "";
  String firstname = "";
  String? thematique;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThematiqueBloc(
        repository: RepositoryManager.getThematiqueRepository(),
      )..add(FetchThematiqueEvent()),
      child: AgoraScaffold(
        child: BlocBuilder<ThematiqueBloc, ThematiqueState>(
          builder: (context, state) {
            if (state is ThematiqueInitialLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ThematiqueErrorState) {
              return Center(child: AgoraErrorView());
            } else if (state is ThematiqueSuccessState) {
              return SingleChildScrollView(
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
                            elements: state.thematiqueViewModels,
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
                              firstname = input;
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
                                      "Question : $question \n\nDétails : $details\n\nThématique : $thematique\n\nPrénom : $firstname\n\n",
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
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  bool _couldSend() {
    return question.isNotBlank() && firstname.isNotBlank() && thematique != null;
  }
}
