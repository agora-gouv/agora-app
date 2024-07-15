import 'package:agora/qag/details/bloc/qag_details_bloc.dart';
import 'package:agora/qag/details/bloc/qag_details_event.dart';
import 'package:agora/qag/details/bloc/qag_details_state.dart';
import 'package:agora/qag/details/bloc/qag_details_view_model.dart';
import 'package:agora/qag/details/bloc/support/qag_support_bloc.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/notification_helper.dart';
import 'package:agora/common/helper/share_helper.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/common/strings/string_utils.dart';
import 'package:agora/design/custom_view/error/agora_error_text.dart';
import 'package:agora/design/custom_view/agora_like_view.dart';
import 'package:agora/design/custom_view/text/agora_read_more_text.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/qag/details/pages/qag_details_delete_confirmation_page.dart';
import 'package:agora/qag/details/pages/qag_details_feedback_widget.dart';
import 'package:agora/qag/details/pages/qag_details_response_view.dart';
import 'package:agora/qag/details/pages/qag_details_support_view.dart';
import 'package:agora/qag/details/pages/qag_details_text_response_view.dart';
import 'package:agora/qag/details/pages/qags_moderated_error_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum QagReload { qagsPage, qagsPaginatedPage }

class QagDetailsArguments {
  final String qagId;
  final bool isQuestionGagnante;
  final String? notificationTitle;
  final String? notificationDescription;
  final QagReload? reload;

  QagDetailsArguments({
    required this.qagId,
    this.isQuestionGagnante = false,
    this.notificationTitle,
    this.notificationDescription,
    required this.reload,
  });
}

class QagDetailsBackResult {
  final String qagId;
  final int supportCount;
  final bool isSupported;

  QagDetailsBackResult({
    required this.qagId,
    required this.supportCount,
    required this.isSupported,
  });
}

class QagDetailsPage extends StatefulWidget {
  static const routeName = "/qagDetailsPage";

  final QagDetailsArguments arguments;

  const QagDetailsPage({super.key, required this.arguments});

  @override
  State<QagDetailsPage> createState() => _QagDetailsPageState();
}

class _QagDetailsPageState extends State<QagDetailsPage> {
  QagDetailsBackResult? backResult;

  @override
  void initState() {
    super.initState();
    NotificationHelper.displayNotificationWithDialog(
      context: context,
      notificationTitle: widget.arguments.notificationTitle,
      notificationDescription: widget.arguments.notificationDescription,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => QagDetailsBloc(
            qagRepository: RepositoryManager.getQagRepository(),
          )..add(FetchQagDetailsEvent(qagId: widget.arguments.qagId)),
        ),
        BlocProvider(
          create: (BuildContext context) => QagSupportBloc(qagRepository: RepositoryManager.getQagRepository()),
        ),
      ],
      child: AgoraScaffold(
        popAction: () {
          _popWithBackResult(context);
          return false;
        },
        appBarType: AppBarColorType.primaryColor,
        child: BlocBuilder<QagDetailsBloc, QagDetailsState>(
          builder: (context, detailsState) {
            return Column(
              children: [
                AgoraTopDiagonal(),
                _buildState(context, detailsState),
              ],
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
          AgoraToolbar(pageLabel: 'Détail question citoyenne'),
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 3.5),
          Center(child: CircularProgressIndicator()),
        ],
      );
    } else if (detailsState is QagDetailsModerateErrorState) {
      return QagsModeratedErrorContent();
    } else {
      return Column(
        children: [
          AgoraToolbar(pageLabel: 'Détail question citoyenne'),
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
          Center(child: AgoraErrorText()),
        ],
      );
    }
  }

  Widget _buildContent(BuildContext context, QagDetailsViewModel viewModel) {
    final support = viewModel.support;
    final response = viewModel.response;
    final textResponse = viewModel.textResponse;
    final scrollController = ScrollController();
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
                        prefixIcon: "ic_share.svg",
                        label: GenericStrings.share,
                        semanticLabel: "Partager la question",
                        buttonStyle: AgoraButtonStyle.lightGrey,
                        onPressed: () {
                          TrackerHelper.trackClick(
                            clickName: "${AnalyticsEventNames.shareQag} ${viewModel.id}",
                            widgetName: AnalyticsScreenNames.qagDetailsPage,
                          );
                          if (response == null && textResponse == null) {
                            ShareHelper.shareQag(context: context, title: viewModel.title, id: viewModel.id);
                          } else {
                            ShareHelper.shareQagAnswered(context: context, title: viewModel.title, id: viewModel.id);
                          }
                        },
                      ),
                    ),
                    SizedBox(width: AgoraSpacings.horizontalPadding),
                  ],
                )
              : _buildAgoraToolbarWithPopAction(context),
          Expanded(
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                _buildSliverContainer(
                  horizontalPadding: AgoraSpacings.base,
                  bottomSpacing: AgoraSpacings.x0_5,
                  child: ThematiqueHelper.buildCard(context, viewModel.thematique),
                ),
                _buildSliverContainer(
                  horizontalPadding: AgoraSpacings.base,
                  bottomSpacing: AgoraSpacings.base,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: Text(viewModel.title, style: AgoraTextStyles.medium18),
                        ),
                      ),
                      if ((response != null || textResponse != null) && support.count != 0) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: AgoraSpacings.x0_5),
                          child: AgoraLikeView(
                            isSupported: support.isSupported,
                            supportCount: support.count,
                            shouldVocaliseSupport: false,
                            isQuestionGagnante: widget.arguments.isQuestionGagnante,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                _buildSliverContainer(
                  horizontalPadding: AgoraSpacings.base,
                  bottomSpacing: AgoraSpacings.base,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (response == null && textResponse == null) ...[
                        Text(viewModel.description, style: AgoraTextStyles.light14),
                        SizedBox(height: AgoraSpacings.base),
                        Text(
                          StringUtils.authorAndDate.format2(viewModel.username, viewModel.date),
                          style: AgoraTextStyles.medium14,
                        ),
                        SizedBox(height: AgoraSpacings.x3),
                        QagDetailsSupportView(
                          qagId: viewModel.id,
                          canSupport: viewModel.canSupport,
                          isQuestionGagnante: widget.arguments.isQuestionGagnante,
                          support: support,
                          onSupportChange: (supportCount, isSupported) {
                            backResult = QagDetailsBackResult(
                              qagId: viewModel.id,
                              supportCount: supportCount,
                              isSupported: isSupported,
                            );
                          },
                        ),
                        if (viewModel.canDelete) _buildDeleteQag(context, viewModel.id),
                      ] else
                        AgoraReadMoreText(viewModel.description, trimLines: 3),
                    ],
                  ),
                ),
                response != null
                    ? _buildSliverContainer(
                        child: QagDetailsResponseView(qagId: viewModel.id, detailsViewModel: viewModel),
                      )
                    : SliverToBoxAdapter(),
                textResponse != null
                    ? _buildSliverContainer(
                        child: QagDetailsTextResponseView(qagId: viewModel.id, detailsViewModel: viewModel),
                      )
                    : SliverToBoxAdapter(),
                _buildSliverContainer(
                  child: QagDetailsFeedbackWidget(
                    onFeedbackSent: () {
                      scrollController.animateTo(
                        MediaQuery.of(context).size.width,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.fastOutSlowIn,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverContainer({
    double horizontalPadding = 0,
    double bottomSpacing = 0,
    required Widget child,
  }) {
    return SliverPadding(
      padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, bottom: bottomSpacing),
      sliver: SliverToBoxAdapter(child: child),
    );
  }

  Column _buildDeleteQag(BuildContext context, String id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AgoraSpacings.base),
        Divider(color: AgoraColors.divider, thickness: 1),
        SizedBox(height: AgoraSpacings.base),
        Text(QagStrings.deleteQagTitle, style: AgoraTextStyles.medium18),
        SizedBox(height: AgoraSpacings.base),
        Text(QagStrings.deleteQagDetails, style: AgoraTextStyles.light14),
        SizedBox(height: AgoraSpacings.base),
        AgoraButton(
          label: GenericStrings.delete,
          buttonStyle: AgoraButtonStyle.redBorder,
          onPressed: () => Navigator.pushNamed(
            context,
            QagDetailsDeleteConfirmationPage.routeName,
            arguments: QagDetailsDeleteConfirmationArguments(
              qagId: id,
              reload: widget.arguments.reload!,
            ),
          ),
        ),
      ],
    );
  }

  AgoraToolbar _buildAgoraToolbarWithPopAction(BuildContext context) =>
      AgoraToolbar(onBackClick: () => _popWithBackResult(context), pageLabel: 'Détail question citoyenne');

  void _popWithBackResult(BuildContext context) {
    Navigator.pop(context, backResult);
  }
}
