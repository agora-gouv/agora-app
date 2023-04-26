import 'package:agora/bloc/qag/details/qag_details_bloc.dart';
import 'package:agora/bloc/qag/details/qag_details_event.dart';
import 'package:agora/bloc/qag/details/qag_details_state.dart';
import 'package:agora/bloc/qag/feedback/qag_feedback_bloc.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/common/client/helper_manager.dart';
import 'package:agora/common/client/repository_manager.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/agora_button.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_read_more_text.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/pages/qag/qag_details_response_view.dart';
import 'package:agora/pages/qag/qag_details_support_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class QagDetailsArguments {
  final ThematiqueBloc thematiqueBloc;
  final String qagId;

  QagDetailsArguments({required this.thematiqueBloc, required this.qagId});
}

class QagDetailsPage extends StatefulWidget {
  static const routeName = "/qagDetailsPage";
  final String qagId;

  const QagDetailsPage({super.key, required this.qagId});

  @override
  State<QagDetailsPage> createState() => _QagDetailsPageState();
}

class _QagDetailsPageState extends State<QagDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) {
            return QagDetailsBloc(
              qagRepository: RepositoryManager.getQagRepository(),
              deviceIdHelper: HelperManager.getDeviceInfoHelper(),
            )..add(FetchQagDetailsEvent(qagId: widget.qagId));
          },
        ),
        BlocProvider(
          create: (BuildContext context) => QagSupportBloc(
            qagRepository: RepositoryManager.getQagRepository(),
            deviceIdHelper: HelperManager.getDeviceInfoHelper(),
          ),
        ),
        BlocProvider(
          create: (BuildContext context) => QagFeedbackBloc(
            qagRepository: RepositoryManager.getQagRepository(),
            deviceIdHelper: HelperManager.getDeviceInfoHelper(),
          ),
        ),
      ],
      child: AgoraScaffold(
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
                          vertical: AgoraSpacings.x0_5,
                        ),
                        child: AgoraButton(
                          icon: "ic_share.svg",
                          label: QagStrings.share,
                          style: AgoraButtonStyle.lightGreyButtonStyle,
                          onPressed: () {
                            Share.share(
                              'Question au gouvernement : ${viewModel.title}\nagora://qag.gouv.fr/${widget.qagId}',
                            );
                          },
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        AgoraToolbar(),
                        Padding(
                          padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ThematiqueHelper.buildCard(context, viewModel.thematiqueId),
                              SizedBox(height: AgoraSpacings.base),
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
                                    style: AgoraTextStyles.regularItalic14
                                        .copyWith(color: AgoraColors.primaryGreyOpacity80),
                                    children: [
                                      TextSpan(text: QagStrings.by),
                                      WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                                      TextSpan(
                                        text: viewModel.username,
                                        style: AgoraTextStyles.mediumItalic14
                                            .copyWith(color: AgoraColors.primaryGreyOpacity80),
                                      ),
                                      WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                                      TextSpan(text: QagStrings.at),
                                      WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                                      TextSpan(
                                        text: viewModel.date,
                                        style: AgoraTextStyles.mediumItalic14
                                            .copyWith(color: AgoraColors.primaryGreyOpacity80),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: AgoraSpacings.x3),
                                QagDetailsSupportView(qagId: widget.qagId, support: support),
                              ],
                            ],
                          ),
                        ),
                        if (response != null) QagDetailsResponseView(qagId: widget.qagId, detailsViewModel: viewModel),
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
