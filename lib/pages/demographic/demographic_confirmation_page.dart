import 'package:agora/bloc/demographic/send/demographic_responses_send_bloc.dart';
import 'package:agora/bloc/demographic/send/demographic_responses_send_event.dart';
import 'package:agora/bloc/demographic/send/demographic_responses_send_state.dart';
import 'package:agora/bloc/demographic/stock/demographic_responses_stock_bloc.dart';
import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/summary/consultation_summary_page.dart';
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
      create: (BuildContext context) {
        return SendDemographicResponsesBloc(
          demographicRepository: RepositoryManager.getDemographicRepository(),
          deviceInfoHelper: HelperManager.getDeviceInfoHelper(),
        )..add(
            SendDemographicResponsesEvent(
              demographicResponses: context.read<DemographicResponsesStockBloc>().state.responses,
            ),
          );
      },
      child: AgoraScaffold(
        shouldPop: false,
        appBarColor: AgoraColors.primaryGreen,
        child: BlocBuilder<SendDemographicResponsesBloc, SendDemographicResponsesState>(
          builder: (context, state) {
            if (state is SendDemographicResponsesSuccessState) {
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
                              if (consultationId != null) {
                                Navigator.pushNamed(
                                  context,
                                  ConsultationSummaryPage.routeName,
                                  arguments: consultationId,
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is SendDemographicResponsesInitialLoadingState) {
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
