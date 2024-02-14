import 'package:agora/bloc/app_feedback/app_feedback_bloc.dart';
import 'package:agora/bloc/app_feedback/app_feedback_event.dart';
import 'package:agora/bloc/app_feedback/app_feedback_state.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/feedback_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_question_response_choice_view.dart';
import 'package:agora/design/custom_view/agora_questions_progress_bar.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/agora_text_field.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/domain/feedback/feedback.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

part 'app_feedback_first_step.dart';

part 'app_feedback_open_questions.dart';

class AppFeedbackPage extends StatelessWidget {
  static const routeName = "/feedback";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppFeedbackBloc(
        repository: RepositoryManager.getAppFeedbackRepository(),
        deviceInfoPluginHelper: HelperManager.getDeviceInfoHelper(),
      ),
      child: BlocSelector<AppFeedbackBloc, AppFeedbackState, _ViewModel>(
        selector: _ViewModel.fromState,
        builder: (BuildContext context, _ViewModel viewModel) {
          if (viewModel.isLoading) return _Loading();
          if (viewModel.isFinished) return _Success();
          if (viewModel.isError) return _Error();
          return _Content();
        },
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      popAction: () => false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height - 60),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AgoraToolbar(pageLabel: 'Envoi en cours'),
            Flexible(flex: 1, child: SizedBox()),
            Lottie.asset(
              'assets/animations/loading_consultation.json',
              width: MediaQuery.sizeOf(context).width,
            ),
            Center(child: Text('Envoi de vos réponses', style: AgoraTextStyles.light16)),
            Flexible(flex: 2, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}

class _Success extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: AgoraSpacings.base),
          Lottie.asset(
            'assets/animations/consultation_success.json',
            width: MediaQuery.sizeOf(context).width,
            height: 200,
            repeat: false,
            fit: BoxFit.fitHeight,
          ),
          Padding(
            padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  focused: true,
                  child: Text(
                    FeedbackStrings.thanks,
                    style: AgoraTextStyles.medium19,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: AgoraSpacings.base),
                Text(
                  FeedbackStrings.confirmationLabel,
                  style: AgoraTextStyles.light16,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AgoraSpacings.x1_5),
                AgoraButton(
                  label: FeedbackStrings.otherReturnButtonLabel,
                  style: AgoraButtonStyle.primaryButtonStyle,
                  onPressed: () {
                    context.read<AppFeedbackBloc>().add(ReinitAppFeedbackEvent());
                  },
                ),
                SizedBox(height: AgoraSpacings.base),
                AgoraButton(
                  label: GenericStrings.close,
                  style: AgoraButtonStyle.blueBorderButtonStyle,
                  onPressed: () {
                    Navigator.of(context).pop();
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

class _Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      child: Column(
        children: [
          AgoraToolbar(pageLabel: FeedbackStrings.errorLabel),
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
          Center(child: AgoraErrorView()),
        ],
      ),
    );
  }
}

class _Content extends StatefulWidget {
  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  _AppFeedbackChoice? type;

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      popAction: type == null
          ? null
          : () {
              setState(() {
                type = null;
              });
              return false;
            },
      child: switch (type) {
        _AppFeedbackChoice.bug => _Step2Screen(
            type: AppFeedbackType.bug,
            title: FeedbackStrings.bugTitle,
            contentDescription: FeedbackStrings.bugContentDescription,
            hint: FeedbackStrings.bugHint,
            subTitle: FeedbackStrings.bugSubTitle,
          ),
        _AppFeedbackChoice.comment => _Step2Screen(
            type: AppFeedbackType.comment,
            title: FeedbackStrings.commentTitle,
            hint: FeedbackStrings.commentHint,
            contentDescription: FeedbackStrings.commentHint,
            subTitle: ConsultationStrings.openedQuestionNotice,
          ),
        _AppFeedbackChoice.feature => _Step2Screen(
            type: AppFeedbackType.feature,
            title: FeedbackStrings.featureTitle,
            hint: FeedbackStrings.featureHint,
            contentDescription: FeedbackStrings.featureHint,
            subTitle: ConsultationStrings.openedQuestionNotice,
          ),
        _AppFeedbackChoice.mail => _MailQuestionScreen(),
        null => _FirstStepScreen(
            onTypeChosed: (choice) => setState(() {
              type = choice;
            }),
          ),
      },
    );
  }
}

class _ViewModel extends Equatable {
  final bool isLoading;
  final bool isError;
  final bool isFinished;

  _ViewModel({
    required this.isLoading,
    required this.isError,
    required this.isFinished,
  });

  factory _ViewModel.fromState(AppFeedbackState state) {
    return _ViewModel(
      isLoading: state == AppFeedbackState.loading,
      isError: state == AppFeedbackState.error,
      isFinished: state == AppFeedbackState.success,
    );
  }

  @override
  List<Object?> get props => [isLoading, isError, isFinished];
}

enum _AppFeedbackChoice {
  bug,
  comment,
  feature,
  mail;
}