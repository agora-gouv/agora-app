import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/emoji_helper.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/helper/semantics_helper.dart';
import 'package:agora/common/helper/timer_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_checkbox.dart';
import 'package:agora/design/custom_view/agora_more_information.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_secondary_style_view_button.dart';
import 'package:agora/design/custom_view/error/agora_error_text.dart';
import 'package:agora/design/custom_view/error/agora_error_view.dart';
import 'package:agora/design/custom_view/text/agora_html.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/custom_view/text/agora_text_field.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/profil/participation_charter/pages/participation_charter_page.dart';
import 'package:agora/qag/ask/bloc/create/qag_create_bloc.dart';
import 'package:agora/qag/ask/bloc/create/qag_create_event.dart';
import 'package:agora/qag/ask/bloc/create/qag_create_state.dart';
import 'package:agora/qag/ask/pages/ask_question_qag_search.dart';
import 'package:agora/qag/ask/pages/qag_thematiques_drop_down.dart';
import 'package:agora/qag/details/pages/qag_details_page.dart';
import 'package:agora/qag/pages/qags_page.dart';
import 'package:agora/splash_page.dart';
import 'package:agora/thematique/bloc/thematique_bloc.dart';
import 'package:agora/thematique/bloc/thematique_event.dart';
import 'package:agora/thematique/bloc/thematique_state.dart';
import 'package:agora/thematique/bloc/thematique_with_id_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  bool shouldReloadQags = false;

  static const _questionMinLength = 10;
  static const _questionMaxLength = 200;
  static const _detailMaxLength = 400;
  static const _nameMaxLength = 50;
  bool isQuestionLengthError = false;

  final timerHelper = TimerHelper(countdownDurationInSecond: 3);

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
      ],
      child: AgoraScaffold(
        popAction: () {
          _backAction(context);
          return false;
        },
        child: BlocBuilder<ThematiqueBloc, ThematiqueState>(
          builder: (context, state) {
            return AgoraSecondaryStyleView(
              semanticPageLabel: QagStrings.askQuestionTitle,
              title: AgoraRichText(
                policeStyle: AgoraRichTextPoliceStyle.toolbar,
                items: [
                  AgoraRichTextItem(
                    text: QagStrings.askQuestionTitle1,
                    style: AgoraRichTextItemStyle.regular,
                  ),
                  AgoraRichTextItem(
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
        ModalRoute.withName(SplashPage.routeName),
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
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 3),
          Center(child: CircularProgressIndicator()),
        ],
      );
    } else if (state is ThematiqueErrorState) {
      return Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 3),
          Center(
            child: AgoraErrorView(
              onReload: () => context.read<ThematiqueBloc>().add(FetchAskQaGThematiqueEvent()),
            ),
          ),
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
                semantic: AgoraRichTextSemantic(header: false),
                items: [
                  AgoraRichTextItem(
                    text: QagStrings.askQuestionDescription1,
                    style: AgoraRichTextItemStyle.regular,
                  ),
                  AgoraRichTextItem(
                    text: QagStrings.askQuestionDescription2,
                    style: AgoraRichTextItemStyle.regular,
                  ),
                ],
              ),
              AgoraHtml(
                data: QagStrings.askQuestionDescription3,
                fontSize: 14.0,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: AgoraSpacings.base),
              Text(QagStrings.askQagObligatoireSaufContraire, style: AgoraTextStyles.light14),
              SizedBox(height: AgoraSpacings.base),
              ExcludeSemantics(child: Text(QagStrings.questionTitle, style: AgoraTextStyles.medium18)),
              SizedBox(height: AgoraSpacings.x0_75),
              AgoraTextField(
                contentDescription: QagStrings.questionTitle,
                maxLength: _questionMaxLength,
                hintText: QagStrings.questionHint,
                showCounterText: true,
                error: isQuestionLengthError,
                onChanged: (input) {
                  setState(() {
                    question = input;
                    var shouldCheckQuestionLength = false;
                    if (question.length >= _questionMinLength) {
                      isQuestionLengthError = false;
                    } else {
                      shouldCheckQuestionLength = true;
                    }
                    timerHelper.startTimer(() {
                      _checkError(shouldCheckQuestionLength: shouldCheckQuestionLength);
                    });
                  });
                },
              ),
              if (isQuestionLengthError) ...[
                SizedBox(height: AgoraSpacings.x0_75),
                AgoraErrorText(errorMessage: QagStrings.questionRequiredCondition),
              ],
              const SizedBox(height: AgoraSpacings.x0_75),
              _AstuceElement(),
              SizedBox(height: AgoraSpacings.base),
              ExcludeSemantics(child: Text(QagStrings.detailsTitle, style: AgoraTextStyles.medium18)),
              SizedBox(height: AgoraSpacings.x0_5),
              ExcludeSemantics(child: Text(QagStrings.detailsDescription, style: AgoraTextStyles.light14)),
              SizedBox(height: AgoraSpacings.x0_75),
              AgoraTextField(
                contentDescription: "${QagStrings.detailsTitle} ${QagStrings.detailsDescription}",
                maxLength: _detailMaxLength,
                hintText: QagStrings.detailsHint,
                showCounterText: true,
                onChanged: (input) => setState(() => details = input),
              ),
              SizedBox(height: AgoraSpacings.x0_75),
              ExcludeSemantics(child: Text(QagStrings.thematiqueTitle, style: AgoraTextStyles.medium18)),
              SizedBox(height: AgoraSpacings.x0_5),
              QagThematiquesDropDown(
                firstValue: null,
                elements: thematiqueViewModels,
                hintText: QagStrings.thematiqueHint,
                onSelected: (value) => setState(() => thematique = value),
              ),
              SizedBox(height: AgoraSpacings.x1_5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(QagStrings.yourNameTitle, style: AgoraTextStyles.medium18),
                  _InfoBouton(),
                ],
              ),
              SizedBox(height: AgoraSpacings.x0_375),
              AgoraTextField(
                contentDescription: QagStrings.yourNameTitle,
                maxLength: _nameMaxLength,
                hintText: QagStrings.yourNameHint,
                showCounterText: true,
                onChanged: (input) => setState(() => firstname = input),
              ),
              SizedBox(height: AgoraSpacings.base),
              Text(QagStrings.askQuestionInformation, style: AgoraTextStyles.light14),
              SizedBox(height: AgoraSpacings.base),
              AgoraButton(
                label: QagStrings.readNotice,
                buttonStyle: AgoraButtonStyle.secondary,
                onPressed: () => Navigator.pushNamed(context, ParticipationCharterPage.routeName),
              ),
              SizedBox(height: AgoraSpacings.base),
              AgoraCheckbox(
                value: isCheck,
                label: QagStrings.askQuestionCheckboxLabel,
                onChanged: (value) => setState(() => isCheck = value),
              ),
              SizedBox(height: AgoraSpacings.x1_5),
              BlocConsumer<CreateQagBloc, CreateQagState>(
                listener: (context, createQagState) {
                  if (createQagState is CreateQagSuccessState) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      QagsPage.routeName,
                      ModalRoute.withName(SplashPage.routeName),
                    );
                    Navigator.pushNamed(
                      context,
                      QagDetailsPage.routeName,
                      arguments: QagDetailsArguments(qagId: createQagState.qagId, reload: QagReload.qagsPage),
                    );
                  }
                },
                builder: (context, createQagState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (createQagState is CreateQagErrorState) ...[
                        SizedBox(height: AgoraSpacings.base),
                        AgoraErrorText(),
                        SizedBox(height: AgoraSpacings.base),
                      ],
                      if (createQagState is CreateQagErrorUnauthorizedState) ...[
                        SizedBox(height: AgoraSpacings.base),
                        AgoraErrorText(errorMessage: GenericStrings.errorUnauthorizedMessage),
                        SizedBox(height: AgoraSpacings.base),
                      ],
                      if (createQagState is CreateQagLoadingState) SizedBox(height: AgoraSpacings.base),
                      AgoraButton(
                        label: QagStrings.send,
                        isLoading: createQagState is CreateQagLoadingState,
                        isDisabled: !_couldSend(),
                        buttonStyle: AgoraButtonStyle.primary,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(errorCase, style: AgoraTextStyles.light14),
          SizedBox(height: AgoraSpacings.x1_5, width: double.infinity),
          Center(
            child: AgoraButton(
              label: QagStrings.goToAllQuestion,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _couldSend() {
    return question.isNotBlank() &&
        question.length <= _questionMaxLength &&
        details.length <= _detailMaxLength &&
        firstname.length <= _nameMaxLength &&
        question.length >= _questionMinLength &&
        thematique != null &&
        firstname.isNotBlank() &&
        isCheck;
  }

  void _checkError({required bool shouldCheckQuestionLength}) {
    setState(() {
      if (shouldCheckQuestionLength) {
        final hasErrorNow = (question.isNullOrBlank() && question.isNotEmpty) ||
            (question.isNotBlank() && question.length < _questionMinLength);
        if (hasErrorNow && hasErrorNow != isQuestionLengthError) {
          SemanticsHelper.announceErrorInQuestion();
        }
        isQuestionLengthError = hasErrorNow;
      }
    });
  }
}

class _InfoBouton extends StatelessWidget {
  const _InfoBouton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: AgoraMoreInformation(
        onClick: () {
          showAgoraDialog(
            context: context,
            columnChildren: [
              RichText(
                textScaler: MediaQuery.textScalerOf(context),
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
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2, left: 4),
                        child: SvgPicture.asset(
                          'assets/ic_external_link.svg',
                          excludeFromSemantics: true,
                          height: 20,
                          width: 20,
                          colorFilter: const ColorFilter.mode(AgoraColors.primaryGrey, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AgoraSpacings.x0_75),
              AgoraButton(
                label: GenericStrings.close,
                buttonStyle: AgoraButtonStyle.primary,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AstuceElement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(AgoraCorners.rounded),
      child: Material(
        color: AgoraColors.blue525opacity06,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              SearchPageFromAskQuestionPage.routeName,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(AgoraSpacings.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  QagStrings.astuceQuestionTitre,
                  semanticsLabel: EmojiHelper.clean(QagStrings.astuceQuestionTitre),
                  textAlign: TextAlign.start,
                  style: AgoraTextStyles.medium14,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: AgoraSpacings.base),
                  child: RichText(
                    textScaler: MediaQuery.textScalerOf(context),
                    text: TextSpan(
                      style: AgoraTextStyles.regular14,
                      children: [
                        TextSpan(text: QagStrings.astuceQuestionDescription),
                        TextSpan(
                          text: QagStrings.astuceQuestionDescriptionLink,
                          style: AgoraTextStyles.light14UnderlineBlue,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
