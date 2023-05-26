import 'package:agora/bloc/qag/details/qag_details_bloc.dart';
import 'package:agora/bloc/qag/details/qag_details_event.dart';
import 'package:agora/bloc/qag/details/qag_details_state.dart';
import 'package:agora/bloc/qag/details/qag_details_view_model.dart';
import 'package:agora/bloc/qag/feedback/qag_feedback_bloc.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class QagDetailsArguments {
  final String qagId;

  QagDetailsArguments({required this.qagId});
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

  @override
  State<QagDetailsPage> createState() => _QagDetailsPageState();
}

class _QagDetailsPageState extends State<QagDetailsPage> {
  QagDetailsBackResult? backResult;

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as QagDetailsArguments;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) {
            return QagDetailsBloc(qagRepository: RepositoryManager.getQagRepository())
              ..add(FetchQagDetailsEvent(qagId: arguments.qagId));
          },
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
        appBarColor: AgoraColors.primaryGreen,
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
          Row(
            children: [
              Expanded(child: AgoraToolbar(onBackClick: () => _popWithBackResult(context))),
              Padding(
                padding: const EdgeInsets.only(bottom: AgoraSpacings.x0_5),
                child: AgoraButton(
                  icon: "ic_share.svg",
                  label: QagStrings.share,
                  style: AgoraButtonStyle.lightGreyButtonStyle,
                  onPressed: () {
                    Share.share(
                      'Question au gouvernement : ${viewModel.title}\nagora://qag.gouv.fr/${viewModel.id}',
                    );
                  },
                ),
              ),
              SizedBox(width: AgoraSpacings.horizontalPadding),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ThematiqueHelper.buildCard(context, viewModel.thematique),
                SizedBox(height: AgoraSpacings.x0_5),
                Text(viewModel.title, style: AgoraTextStyles.medium18),
                SizedBox(height: AgoraSpacings.base),
                if (response == null)
                  Text(viewModel.description, style: AgoraTextStyles.light14)
                else
                  AgoraReadMoreText(viewModel.description, trimLines: 3),
                SizedBox(height: AgoraSpacings.base),
                if (support != null) ...[
                  RichText(
                    text: TextSpan(
                      style: AgoraTextStyles.medium14,
                      children: [
                        TextSpan(text: QagStrings.de),
                        WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                        TextSpan(
                          text: viewModel.username,
                          style: AgoraTextStyles.medium14.copyWith(color: AgoraColors.primaryGreen),
                        ),
                        WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                        TextSpan(text: QagStrings.at),
                        WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                        TextSpan(
                          text: viewModel.date,
                          style: AgoraTextStyles.medium14.copyWith(color: AgoraColors.primaryGreen),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: AgoraSpacings.x3),
                  QagDetailsSupportView(
                    qagId: viewModel.id,
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
                ],
              ],
            ),
          ),
          if (response != null) QagDetailsResponseView(qagId: viewModel.id, detailsViewModel: viewModel),
        ],
      ),
    );
  }

  void _popWithBackResult(BuildContext context) {
    Navigator.pop(context, backResult);
  }
}
