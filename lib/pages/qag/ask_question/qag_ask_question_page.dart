import 'package:agora/bloc/qag/create/qag_create_bloc.dart';
import 'package:agora/bloc/qag/create/qag_create_event.dart';
import 'package:agora/bloc/qag/create/qag_create_state.dart';
import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/bloc/thematique/thematique_event.dart';
import 'package:agora/bloc/thematique/thematique_state.dart';
import 'package:agora/bloc/thematique/thematique_with_id_view_model.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_text_field.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/qag/ask_question/qag_ask_question_confirmation_page.dart';
import 'package:agora/pages/qag/ask_question/qag_thematiques_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagAskQuestionPage extends StatefulWidget {
  static const routeName = "/qagAskQuestionPage";

  @override
  State<QagAskQuestionPage> createState() => _QagAskQuestionPageState();
}

class _QagAskQuestionPageState extends State<QagAskQuestionPage> {
  String question = "";
  String details = "";
  String firstname = "";
  ThematiqueWithIdViewModel? thematique;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThematiqueBloc(
            repository: RepositoryManager.getThematiqueRepository(),
          )..add(FetchThematiqueEvent()),
        ),
        BlocProvider(
          create: (context) => CreateQagBloc(qagRepository: RepositoryManager.getQagRepository()),
        ),
      ],
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
                            showCounterText: true,
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
                            showCounterText: true,
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
                              thematique = value;
                            },
                          ),
                          SizedBox(height: AgoraSpacings.x1_5),
                          Text(QagStrings.yourNameTitle, style: AgoraTextStyles.medium18),
                          SizedBox(height: AgoraSpacings.x0_75),
                          AgoraTextField(
                            maxLength: 50,
                            hintText: QagStrings.yourNameHint,
                            showCounterText: true,
                            onChanged: (input) {
                              firstname = input;
                            },
                          ),
                          SizedBox(height: AgoraSpacings.base),
                          Text(QagStrings.askQuestionInformation, style: AgoraTextStyles.light14),
                          SizedBox(height: AgoraSpacings.base),
                          BlocConsumer<CreateQagBloc, CreateQagState>(
                            listener: (context, createQagState) {
                              if (createQagState is CreateQagSuccessState) {
                                Navigator.pushNamed(context, QagAskQuestionConfirmationPage.routeName);
                              }
                            },
                            builder: (context, createQagState) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (createQagState is CreateQagErrorState) ...[
                                    SizedBox(height: AgoraSpacings.base),
                                    AgoraErrorView(),
                                    SizedBox(height: AgoraSpacings.base),
                                  ],
                                  if (createQagState is CreateQagLoadingState) SizedBox(height: AgoraSpacings.base),
                                  AgoraButton(
                                    label: QagStrings.send,
                                    isLoading: createQagState is CreateQagLoadingState,
                                    style: AgoraButtonStyle.primaryButtonStyle,
                                    onPressed: () async {
                                      if (_couldSend()) {
                                        context.read<CreateQagBloc>().add(
                                              CreateQagEvent(
                                                title: question,
                                                description: details,
                                                author: firstname,
                                                thematiqueId: thematique!.id,
                                              ),
                                            );
                                      }
                                    },
                                  ),
                                ],
                              );
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
