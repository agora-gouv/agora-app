import 'dart:math';

import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/helper/notification_helper.dart';
import 'package:agora/common/helper/share_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/common/parser/simple_html_parser.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/consultation/dynamic/bloc/dynamic_consultation_bloc.dart';
import 'package:agora/consultation/dynamic/bloc/dynamic_consultation_events.dart';
import 'package:agora/consultation/dynamic/bloc/dynamic_consultation_state.dart';
import 'package:agora/consultation/dynamic/domain/dynamic_consultation.dart';
import 'package:agora/consultation/dynamic/domain/dynamic_consultation_section.dart';
import 'package:agora/consultation/dynamic/pages/results/dynamic_consultation_results_page.dart';
import 'package:agora/consultation/dynamic/pages/updates/dynamic_consultation_update_page.dart';
import 'package:agora/consultation/question/pages/consultation_question_page.dart';
import 'package:agora/design/custom_view/agora_badge.dart';
import 'package:agora/design/custom_view/agora_collapse_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/error/agora_error_text.dart';
import 'package:agora/design/custom_view/fullscreen_animation_view.dart';
import 'package:agora/design/custom_view/text/agora_html.dart';
import 'package:agora/design/custom_view/text/agora_read_more_text.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/design/video/agora_video_view.dart';
import 'package:agora/referentiel/territoire.dart';
import 'package:agora/referentiel/territoire_helper.dart';
import 'package:collection/collection.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher_string.dart';

part 'dynamic_consultation_presenter.dart';
part 'dynamic_consultation_section_widgets.dart';
part 'dynamic_consultation_view_model.dart';

class DynamicConsultationPageArguments {
  final String consultationIdOrSlug;
  final String consultationTitle;
  final bool shouldReloadConsultationsWhenPop;
  final String? notificationTitle;
  final String? notificationDescription;
  final bool shouldLaunchCongratulationAnimation;

  DynamicConsultationPageArguments({
    required this.consultationIdOrSlug,
    required this.consultationTitle,
    this.shouldReloadConsultationsWhenPop = true,
    this.notificationTitle,
    this.notificationDescription,
    this.shouldLaunchCongratulationAnimation = false,
  });
}

class DynamicConsultationPage extends StatelessWidget {
  static const routeName = '/consultation/dynamic';

  final DynamicConsultationPageArguments arguments;

  DynamicConsultationPage(this.arguments);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return DynamicConsultationBloc(
          consultationRepository: RepositoryManager.getConsultationRepository(),
          referentielRepository: RepositoryManager.getReferentielRepository(),
          storageClient: StorageManager.getConsultationQuestionStorageClient(),
        )..add(FetchDynamicConsultationEvent(arguments.consultationIdOrSlug));
      },
      child: BlocSelector<DynamicConsultationBloc, DynamicConsultationState, DynamicConsultationViewModel>(
        selector: DynamicConsultationPresenter.getViewModelFromState,
        builder: (BuildContext context, DynamicConsultationViewModel viewModel) {
          return switch (viewModel) {
            _LoadingViewModel() => _LoadingPage(),
            _ErrorViewModel() => _ErrorPage(consultationTitle: arguments.consultationTitle),
            _SuccessViewModel() => _SuccessPage(
                viewModel,
                arguments.consultationTitle,
                arguments.notificationTitle,
                arguments.notificationDescription,
                arguments.shouldLaunchCongratulationAnimation,
              ),
          };
        },
      ),
    );
  }
}

class _SuccessPage extends StatelessWidget {
  final _SuccessViewModel viewModel;
  final String consultationTitle;
  final String? notificationTitle;
  final String? notificationDescription;
  final bool shouldLaunchCongratulationAnimation;

  _SuccessPage(
    this.viewModel,
    this.consultationTitle,
    this.notificationTitle,
    this.notificationDescription,
    this.shouldLaunchCongratulationAnimation,
  );

  @override
  Widget build(BuildContext context) {
    NotificationHelper.displayNotificationWithDialog(
      context: context,
      notificationTitle: notificationTitle,
      notificationDescription: notificationDescription,
    );
    final content = Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: AgoraToolbar(semanticPageLabel: "Consultation : $consultationTitle")),
            Padding(
              padding: const EdgeInsets.only(top: AgoraSpacings.x0_5),
              child: _ShareButton(viewModel.shareText),
            ),
            const SizedBox(width: AgoraSpacings.base),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: viewModel.sections.map((section) => DynamicConsultationSectionWidget(section)).toList(),
            ),
          ),
        ),
      ],
    );

    return AgoraScaffold(
      appBarType: AppBarColorType.primaryColor,
      child: switch (shouldLaunchCongratulationAnimation) {
        false => content,
        true => FullscreenAnimationView(
            animationName: "assets/animations/confetti.json",
            startDelayMillis: 250,
            animationSpeed: 1.25,
            child: content,
          )
      },
    );
  }
}

class _LoadingPage extends StatelessWidget {
  const _LoadingPage();

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      child: Center(
        child: Column(
          children: [
            AgoraToolbar(semanticPageLabel: ""),
            SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class _ErrorPage extends StatelessWidget {
  final String consultationTitle;

  const _ErrorPage({required this.consultationTitle});

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      child: Column(
        children: [
          AgoraToolbar(semanticPageLabel: "Consultation : $consultationTitle"),
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
          Center(child: AgoraErrorText()),
        ],
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  final String shareText;

  _ShareButton(this.shareText);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AgoraSpacings.x0_5),
      child: AgoraButton.withLabel(
        prefixIcon: "ic_share.svg",
        label: GenericStrings.share,
        semanticLabel: "Partager la consultation",
        buttonStyle: AgoraButtonStyle.secondary,
        onPressed: () {
          TrackerHelper.trackClick(
            clickName: AnalyticsEventNames.shareConsultation,
            widgetName: AnalyticsScreenNames.consultationDetailsPage,
          );
          ShareHelper.sharePreformatted(context: context, data: shareText);
        },
      ),
    );
  }
}
