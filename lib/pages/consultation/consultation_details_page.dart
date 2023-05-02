import 'package:agora/bloc/consultation/details/consultation_details_bloc.dart';
import 'package:agora/bloc/consultation/details/consultation_details_event.dart';
import 'package:agora/bloc/consultation/details/consultation_details_state.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/agora_button.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_html.dart';
import 'package:agora/design/custom_view/agora_participants_progress_bar.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/pages/consultation/question/consultation_question_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConsultationDetailsArguments {
  final String consultationId;

  ConsultationDetailsArguments({required this.consultationId});
}

class ConsultationDetailsPage extends StatelessWidget {
  static const routeName = "/consultationDetailsPage";

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as ConsultationDetailsArguments;
    return BlocProvider(
      create: (BuildContext context) {
        return ConsultationDetailsBloc(
          consultationRepository: RepositoryManager.getConsultationRepository(),
          deviceInfoHelper: HelperManager.getDeviceInfoHelper(),
        )..add(FetchConsultationDetailsEvent(consultationId: arguments.consultationId));
      },
      child: AgoraScaffold(
        child: BlocBuilder<ConsultationDetailsBloc, ConsultationDetailsState>(
          builder: (context, state) {
            const columnPadding = AgoraSpacings.horizontalPadding;
            const spacing = AgoraSpacings.x0_5;
            const icPersonIconSize = 21;
            if (state is ConsultationDetailsFetchedState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    AgoraToolbar(),
                    Image.network(state.viewModel.cover),
                    Padding(
                      padding: const EdgeInsets.all(columnPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ThematiqueHelper.buildCard(context, state.viewModel.thematique),
                          SizedBox(height: AgoraSpacings.x0_75),
                          Text(state.viewModel.title, style: AgoraTextStyles.medium19),
                          SizedBox(height: AgoraSpacings.x1_5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Column(
                                  children: [
                                    _buildInformationItem(
                                      image: "ic_calendar.svg",
                                      text: state.viewModel.endDate,
                                      textStyle: AgoraTextStyles.regularItalic14,
                                    ),
                                    SizedBox(height: AgoraSpacings.x1_5),
                                    _buildInformationItem(
                                      image: "ic_query.svg",
                                      text: state.viewModel.questionCount,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: AgoraSpacings.x0_5),
                              Flexible(
                                child: Column(
                                  children: [
                                    _buildInformationItem(
                                      image: "ic_timer.svg",
                                      text: state.viewModel.estimatedTime,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: AgoraSpacings.x1_5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset("assets/ic_person.svg"),
                              SizedBox(width: spacing),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.viewModel.participantCountText,
                                    style: AgoraTextStyles.light14,
                                  ),
                                  SizedBox(height: AgoraSpacings.x0_5),
                                  AgoraParticipantsProgressBar(
                                    currentNbParticipants: state.viewModel.participantCount,
                                    objectiveNbParticipants: state.viewModel.participantCountGoal,
                                    minusPadding: columnPadding * 2 + spacing + icPersonIconSize,
                                  ),
                                  SizedBox(height: AgoraSpacings.x0_5),
                                  Text(
                                    state.viewModel.participantCountGoalText,
                                    style: AgoraTextStyles.light14,
                                  ),
                                  SizedBox(height: AgoraSpacings.x0_5),
                                ],
                              ),
                            ],
                          ),
                          Divider(height: AgoraSpacings.x1_5, color: AgoraColors.divider, thickness: 1),
                          AgoraHtml(data: state.viewModel.description),
                          SizedBox(height: AgoraSpacings.base),
                          AgoraRoundedCard(
                            cardColor: AgoraColors.cascadingWhite,
                            padding: const EdgeInsets.all(AgoraSpacings.x0_5),
                            child: AgoraHtml(data: state.viewModel.tipsDescription),
                          ),
                          SizedBox(height: AgoraSpacings.base),
                          AgoraButton(
                            label: ConsultationStrings.beginButton,
                            style: AgoraButtonStyle.primaryButtonStyle,
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                ConsultationQuestionPage.routeName,
                                arguments: arguments.consultationId,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ConsultationDetailsInitialLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: AgoraErrorView());
            }
          },
        ),
      ),
    );
  }

  Widget _buildInformationItem({
    required String image,
    required String text,
    TextStyle textStyle = AgoraTextStyles.light14,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset("assets/$image"),
        SizedBox(width: AgoraSpacings.x0_5),
        Expanded(child: Text(text, style: textStyle)),
      ],
    );
  }
}
