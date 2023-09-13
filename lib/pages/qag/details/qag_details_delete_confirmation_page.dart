import 'package:agora/bloc/qag/delete/qag_delete_bloc.dart';
import 'package:agora/bloc/qag/delete/qag_delete_event.dart';
import 'package:agora/bloc/qag/delete/qag_delete_state.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/consultations_page.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:agora/pages/qag/paginated/qags_paginated_page.dart';
import 'package:agora/pages/qag/qags_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QagDetailsDeleteConfirmationArguments {
  final String qagId;
  final QagReload reload;

  QagDetailsDeleteConfirmationArguments({
    required this.qagId,
    required this.reload,
  });
}

class QagDetailsDeleteConfirmationPage extends StatelessWidget {
  static const routeName = "/qagDetailsPageDeleteConfirmation";

  final QagDetailsDeleteConfirmationArguments arguments;

  const QagDetailsDeleteConfirmationPage({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => QagDeleteBloc(
            qagRepository: RepositoryManager.getQagRepository(),
          ),
        ),
      ],
      child: AgoraScaffold(
        appBarColor: AgoraColors.primaryBlue,
        child: BlocConsumer<QagDeleteBloc, QagDeleteState>(
          listener: (context, state) {
            if (state is QagDeleteSuccessState) {
              showAgoraDialog(
                context: context,
                columnChildren: [
                  Text(QagStrings.suppressSucceed, style: AgoraTextStyles.medium14),
                  SizedBox(height: AgoraSpacings.x0_75),
                  AgoraButton(
                    label: GenericStrings.close,
                    style: AgoraButtonStyle.primaryButtonStyle,
                    onPressed: () {
                      switch (arguments.reload) {
                        case QagReload.qagsPage:
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            QagsPage.routeName,
                            ModalRoute.withName(LoadingPage.routeName),
                          );
                          break;
                        case QagReload.qagsPaginatedPage:
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            QagsPaginatedPage.routeName,
                            arguments: QagsPaginatedArguments(initialTab: QagPaginatedTab.popular, thematiqueId: null),
                            (route) =>
                                route.settings.name == QagsPage.routeName ||
                                route.settings.name == ConsultationsPage.routeName,
                          );
                          break;
                      }
                    },
                  ),
                ],
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                AgoraTopDiagonal(),
                AgoraToolbar(),
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AgoraSpacings.horizontalPadding,
                      vertical: AgoraSpacings.x1_25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AgoraSpacings.x2),
                        Center(child: SvgPicture.asset("assets/ic_trash.svg", excludeFromSemantics: true)),
                        SizedBox(height: AgoraSpacings.x2),
                        Text(QagStrings.deleteQagConfirmationTitle, style: AgoraTextStyles.medium18),
                        SizedBox(height: AgoraSpacings.base),
                        Text(QagStrings.deleteQagConfirmationDetails, style: AgoraTextStyles.light14),
                        SizedBox(height: AgoraSpacings.x1_5),
                        AgoraButton(
                          label: GenericStrings.delete,
                          style: AgoraButtonStyle.redBorderButtonStyle,
                          isLoading: state is QagDeleteLoadingState,
                          onPressed: () => context.read<QagDeleteBloc>().add(DeleteQagEvent(qagId: arguments.qagId)),
                        ),
                        if (state is QagDeleteErrorState) ...[
                          SizedBox(height: AgoraSpacings.base),
                          AgoraErrorView(),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
