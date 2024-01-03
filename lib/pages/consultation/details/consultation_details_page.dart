import 'package:agora/bloc/consultation/details/consultation_details_bloc.dart';
import 'package:agora/bloc/consultation/details/consultation_details_event.dart';
import 'package:agora/bloc/consultation/details/consultation_details_state.dart';
import 'package:agora/bloc/consultation/details/consultation_details_view_model.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/notification_helper.dart';
import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_html.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/question/consultation_question_page.dart';
import 'package:agora/pages/consultation/summary/consultation_summary_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConsultationDetailsArguments {
  final String consultationId;
  final String? notificationTitle;
  final String? notificationDescription;

  ConsultationDetailsArguments({
    required this.consultationId,
    this.notificationTitle,
    this.notificationDescription,
  });
}

class ConsultationDetailsPage extends StatefulWidget {
  static const routeName = "/consultationDetailsPage";

  final ConsultationDetailsArguments arguments;

  const ConsultationDetailsPage({super.key, required this.arguments});

  @override
  State<ConsultationDetailsPage> createState() => _ConsultationDetailsPageState();
}

class _ConsultationDetailsPageState extends State<ConsultationDetailsPage> {
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
    return BlocProvider(
      create: (BuildContext context) {
        return ConsultationDetailsBloc(
          consultationRepository: RepositoryManager.getConsultationRepository(),
        )..add(FetchConsultationDetailsEvent(consultationId: widget.arguments.consultationId));
      },
      child: BlocConsumer<ConsultationDetailsBloc, ConsultationDetailsState>(
        listener: (previousState, currentState) {
          if (currentState is ConsultationDetailsFetchedState && currentState.viewModel.hasAnswered) {
            Navigator.pushNamed(
              context,
              ConsultationSummaryPage.routeName,
              arguments: ConsultationSummaryArguments(
                consultationId: widget.arguments.consultationId,
                shouldReloadConsultationsWhenPop: false,
                initialTab: ConsultationSummaryInitialTab.results,
              ),
            ).then((value) => Navigator.pop(context));
          }
        },
        builder: (context, state) {
          if (state is ConsultationDetailsFetchedState) {
            return _handleFetchState(context, state);
          } else if (state is ConsultationDetailsInitialLoadingState) {
            return _buildCommonContent(context, CircularProgressIndicator());
          } else {
            return _buildCommonContent(context, AgoraErrorView());
          }
        },
      ),
    );
  }

  Widget _handleFetchState(BuildContext context, ConsultationDetailsFetchedState state) {
    return AgoraScaffold(
      child: Column(
        children: [
          AgoraToolbar(pageLabel: 'Détail consultation'),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: _buildSuccessContent(context, state.viewModel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommonContent(BuildContext context, Widget widget) {
    return AgoraScaffold(
      child: Column(
        children: [
          AgoraToolbar(pageLabel: 'Détail consultation'),
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 3.5),
          Center(child: widget),
        ],
      ),
    );
  }

  Widget _buildSuccessContent(BuildContext context, ConsultationDetailsViewModel viewModel) {
    final largerThanMobile = ResponsiveHelper.isLargerThanMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!largerThanMobile) Image.network(viewModel.coverUrl, excludeFromSemantics: true),
        Padding(
          padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (largerThanMobile)
                Row(
                  children: [
                    Expanded(child: Image.network(viewModel.coverUrl, excludeFromSemantics: true)),
                    SizedBox(width: AgoraSpacings.base),
                    Expanded(child: _getConsultationInformation(context, viewModel)),
                  ],
                )
              else
                _getConsultationInformation(context, viewModel),
              Divider(height: AgoraSpacings.x1_5, color: AgoraColors.divider, thickness: 1),
              AgoraHtml(data: viewModel.description),
              SizedBox(height: AgoraSpacings.base),
              AgoraRoundedCard(
                cardColor: AgoraColors.cascadingWhite,
                padding: const EdgeInsets.all(AgoraSpacings.base),
                child: AgoraHtml(data: viewModel.tipsDescription),
              ),
              SizedBox(height: AgoraSpacings.base),
              AgoraButton(
                label: ConsultationStrings.beginButton,
                style: AgoraButtonStyle.primaryButtonStyle,
                onPressed: () {
                  TrackerHelper.trackClick(
                    clickName: "${AnalyticsEventNames.startConsultation} ${widget.arguments.consultationId}",
                    widgetName: AnalyticsScreenNames.consultationDetailsPage,
                  );
                  Navigator.pushNamed(
                    context,
                    ConsultationQuestionPage.routeName,
                    arguments: ConsultationQuestionArguments(
                      consultationId: viewModel.id,
                      consultationTitle: viewModel.title,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getConsultationInformation(BuildContext context, ConsultationDetailsViewModel viewModel) {
    final double progressBarValue = viewModel.participantCount / viewModel.participantCountGoal;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ThematiqueHelper.buildCard(context, viewModel.thematique),
        SizedBox(height: AgoraSpacings.x0_5),
        Text(viewModel.title, style: AgoraTextStyles.medium19),
        SizedBox(height: AgoraSpacings.x1_5),
        _buildInformationItem(
          image: "ic_calendar.svg",
          text: viewModel.endDate,
          textStyle: AgoraTextStyles.regularItalic14,
        ),
        SizedBox(height: AgoraSpacings.x1_5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(child: _buildInformationItem(image: "ic_timer.svg", text: viewModel.estimatedTime)),
            SizedBox(width: AgoraSpacings.x0_75),
            Flexible(child: _buildInformationItem(image: "ic_query.svg", text: viewModel.questionCount)),
          ],
        ),
        SizedBox(height: AgoraSpacings.x1_5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset("assets/ic_person.svg", excludeFromSemantics: true),
            SizedBox(width: AgoraSpacings.x0_5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(viewModel.participantCountText, style: AgoraTextStyles.light14),
                  SizedBox(height: AgoraSpacings.x0_5),
                  ExcludeSemantics(
                    child: LinearProgressIndicator(
                      minHeight: AgoraSpacings.x0_5,
                      backgroundColor: AgoraColors.orochimaru,
                      valueColor: AlwaysStoppedAnimation<Color>(AgoraColors.mountainLakeAzure),
                      value: progressBarValue > 1 ? 1 : progressBarValue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  SizedBox(height: AgoraSpacings.x0_5),
                  Text(
                    viewModel.participantCountGoalText,
                    style: AgoraTextStyles.light14,
                  ),
                  SizedBox(height: AgoraSpacings.x0_5),
                ],
              ),
            ),
          ],
        ),
      ],
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
        SvgPicture.asset("assets/$image", excludeFromSemantics: true),
        SizedBox(width: AgoraSpacings.x0_5),
        Expanded(child: Text(text, style: textStyle)),
      ],
    );
  }
}
