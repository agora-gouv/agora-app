import 'package:agora/bloc/demographic/send/demographic_responses_send_bloc.dart';
import 'package:agora/bloc/demographic/send/demographic_responses_send_event.dart';
import 'package:agora/bloc/demographic/send/demographic_responses_send_state.dart';
import 'package:agora/bloc/demographic/stock/demographic_responses_stock_bloc.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/common/helper/share_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/dynamic/dynamic_consultation_page.dart';
import 'package:agora/pages/demographic/demographic_profile_page.dart';
import 'package:agora/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DemographicConfirmationArguments {
  final String? consultationId;
  final String? consultationTitle;
  final DemographicResponsesStockBloc demographicResponsesStockBloc;

  DemographicConfirmationArguments({
    required this.consultationId,
    required this.consultationTitle,
    required this.demographicResponsesStockBloc,
  });
}

class DemographicConfirmationPage extends StatelessWidget {
  static const routeName = "/demographicConfirmationPage";

  final String? consultationId;
  final String? consultationTitle;

  DemographicConfirmationPage({required this.consultationId, required this.consultationTitle});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SendDemographicResponsesBloc(
        demographicRepository: RepositoryManager.getDemographicRepository(),
        profileDemographicStorageClient: StorageManager.getProfileDemographicStorageClient(),
      )..add(
          SendDemographicResponsesEvent(
            demographicResponses: context.read<DemographicResponsesStockBloc>().state.responses,
          ),
        ),
      child: AgoraScaffold(
        shouldPop: false,
        appBarType: AppBarColorType.primaryColor,
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
            } else if (_areResponsesSent(state)){
              Navigator.pushNamed(
                context,
                DynamicConsultationPage.routeName,
                arguments: DynamicConsultationPageArguments(
                  consultationId: consultationId!,
                ),
              ).then((value) => Navigator.of(context).pop());
            }
          },
          builder: (context, state) {
            if (state is SendDemographicResponsesSuccessState && consultationId != null && consultationTitle != null) {
              return _buildContent(context);
            } else if (state is SendDemographicResponsesInitialLoadingState || _isProfileJourney(state)) {
              return Column(
                children: [
                  AgoraToolbar(pageLabel: 'Envoi en cours'),
                  SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else {
              return Column(
                children: [
                  AgoraToolbar(pageLabel: 'Echec de l\'envoi des informations démographiques'),
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
    final largerThanMobile = ResponsiveHelper.isLargerThanMobile(context);
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: largerThanMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          AgoraTopDiagonal(),
          SizedBox(height: AgoraSpacings.base),
          SvgPicture.asset(
            "assets/ic_question_confirmation.svg",
            width: largerThanMobile
                ? MediaQuery.of(context).size.width * 0.7
                : MediaQuery.of(context).size.width - AgoraSpacings.base,
            excludeFromSemantics: true,
          ),
          Padding(
            padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
            child: Column(
              crossAxisAlignment: largerThanMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: [
                Semantics(
                  focused: true,
                  child: Text(
                    ConsultationStrings.confirmationTitle,
                    style: AgoraTextStyles.medium19,
                    textAlign: largerThanMobile ? TextAlign.center : TextAlign.start,
                  ),
                ),
                SizedBox(height: AgoraSpacings.base),
                Text(
                  ConsultationStrings.confirmationDescription,
                  style: AgoraTextStyles.light16,
                  textAlign: largerThanMobile ? TextAlign.center : TextAlign.start,
                ),
                SizedBox(height: AgoraSpacings.x1_5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: AgoraButton(
                        label: ConsultationStrings.goToResult,
                        style: AgoraButtonStyle.primaryButtonStyle,
                        onPressed: () {
                          TrackerHelper.trackClick(
                            clickName: "${AnalyticsEventNames.goToResult} $consultationId",
                            widgetName: AnalyticsScreenNames.demographicConfirmationPage,
                          );
                          Navigator.pushReplacementNamed(
                            context,
                            DynamicConsultationPage.routeName,
                            arguments: DynamicConsultationPageArguments(
                              consultationId: consultationId!,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: AgoraSpacings.base),
                    AgoraButton(
                      label: ConsultationStrings.share,
                      icon: "ic_share.svg",
                      style: AgoraButtonStyle.blueBorderButtonStyle,
                      onPressed: () async {
                        TrackerHelper.trackClick(
                          clickName: "${AnalyticsEventNames.shareConsultation} $consultationId",
                          widgetName: AnalyticsScreenNames.demographicConfirmationPage,
                        );
                        ShareHelper.shareConsultation(context: context, title: consultationTitle!, id: consultationId!);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isProfileJourney(SendDemographicResponsesState state) =>
      _areResponsesSent(state) && consultationId == null && consultationTitle == null;

  bool _areResponsesSent(SendDemographicResponsesState state) =>
      state is SendDemographicResponsesSuccessState || state is SendDemographicResponsesFailureState;
}
