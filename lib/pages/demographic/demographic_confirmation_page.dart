import 'package:agora/bloc/demographic/send/demographic_responses_send_bloc.dart';
import 'package:agora/bloc/demographic/send/demographic_responses_send_event.dart';
import 'package:agora/bloc/demographic/send/demographic_responses_send_state.dart';
import 'package:agora/bloc/demographic/stock/demographic_responses_stock_bloc.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/summary/consultation_summary_page.dart';
import 'package:agora/pages/demographic/demographic_profile_page.dart';
import 'package:agora/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DemographicConfirmationArguments {
  final String? consultationId;
  final DemographicResponsesStockBloc demographicResponsesStockBloc;

  DemographicConfirmationArguments({
    required this.consultationId,
    required this.demographicResponsesStockBloc,
  });
}

class DemographicConfirmationPage extends StatelessWidget {
  static const routeName = "/demographicConfirmationPage";

  final String? consultationId;

  DemographicConfirmationPage({required this.consultationId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SendDemographicResponsesBloc(
        demographicRepository: RepositoryManager.getDemographicRepository(),
      )..add(
          SendDemographicResponsesEvent(
            demographicResponses: context.read<DemographicResponsesStockBloc>().state.responses,
          ),
        ),
      child: AgoraScaffold(
        shouldPop: false,
        appBarColor: AgoraColors.primaryBlue,
        child: BlocConsumer<SendDemographicResponsesBloc, SendDemographicResponsesState>(
          listener: (context, state) {
            if (_isProfileJourney(state)) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                DemographicProfilePage.routeName,
                ModalRoute.withName(ProfilePage.routeName),
                arguments: DemographicProfileArguments(
                  modificationSuccess: state is SendDemographicResponsesSuccessState,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is SendDemographicResponsesSuccessState && consultationId != null) {
              return _buildContent(context);
            } else if (state is SendDemographicResponsesInitialLoadingState || _isProfileJourney(state)) {
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
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          AgoraTopDiagonal(),
          SizedBox(height: AgoraSpacings.base),
          SvgPicture.asset(
            "assets/ic_question_confirmation.svg",
            width: MediaQuery.of(context).size.width - AgoraSpacings.base,
          ),
          Padding(
            padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ConsultationStrings.confirmationTitle,
                  style: AgoraTextStyles.medium19,
                ),
                SizedBox(height: AgoraSpacings.base),
                Text(
                  ConsultationStrings.confirmationDescription,
                  style: AgoraTextStyles.light16,
                ),
                SizedBox(height: AgoraSpacings.x1_5),
                AgoraButton(
                  label: ConsultationStrings.goToResult,
                  style: AgoraButtonStyle.primaryButtonStyle,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      ConsultationSummaryPage.routeName,
                      arguments: consultationId,
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isProfileJourney(SendDemographicResponsesState state) =>
      (state is SendDemographicResponsesSuccessState || state is SendDemographicResponsesFailureState) &&
      consultationId == null;
}
