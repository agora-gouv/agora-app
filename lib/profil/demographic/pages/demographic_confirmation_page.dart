import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/consultation/dynamic/pages/dynamic_consultation_page.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/error/agora_error_text.dart';
import 'package:agora/profil/demographic/bloc/send/demographic_responses_send_bloc.dart';
import 'package:agora/profil/demographic/bloc/send/demographic_responses_send_event.dart';
import 'package:agora/profil/demographic/bloc/send/demographic_responses_send_state.dart';
import 'package:agora/profil/demographic/bloc/stock/demographic_responses_stock_bloc.dart';
import 'package:agora/profil/demographic/pages/demographic_profil_page.dart';
import 'package:agora/profil/pages/profil_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            if (_areResponsesSent(state)) {
              if (_isProfileJourney()) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  DemographicProfilPage.routeName,
                  ModalRoute.withName(ProfilPage.routeName),
                  arguments: DemographicProfileArguments(
                    modificationSuccess: state is SendDemographicResponsesSuccessState,
                  ),
                );
              } else {
                Navigator.pushNamed(
                  context,
                  DynamicConsultationPage.routeName,
                  arguments: DynamicConsultationPageArguments(
                    consultationIdOrSlug: consultationId!,
                    consultationTitle: consultationTitle!,
                    shouldLaunchCongratulationAnimation: true,
                  ),
                ).then((value) => Navigator.of(context).pop());
              }
            }
          },
          builder: (context, state) {
            if (state is SendDemographicResponsesFailureState) {
              return Column(
                children: [
                  AgoraToolbar(semanticPageLabel: 'Échec de l\'envoi des informations démographiques'),
                  SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
                  Center(child: AgoraErrorText()),
                ],
              );
            } else {
              return Column(
                children: [
                  AgoraToolbar(semanticPageLabel: 'Envoi en cours'),
                  SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
                  Center(child: CircularProgressIndicator()),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  bool _areResponsesSent(SendDemographicResponsesState state) =>
      state is SendDemographicResponsesSuccessState || state is SendDemographicResponsesFailureState;

  bool _isProfileJourney() => consultationId == null && consultationTitle == null;
}
