import 'dart:async';

import 'package:agora/bloc/qag/create/qag_create_bloc.dart';
import 'package:agora/bloc/qag/create/qag_create_event.dart';
import 'package:agora/bloc/qag/create/qag_create_state.dart';
import 'package:agora/bloc/qag/similar/has_similar/qag_has_similar_bloc.dart';
import 'package:agora/bloc/qag/similar/has_similar/qag_has_similar_event.dart';
import 'package:agora/bloc/qag/similar/has_similar/qag_has_similar_state.dart';
import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/bloc/thematique/thematique_event.dart';
import 'package:agora/bloc/thematique/thematique_state.dart';
import 'package:agora/bloc/thematique/thematique_with_id_view_model.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_checkbox.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_more_information.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_secondary_style_view.dart';
import 'package:agora/design/custom_view/agora_text_field.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:agora/pages/profile/participation_charter_page.dart';
import 'package:agora/pages/qag/ask_question/qag_thematiques_drop_down.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:agora/pages/qag/qags_page.dart';
import 'package:agora/pages/qag/similar/qag_similar_page.dart';
import 'package:flutter/gestures.dart';
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
  bool isCheck = false;
  bool isQuestionLengthValid = false;
  bool shouldReloadQags = false;

  static const countdownDuration = Duration(seconds: 1);
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    final errorCase = ModalRoute.of(context)!.settings.arguments as String?;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThematiqueBloc(repository: RepositoryManager.getThematiqueRepository()),
        ),
        BlocProvider(
          create: (context) => CreateQagBloc(qagRepository: RepositoryManager.getQagRepository()),
        ),
        BlocProvider(
          create: (context) => QagHasSimilarBloc(qagRepository: RepositoryManager.getQagRepository()),
        ),
      ],
      child: AgoraScaffold(
        popAction: () {
          _backAction(context);
          return true;
        },
        child: BlocBuilder<ThematiqueBloc, ThematiqueState>(
          builder: (context, state) {
            return AgoraSecondaryStyleView(
              title: AgoraRichText(
                policeStyle: AgoraRichTextPoliceStyle.toolbar,
                items: [
                  AgoraRichTextTextItem(
                    text: QagStrings.askQuestionTitle1,
                    style: AgoraRichTextItemStyle.regular,
                  ),
                  AgoraRichTextTextItem(
                    text: QagStrings.askQuestionTitle2,
                    style: AgoraRichTextItemStyle.bold,
                  ),
                ],
              ),
              onBackClick: () {
                _backAction(context);
              },
              child: errorCase == null ? _buildState(context, state) : _buildErrorCase(context, errorCase),
            );
          },
        ),
      ),
    );
  }

  void _backAction(BuildContext context) {
    if (shouldReloadQags) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        QagsPage.routeName,
        ModalRoute.withName(LoadingPage.routeName),
      );
    } else {
      Navigator.pop(context);
    }
  }

  Widget _buildState(BuildContext context, ThematiqueState state) {
    if (state is ThematiqueSuccessState) {
      return _buildContent(context, state.thematiqueViewModels);
    } else if (state is ThematiqueInitialLoadingState) {
      context.read<ThematiqueBloc>().add(FetchAskQaGThematiqueEvent());
      return Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 3.5),
          Center(child: CircularProgressIndicator()),
        ],
      );
    } else if (state is ThematiqueErrorState) {
      return Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 3.5),
          Center(child: AgoraErrorView()),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildContent(BuildContext context, List<ThematiqueWithIdViewModel> thematiqueViewModels) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AgoraRichText(
                policeStyle: AgoraRichTextPoliceStyle.police14,
                items: [
                  AgoraRichTextTextItem(
                    text: QagStrings.askQuestionDescription1,
                    style: AgoraRichTextItemStyle.regular,
                  ),
                  AgoraRichTextSpaceItem(),
                  AgoraRichTextTextItem(
                    text: QagStrings.askQuestionDescription2,
                    style: AgoraRichTextItemStyle.bold,
                  ),
                  AgoraRichTextSpaceItem(),
                  AgoraRichTextTextItem(
                    text: QagStrings.askQuestionDescription3,
                    style: AgoraRichTextItemStyle.regular,
                  ),
                ],
              ),
              SizedBox(height: AgoraSpacings.base),
              Text(QagStrings.questionTitle, style: AgoraTextStyles.medium18),
              SizedBox(height: AgoraSpacings.x0_75),
              if (!isQuestionLengthValid) ...[
                Text(QagStrings.questionRequiredCondition, style: AgoraTextStyles.light14),
                SizedBox(height: AgoraSpacings.x1_25),
              ],
              AgoraTextField(
                maxLength: 200,
                hintText: QagStrings.questionHint,
                showCounterText: true,
                onChanged: (input) {
                  setState(() {
                    question = input;
                    isQuestionLengthValid = question.length >= 10;
                    _startTimer(context, question);
                  });
                },
              ),
              BlocBuilder<QagHasSimilarBloc, QagHasSimilarState>(
                builder: (context, state) {
                  switch (state) {
                    case QagHasSimilarInitialState():
                    case QagHasSimilarErrorState():
                      return Container();
                    case QagHasSimilarLoadingState():
                      return CircularProgressIndicator();
                    case QagHasSimilarSuccessState():
                      if (state.hasSimilar) {
                        return AgoraButton(
                          label: QagStrings.similarQagDetected,
                          style: AgoraButtonStyle.blueBorderButtonStyle,
                          icon: "ic_info_2.svg",
                          onPressed: () => Navigator.pushNamed(
                            context,
                            QagSimilarPage.routeName,
                            arguments: question,
                          ).then(
                            (shouldReloadQags) => setState(() => this.shouldReloadQags = shouldReloadQags as bool),
                          ),
                        );
                      } else {
                        return Container();
                      }
                  }
                },
              ),
              SizedBox(height: AgoraSpacings.x0_75),
              Text(QagStrings.detailsTitle, style: AgoraTextStyles.medium18),
              SizedBox(height: AgoraSpacings.x0_5),
              Text(QagStrings.detailsDescription, style: AgoraTextStyles.light14),
              SizedBox(height: AgoraSpacings.x0_75),
              AgoraTextField(
                maxLength: 400,
                hintText: QagStrings.detailsHint,
                showCounterText: true,
                onChanged: (input) => setState(() => details = input),
              ),
              SizedBox(height: AgoraSpacings.x0_75),
              Text(QagStrings.thematiqueTitle, style: AgoraTextStyles.medium18),
              SizedBox(height: AgoraSpacings.x0_5),
              QagThematiquesDropDown(
                firstValue: null,
                elements: thematiqueViewModels,
                hintText: QagStrings.thematiqueHint,
                onSelected: (value) => setState(() => thematique = value),
              ),
              SizedBox(height: AgoraSpacings.x1_5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(QagStrings.yourNameTitle, style: AgoraTextStyles.medium18),
                  SizedBox(width: AgoraSpacings.x0_5),
                  AgoraMoreInformation(
                    onClick: () {
                      showAgoraDialog(
                        context: context,
                        columnChildren: [
                          RichText(
                            textScaleFactor: MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              style: AgoraTextStyles.light16,
                              children: [
                                TextSpan(text: QagStrings.yourNameInfoBubble1),
                                WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                                TextSpan(
                                  text: QagStrings.yourNameInfoBubble2,
                                  style: AgoraTextStyles.light16Underline.copyWith(color: AgoraColors.primaryBlue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => LaunchUrlHelper.webview(context, ProfileStrings.privacyPolicyLink),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AgoraSpacings.x0_75),
                          AgoraButton(
                            label: GenericStrings.close,
                            style: AgoraButtonStyle.primaryButtonStyle,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: AgoraSpacings.x0_75),
              AgoraTextField(
                maxLength: 50,
                hintText: QagStrings.yourNameHint,
                showCounterText: true,
                onChanged: (input) => setState(() => firstname = input),
              ),
              SizedBox(height: AgoraSpacings.base),
              Text(QagStrings.askQuestionInformation, style: AgoraTextStyles.light14),
              SizedBox(height: AgoraSpacings.base),
              AgoraButton(
                label: QagStrings.readNotice,
                style: AgoraButtonStyle.lightGreyButtonStyle,
                onPressed: () => Navigator.pushNamed(context, ParticipationCharterPage.routeName),
              ),
              SizedBox(height: AgoraSpacings.x1_5),
              AgoraCheckbox(
                defaultValue: false,
                label: QagStrings.askQuestionCheckboxLabel,
                onChanged: (value) => setState(() => isCheck = value),
              ),
              SizedBox(height: AgoraSpacings.x2),
              BlocConsumer<CreateQagBloc, CreateQagState>(
                listener: (context, createQagState) {
                  if (createQagState is CreateQagSuccessState) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      QagsPage.routeName,
                      ModalRoute.withName(LoadingPage.routeName),
                    );
                    Navigator.pushNamed(
                      context,
                      QagDetailsPage.routeName,
                      arguments: QagDetailsArguments(qagId: createQagState.qagId),
                    );
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
                        onPressed: _couldSend()
                            ? () {
                                TrackerHelper.trackClick(
                                  clickName: AnalyticsEventNames.sendAskQuestion,
                                  widgetName: AnalyticsScreenNames.qagAskQuestionPage,
                                );
                                context.read<CreateQagBloc>().add(
                                      CreateQagEvent(
                                        title: question,
                                        description: details,
                                        author: firstname,
                                        thematiqueId: thematique!.id!,
                                      ),
                                    );
                              }
                            : null,
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
    );
  }

  Widget _buildErrorCase(BuildContext context, String errorCase) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Text(errorCase, style: AgoraTextStyles.light14),
      ),
    );
  }

  bool _couldSend() {
    return question.length >= 10 && thematique != null && firstname.isNotBlank() && isCheck;
  }

  void _startTimer(BuildContext context, String inputQuestion) {
    timer?.cancel();
    timer = Timer(
      countdownDuration,
      () => context.read<QagHasSimilarBloc>().add(QagHasSimilarEvent(title: inputQuestion)),
    );
  }
}
