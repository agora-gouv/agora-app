import 'package:agora/bloc/consultation/details/consultation_details_bloc.dart';
import 'package:agora/bloc/consultation/details/consultation_details_event.dart';
import 'package:agora/bloc/consultation/details/consultation_details_state.dart';
import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/bloc/thematique/thematique_state.dart';
import 'package:agora/common/client/repository_manager.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/agora_button.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_html_styles.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_participants_progress_bar.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_thematique_card.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/pages/consultation/consultation_question_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConsultationDetailsPage extends StatelessWidget {
  static const routeName = "/consultationDetailsPage";

  @override
  Widget build(BuildContext context) {
    const consultationId = "c29255f2-10ca-4be5-aab1-801ea173337c";
    return BlocProvider(
      create: (BuildContext context) {
        return ConsultationDetailsBloc(
          consultationRepository: RepositoryManager.getConsultationRepository(),
        )..add(FetchConsultationDetailsEvent(consultationId: consultationId));
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
                          _buildThematiqueCard(context, state.viewModel.thematiqueId),
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
                          Html(
                            data: state.viewModel.description,
                            style: AgoraHtmlStyles.htmlStyle,
                            onLinkTap: (url, _, __, ___) async {
                              LaunchUrlHelper.launch(url);
                            },
                          ),
                          SizedBox(height: AgoraSpacings.base),
                          AgoraRoundedCard(
                            cardColor: AgoraColors.cascadingWhite,
                            padding: const EdgeInsets.all(AgoraSpacings.x0_5),
                            child: Html(
                              data: state.viewModel.tipsDescription,
                              style: AgoraHtmlStyles.htmlStyle,
                            ),
                          ),
                          SizedBox(height: AgoraSpacings.base),
                          AgoraButton(
                            label: ConsultationStrings.beginButton,
                            style: AgoraButtonStyle.primaryButtonStyle,
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                ConsultationQuestionPage.routeName,
                                arguments: consultationId,
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

  Widget _buildThematiqueCard(BuildContext context, String thematiqueId) {
    final thematiqueState = context.read<ThematiqueBloc>().state;
    if (thematiqueState is ThematiqueSuccessState) {
      try {
        final thematique = thematiqueState.viewModel.firstWhere((thematique) => thematique.id == thematiqueId);
        return AgoraThematiqueCard(picto: thematique.picto, label: thematique.label, color: thematique.color);
      } catch (e) {
        return Container();
      }
    } else {
      return Container();
    }
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
