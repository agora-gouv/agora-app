import 'package:agora/bloc/qag/qag_bloc.dart';
import 'package:agora/bloc/qag/qag_event.dart';
import 'package:agora/bloc/qag/qag_state.dart';
import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_main_toolbar.dart';
import 'package:agora/design/custom_view/agora_qag_response_card.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/qag/qag_ask_question_page.dart';
import 'package:agora/pages/qag/qag_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QagsPage extends StatelessWidget {
  static const routeName = "/qagsPage";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return QagBloc(
          qagRepository: RepositoryManager.getQagRepository(),
          deviceInfoHelper: HelperManager.getDeviceInfoHelper(),
        )..add(FetchQagsEvent());
      },
      child: AgoraScaffold(
        backgroundColor: AgoraColors.background,
        child: BlocBuilder<QagBloc, QagState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  AgoraMainToolbar(
                    title: RichText(
                      text: TextSpan(
                        style: AgoraTextStyles.light24.copyWith(height: 1.2),
                        children: [
                          TextSpan(
                            text: "${QagStrings.toolbarPart1}\n",
                            style: AgoraTextStyles.bold24.copyWith(height: 1.2),
                          ),
                          TextSpan(text: QagStrings.toolbarPart2),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: AgoraSpacings.horizontalPadding,
                      top: AgoraSpacings.base,
                      right: AgoraSpacings.horizontalPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _handleQagState(context, state),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _handleQagState(BuildContext context, QagState state) {
    if (state is QagFetchedState) {
      return _buildQagResponseSection(context, state.viewModels) + _buildAskQuestionSection(context);
    } else if (state is QagInitialLoadingState) {
      return [
        SizedBox(height: AgoraSpacings.base),
        Center(child: CircularProgressIndicator()),
        SizedBox(height: AgoraSpacings.x2),
      ];
    } else if (state is QagErrorState) {
      return [
        SizedBox(height: AgoraSpacings.base),
        Center(child: AgoraErrorView()),
        SizedBox(height: AgoraSpacings.x2),
      ];
    }
    return [];
  }

  List<Widget> _buildAskQuestionSection(BuildContext context) {
    return [
      SizedBox(height: AgoraSpacings.x3),
      Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AgoraTextStyles.light18.copyWith(height: 1.2),
                children: [
                  TextSpan(text: "${QagStrings.allQagPart1}\n"),
                  TextSpan(
                    text: QagStrings.allQagPart2,
                    style: AgoraTextStyles.bold18.copyWith(height: 1.2),
                  ),
                ],
              ),
            ),
          ),
          AgoraRoundedButton(
            label: QagStrings.askQuestion,
            onPressed: () {
              Navigator.pushNamed(context, QagAskQuestionPage.routeName);
            },
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildQagResponseSection(BuildContext context, List<QagResponseViewModel> qagResponses) {
    if (qagResponses.isNotEmpty) {
      return [
        buildQagResponseHeader(context),
        SizedBox(height: AgoraSpacings.x0_75),
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(children: _buildQagResponseCard(context, qagResponses)),
        ),
      ];
    } else {
      return [];
    }
  }

  List<Widget> _buildQagResponseCard(BuildContext context, List<QagResponseViewModel> qagResponses) {
    final List<Widget> qagWidget = List.empty(growable: true);
    for (final qagResponse in qagResponses) {
      qagWidget.add(
        AgoraQagResponseCard(
          thematique: qagResponse.thematique,
          title: qagResponse.title,
          authorImageUrl: qagResponse.authorPortraitUrl,
          author: qagResponse.author,
          date: qagResponse.responseDate,
          onClick: () {
            Navigator.pushNamed(
              context,
              QagDetailsPage.routeName,
              arguments: QagDetailsArguments(qagId: qagResponse.qagId),
            );
          },
        ),
      );
      qagWidget.add(SizedBox(width: AgoraSpacings.x0_5));
    }
    return qagWidget;
  }

  Widget buildQagResponseHeader(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            style: AgoraTextStyles.light18.copyWith(height: 1.2),
            children: [
              TextSpan(
                text: "${QagStrings.qagResponsePart1}\n",
                style: AgoraTextStyles.bold18.copyWith(height: 1.2),
              ),
              TextSpan(text: QagStrings.qagResponsePart2),
            ],
          ),
        ),
        SizedBox(width: AgoraSpacings.x0_75),
        GestureDetector(
          child: SvgPicture.asset("assets/ic_info.svg"),
          onTap: () {
            showAgoraDialog(
              context: context,
              dismissible: true,
              columnChildren: [Text("A faire")],
            );
          },
        ),
        Spacer(),
        AgoraRoundedButton(
          label: GenericStrings.all,
          style: AgoraRoundedButtonStyle.lightGreyButton,
          onPressed: () {
            // TODO
          },
        ),
      ],
    );
  }
}
