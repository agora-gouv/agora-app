import 'package:agora/bloc/qag/details/qag_details_bloc.dart';
import 'package:agora/bloc/qag/details/qag_details_event.dart';
import 'package:agora/bloc/qag/details/qag_details_state.dart';
import 'package:agora/bloc/qag/feedback/qag_feedback_bloc.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
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

class QagDetailsPage extends StatelessWidget {
  static const routeName = "/qagDetailsPage";

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
        appBarColor: AgoraColors.primaryGreen,
        child: BlocBuilder<QagDetailsBloc, QagDetailsState>(
          builder: (context, detailsState) {
            if (detailsState is QagDetailsFetchedState) {
              final viewModel = detailsState.viewModel;
              final support = viewModel.support;
              final response = viewModel.response;
              return AgoraSingleScrollView(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AgoraSpacings.horizontalPadding,
                          vertical: AgoraSpacings.x1_25,
                        ),
                        child: AgoraButton(
                          icon: "ic_share.svg",
                          label: QagStrings.share,
                          style: AgoraButtonStyle.lightGreyButtonStyle,
                          onPressed: () {
                            Share.share(
                              'Question au gouvernement : ${viewModel.title}\nagora://qag.gouv.fr/${arguments.qagId}',
                            );
                          },
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        AgoraTopDiagonal(),
                        AgoraToolbar(),
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
                                QagDetailsSupportView(qagId: arguments.qagId, support: support),
                              ],
                            ],
                          ),
                        ),
                        if (response != null)
                          QagDetailsResponseView(qagId: arguments.qagId, detailsViewModel: viewModel),
                      ],
                    ),
                  ],
                ),
              );
            } else if (detailsState is QagDetailsInitialLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: AgoraErrorView());
            }
          },
        ),
      ),
    );
  }
}
