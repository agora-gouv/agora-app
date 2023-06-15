import 'package:agora/bloc/qag/details/qag_details_bloc.dart';
import 'package:agora/bloc/qag/details/qag_details_event.dart';
import 'package:agora/bloc/qag/details/qag_details_state.dart';
import 'package:agora/bloc/qag/details/qag_details_view_model.dart';
import 'package:agora/bloc/qag/feedback/qag_feedback_bloc.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/share_helper.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_like_view.dart';
import 'package:agora/design/custom_view/agora_read_more_text.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/qag/details/qag_details_response_view.dart';
import 'package:agora/pages/qag/details/qag_details_support_view.dart';
import 'package:agora/pages/qag/qags_moderated_error_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagDetailsArguments {
  final String qagId;
  final String? infoMessage;

  QagDetailsArguments({required this.qagId, this.infoMessage});
}

class QagDetailsBackResult {
  final String qagId;
  final ThematiqueViewModel thematique;
  final String title;
  final String username;
  final String date;
  final int supportCount;
  final bool isSupported;

  QagDetailsBackResult({
    required this.qagId,
    required this.thematique,
    required this.title,
    required this.username,
    required this.date,
    required this.supportCount,
    required this.isSupported,
  });
}

class QagDetailsPage extends StatefulWidget {
  static const routeName = "/qagDetailsPage";

  final String qagId;
  final String? infoMessage;

  const QagDetailsPage({super.key, required this.qagId, this.infoMessage});

  @override
  State<QagDetailsPage> createState() => _QagDetailsPageState();
}

class _QagDetailsPageState extends State<QagDetailsPage> {
  QagDetailsBackResult? backResult;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.infoMessage != null) {
        showAgoraDialog(
          context: context,
          columnChildren: [
            Text(widget.infoMessage!, style: AgoraTextStyles.light16),
            SizedBox(height: AgoraSpacings.x0_75),
            AgoraButton(
              label: GenericStrings.close,
              style: AgoraButtonStyle.primaryButtonStyle,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => QagDetailsBloc(
            qagRepository: RepositoryManager.getQagRepository(),
          )..add(FetchQagDetailsEvent(qagId: widget.qagId)),
        ),
        BlocProvider(
          create: (BuildContext context) => QagSupportBloc(qagRepository: RepositoryManager.getQagRepository()),
        ),
        BlocProvider(
          create: (BuildContext context) => QagFeedbackBloc(qagRepository: RepositoryManager.getQagRepository()),
        ),
      ],
      child: AgoraScaffold(
        popAction: () => _popWithBackResult(context),
        appBarColor: AgoraColors.primaryBlue,
        child: BlocBuilder<QagDetailsBloc, QagDetailsState>(
          builder: (context, detailsState) {
            return AgoraSingleScrollView(
              child: Column(
                children: [
                  AgoraTopDiagonal(),
                  _buildState(context, detailsState),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildState(BuildContext context, QagDetailsState detailsState) {
    if (detailsState is QagDetailsFetchedState) {
      return _buildContent(context, detailsState.viewModel);
    } else if (detailsState is QagDetailsInitialLoadingState) {
      return Column(
        children: [
          AgoraToolbar(),
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
          Center(child: CircularProgressIndicator()),
        ],
      );
    } else if (detailsState is QagDetailsModerateErrorState) {
      return QagsModeratedErrorContent();
    } else {
      return Column(
        children: [
          AgoraToolbar(),
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
          Center(child: AgoraErrorView()),
        ],
      );
    }
  }

  Widget _buildContent(BuildContext context, QagDetailsViewModel viewModel) {
    final support = viewModel.support;
    final response = viewModel.response;
    return Expanded(
      child: Column(
        children: [
          viewModel.canShare
              ? Row(
                  children: [
                    Expanded(child: _buildAgoraToolbarWithPopAction(context)),
                    Padding(
                      padding: const EdgeInsets.only(bottom: AgoraSpacings.x0_5),
                      child: AgoraButton(
                        icon: "ic_share.svg",
                        label: QagStrings.share,
                        style: AgoraButtonStyle.lightGreyButtonStyle,
                        onPressed: () {
                          TrackerHelper.trackClick(
                            clickName: "${AnalyticsEventNames.shareQag} ${viewModel.id}",
                            widgetName: AnalyticsScreenNames.qagDetailsPage,
                          );
                          ShareHelper.shareQag(title: viewModel.title, id: viewModel.id);
                        },
                      ),
                    ),
                    SizedBox(width: AgoraSpacings.horizontalPadding),
                  ],
                )
              : _buildAgoraToolbarWithPopAction(context),
          Padding(
            padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ThematiqueHelper.buildCard(context, viewModel.thematique),
                SizedBox(height: AgoraSpacings.x0_5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(viewModel.title, style: AgoraTextStyles.medium18)),
                    if (response != null) ...[
                      SizedBox(width: AgoraSpacings.x0_75),
                      Padding(
                        padding: const EdgeInsets.only(top: AgoraSpacings.x0_5),
                        child: AgoraLikeView(isSupported: support.isSupported, supportCount: support.count),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: AgoraSpacings.base),
                if (response == null) ...[
                  Text(viewModel.description, style: AgoraTextStyles.light14),
                  SizedBox(height: AgoraSpacings.base),
                  Text(
                    QagStrings.authorAndDate.format2(viewModel.username, viewModel.date),
                    style: AgoraTextStyles.medium14,
                  ),
                  SizedBox(height: AgoraSpacings.x3),
                  QagDetailsSupportView(
                    qagId: viewModel.id,
                    canSupport: viewModel.canSupport,
                    support: support,
                    onSupportChange: (supportCount, isSupported) {
                      backResult = QagDetailsBackResult(
                        qagId: viewModel.id,
                        thematique: viewModel.thematique,
                        title: viewModel.title,
                        username: viewModel.username,
                        date: viewModel.date,
                        supportCount: supportCount,
                        isSupported: isSupported,
                      );
                    },
                  ),
                ] else
                  AgoraReadMoreText(viewModel.description, trimLines: 3),
              ],
            ),
          ),
          if (response != null) QagDetailsResponseView(qagId: viewModel.id, detailsViewModel: viewModel),
        ],
      ),
    );
  }

  AgoraToolbar _buildAgoraToolbarWithPopAction(BuildContext context) =>
      AgoraToolbar(onBackClick: () => _popWithBackResult(context));

  void _popWithBackResult(BuildContext context) {
    Navigator.pop(context, backResult);
  }
}
