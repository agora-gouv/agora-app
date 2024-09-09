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
import 'package:agora/design/custom_view/agora_like_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/error/agora_error_text.dart';
import 'package:agora/design/custom_view/text/agora_read_more_text.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/qag/details/bloc/qag_details_bloc.dart';
import 'package:agora/qag/details/bloc/qag_details_event.dart';
import 'package:agora/qag/details/bloc/qag_details_state.dart';
import 'package:agora/qag/details/bloc/qag_details_view_model.dart';
import 'package:agora/qag/details/bloc/support/qag_support_bloc.dart';
import 'package:agora/qag/details/bloc/support/qag_support_event.dart';
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
  final QagReload reload;

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
          Navigator.pop(context, backResult);
          return false;
        },
        appBarType: AppBarColorType.primaryColor,
        child: BlocBuilder<QagDetailsBloc, QagDetailsState>(
          builder: (context, detailsState) {
            return Column(
              children: [
                AgoraTopDiagonal(),
                _Content(
                  detailsState,
                  backResult,
                  widget.arguments,
                  (supportCount, isSupported) {
                    backResult = QagDetailsBackResult(
                      qagId: widget.arguments.qagId,
                      supportCount: supportCount,
                      isSupported: isSupported,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final QagDetailsState detailsState;
  final QagDetailsBackResult? backResult;
  final QagDetailsArguments arguments;
  final void Function(int, bool) onSupportChange;

  final feedbackKey = GlobalKey();

  _Content(this.detailsState, this.backResult, this.arguments, this.onSupportChange);

  @override
  Widget build(BuildContext context) {
    return switch (detailsState) {
      QagDetailsInitialLoadingState _ => _Loading(),
      QagDetailsModerateErrorState _ => QagsModeratedErrorContent(),
      QagDetailsErrorState _ => _Error(),
      final QagDetailsFetchedState successState =>
        _Success(successState.viewModel, backResult, arguments, feedbackKey, onSupportChange)
    };
  }
}

class _Success extends StatelessWidget {
  final QagDetailsViewModel viewModel;
  final QagDetailsBackResult? backResult;
  final QagDetailsArguments arguments;
  final GlobalKey feedbackKey;
  final void Function(int, bool) onSupportChange;

  const _Success(this.viewModel, this.backResult, this.arguments, this.feedbackKey, this.onSupportChange);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _Header(viewModel, backResult),
          Expanded(
            child: CustomScrollView(
              slivers: [
                _TitreSliver(
                  viewModel: viewModel,
                  isQuestionGagnante: arguments.isQuestionGagnante,
                ),
                _DescriptionSliver(
                  viewModel: viewModel,
                  isQuestionGagnante: arguments.isQuestionGagnante,
                  reload: arguments.reload,
                  onSupportChange: onSupportChange,
                ),
                if (viewModel.response != null)
                  SliverToBoxAdapter(
                    child: QagDetailsResponseView(qagId: viewModel.id, detailsViewModel: viewModel),
                  ),
                if (viewModel.textResponse != null)
                  SliverToBoxAdapter(
                    child: QagDetailsTextResponseView(qagId: viewModel.id, detailsViewModel: viewModel),
                  ),
                _FeedbackSliver(feedbackKey: feedbackKey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final QagDetailsViewModel viewModel;
  final QagDetailsBackResult? backResult;

  const _Header(this.viewModel, this.backResult);

  @override
  Widget build(BuildContext context) {
    return viewModel.canShare
        ? Row(
            children: [
              Expanded(
                child: AgoraToolbar(
                  onBackClick: () => Navigator.pop(context, backResult),
                  semanticPageLabel: 'Détail de la question citoyenne ${viewModel.title}',
                ),
              ),
              _ShareButton(viewModel),
              SizedBox(width: AgoraSpacings.horizontalPadding),
            ],
          )
        : AgoraToolbar(
            onBackClick: () => Navigator.pop(context, backResult),
            semanticPageLabel: 'Détail question citoyenne',
          );
  }
}

class _ShareButton extends StatelessWidget {
  final QagDetailsViewModel viewModel;

  const _ShareButton(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AgoraSpacings.x0_5),
      child: AgoraButton.withChildren(
        semanticLabel: "Partager la question",
        buttonStyle: AgoraButtonStyle.secondary,
        onPressed: () {
          TrackerHelper.trackClick(
            clickName: "${AnalyticsEventNames.shareQag} ${viewModel.id}",
            widgetName: AnalyticsScreenNames.qagDetailsPage,
          );
          if (viewModel.response == null && viewModel.textResponse == null) {
            ShareHelper.shareQag(context: context, title: viewModel.title, id: viewModel.id);
          } else {
            ShareHelper.shareQagAnswered(context: context, title: viewModel.title, id: viewModel.id);
          }
        },
        children: [
          Icon(Icons.ios_share, color: AgoraColors.primaryBlue, size: 20),
          SizedBox(width: AgoraSpacings.x0_5),
          Text(GenericStrings.share, style: AgoraTextStyles.secondaryButton, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _TitreSliver extends StatelessWidget {
  final QagDetailsViewModel viewModel;
  final bool isQuestionGagnante;

  const _TitreSliver({
    required this.viewModel,
    required this.isQuestionGagnante,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: AgoraSpacings.base,
        right: AgoraSpacings.base,
        bottom: AgoraSpacings.base,
      ),
      sliver: SliverToBoxAdapter(
        child: MergeSemantics(
          child: Semantics(
            header: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AgoraSpacings.x0_5),
                ThematiqueHelper.buildCard(context, viewModel.thematique),
                SizedBox(height: AgoraSpacings.x0_5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(viewModel.title, style: AgoraTextStyles.medium18)),
                    if ((viewModel.response != null || viewModel.textResponse != null) &&
                        viewModel.support.count != 0) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: AgoraSpacings.x0_5),
                        child: AgoraLikeView(
                          isSupported: viewModel.support.isSupported,
                          supportCount: viewModel.support.count,
                          shouldVocaliseSupport: false,
                          isQuestionGagnante: isQuestionGagnante,
                          onSupportClick: (bool support) {
                            if (support) {
                              TrackerHelper.trackClick(
                                clickName: AnalyticsEventNames.likeQag,
                                widgetName: AnalyticsScreenNames.qagDetailsPage,
                              );
                              context.read<QagSupportBloc>().add(SupportQagEvent(qagId: viewModel.id));
                            } else {
                              TrackerHelper.trackClick(
                                clickName: AnalyticsEventNames.unlikeQag,
                                widgetName: AnalyticsScreenNames.qagDetailsPage,
                              );
                              context.read<QagSupportBloc>().add(DeleteSupportQagEvent(qagId: viewModel.id));
                            }
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DescriptionSliver extends StatelessWidget {
  final QagDetailsViewModel viewModel;
  final bool isQuestionGagnante;
  final QagReload reload;
  final void Function(int, bool) onSupportChange;

  const _DescriptionSliver({
    required this.viewModel,
    required this.isQuestionGagnante,
    required this.reload,
    required this.onSupportChange,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: AgoraSpacings.base,
        right: AgoraSpacings.base,
        bottom: AgoraSpacings.base,
      ),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (viewModel.response == null && viewModel.textResponse == null) ...[
              if (viewModel.description.isNotEmpty) ...[
                Text(viewModel.description, style: AgoraTextStyles.light14),
                SizedBox(height: AgoraSpacings.base),
              ],
              Row(
                children: [
                  Expanded(
                    child: Text(
                      StringUtils.authorAndDate.format2(viewModel.username, viewModel.date),
                      style: AgoraTextStyles.medium14,
                    ),
                  ),
                  SizedBox(width: AgoraSpacings.base),
                  QagDetailsSupportView(
                    qagId: viewModel.id,
                    canSupport: viewModel.canSupport,
                    isQuestionGagnante: isQuestionGagnante,
                    supportViewModel: viewModel.support,
                    onSupportChange: onSupportChange,
                  ),
                ],
              ),
              if (viewModel.canDelete) _DeleteQaG(viewModel.id, reload),
            ] else
              AgoraReadMoreText(
                data: viewModel.description,
                isTalkbackEnabled: MediaQuery.accessibleNavigationOf(context),
                trimLines: 3,
              ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackSliver extends StatelessWidget {
  final GlobalKey feedbackKey;

  const _FeedbackSliver({required this.feedbackKey});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: QagDetailsFeedbackWidget(
        key: feedbackKey,
        onFeedbackSent: () {
          Scrollable.ensureVisible(
            feedbackKey.currentContext!,
            duration: Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
          );
        },
      ),
    );
  }
}

class _DeleteQaG extends StatelessWidget {
  final String qagId;
  final QagReload reload;

  const _DeleteQaG(this.qagId, this.reload);

  @override
  Widget build(BuildContext context) {
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
        AgoraButton.withLabel(
          label: GenericStrings.delete,
          buttonStyle: AgoraButtonStyle.redBorder,
          onPressed: () => Navigator.pushNamed(
            context,
            QagDetailsDeleteConfirmationPage.routeName,
            arguments: QagDetailsDeleteConfirmationArguments(
              qagId: qagId,
              reload: reload,
            ),
          ),
        ),
      ],
    );
  }
}

class _Error extends StatelessWidget {
  const _Error();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AgoraToolbar(semanticPageLabel: 'Détail question citoyenne'),
        SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
        Center(child: AgoraErrorText()),
      ],
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AgoraToolbar(semanticPageLabel: ""),
        SizedBox(height: MediaQuery.of(context).size.height / 10 * 3.5),
        Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
