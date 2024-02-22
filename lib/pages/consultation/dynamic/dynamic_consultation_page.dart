import 'dart:math';

import 'package:agora/bloc/consultation/dynamic/dynamic_consultation_bloc.dart';
import 'package:agora/bloc/consultation/dynamic/dynamic_consultation_events.dart';
import 'package:agora/bloc/consultation/dynamic/dynamic_consultation_state.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/helper/notification_helper.dart';
import 'package:agora/common/helper/share_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_html.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/custom_view/agora_video_view.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/domain/consultation/dynamic/dynamic_consultation.dart';
import 'package:agora/domain/consultation/dynamic/dynamic_consultation_section.dart';
import 'package:agora/pages/consultation/dynamic/simple_html_parser.dart';
import 'package:agora/pages/consultation/question/consultation_question_page.dart';
import 'package:collection/collection.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';

part 'dynamic_consultation_view_model.dart';

part 'dynamic_consultation_presenter.dart';

part 'dynamic_consultation_section_widgets.dart';

class DynamicConsultationPage extends StatelessWidget {
  static const routeName = '/consultation/dynamic';

  final DynamicConsultationPageArguments arguments;

  DynamicConsultationPage(this.arguments);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return DynamicConsultationBloc(
          RepositoryManager.getConsultationRepository(),
        )..add(FetchDynamicConsultationEvent(arguments.consultationId));
      },
      child: BlocSelector<DynamicConsultationBloc, DynamicConsultationState, _ViewModel>(
        selector: _Presenter.getViewModelFromState,
        builder: (BuildContext context, _ViewModel viewModel) {
          return switch (viewModel) {
            _LoadingViewModel() => _LoadingPage(),
            _ErrorViewModel() => _ErrorPage(),
            _SuccessViewModel() =>
              _SuccessPage(viewModel, arguments.notificationTitle, arguments.notificationDescription),
          };
        },
      ),
    );
  }
}

class DynamicConsultationPageArguments {
  final String consultationId;
  final bool shouldReloadConsultationsWhenPop;
  final String? notificationTitle;
  final String? notificationDescription;

  DynamicConsultationPageArguments({
    required this.consultationId,
    this.shouldReloadConsultationsWhenPop = true,
    this.notificationTitle,
    this.notificationDescription,
  });
}

class _LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      child: Center(
        child: Column(
          children: [
            AgoraToolbar(pageLabel: '${ConsultationStrings.toolbarPart1}${ConsultationStrings.toolbarPart2}'),
            SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class _ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      child: Column(
        children: [
          AgoraToolbar(pageLabel: '${ConsultationStrings.toolbarPart1}${ConsultationStrings.toolbarPart2}'),
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
          Center(child: AgoraErrorView()),
        ],
      ),
    );
  }
}

class _SuccessPage extends StatelessWidget {
  final _SuccessViewModel viewModel;
  final String? notificationTitle;
  final String? notificationDescription;

  _SuccessPage(
    this.viewModel,
    this.notificationTitle,
    this.notificationDescription,
  );

  @override
  Widget build(BuildContext context) {
    NotificationHelper.displayNotificationWithDialog(
      context: context,
      notificationTitle: notificationTitle,
      notificationDescription: notificationDescription,
    );
    return AgoraScaffold(
      appBarColor: AgoraColors.primaryBlue,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AgoraTopDiagonal(),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: AgoraToolbar(
                  pageLabel: '${ConsultationStrings.toolbarPart1}${ConsultationStrings.toolbarPart2}',
                ),
              ),
              _ShareButton(viewModel.shareText),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.sections.length,
              itemBuilder: (BuildContext context, int index) {
                return _DynamicSectionWidget(viewModel.sections[index]);
              },
            ),
          ),
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
      child: AgoraButton(
        icon: "ic_share.svg",
        label: QagStrings.share,
        style: AgoraButtonStyle.lightGreyButtonStyle,
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
