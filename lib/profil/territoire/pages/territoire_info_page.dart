import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_badge.dart';
import 'package:agora/design/custom_view/agora_little_separator.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_secondary_style_view_button.dart';
import 'package:agora/design/custom_view/error/agora_error_view.dart';
import 'package:agora/design/custom_view/skeletons.dart';
import 'package:agora/design/custom_view/text/agora_link_text.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/profil/demographic/bloc/get/demographic_information_bloc.dart';
import 'package:agora/profil/demographic/bloc/get/demographic_information_event.dart';
import 'package:agora/profil/pages/profil_page.dart';
import 'package:agora/profil/territoire/bloc/territoire_info_bloc.dart';
import 'package:agora/profil/territoire/bloc/territoire_info_event.dart';
import 'package:agora/profil/territoire/bloc/territoire_info_state.dart';
import 'package:agora/profil/territoire/pages/territoire_editing_page.dart';
import 'package:agora/referentiel/territoire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TerritoireInfoPage extends StatelessWidget {
  static const routeName = "/territoireInfoPage";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TerritoireInfoBloc>(
      create: (BuildContext context) => TerritoireInfoBloc(
        referentielRepository: RepositoryManager.getReferentielRepository(),
        demographicRepository: RepositoryManager.getDemographicRepository(),
      )..add(GetTerritoireInfoEvent()),
      child: AgoraScaffold(
        child: BlocBuilder<TerritoireInfoBloc, TerritoireInfoState>(
          builder: (context, state) {
            return AgoraSecondaryStyleView(
              semanticPageLabel: DemographicStrings.my + DemographicStrings.information,
              title: _Title(),
              onBackClick: () => Navigator.pushReplacementNamed(context, ProfilPage.routeName),
              button: state.status == AllPurposeStatus.success
                  ? AgoraButton.withLabel(
                      buttonStyle: AgoraButtonStyle.tertiary,
                      label: GenericStrings.modify,
                      semanticLabel: "Modifier mes territoires",
                      onPressed: () => Navigator.pushNamed(
                        context,
                        TerritoireEditingPage.routeName,
                        arguments: TerritoireEditingPageArguments(
                            departementsSuivis:
                                state.status == AllPurposeStatus.success ? state.departementsSuivis : []),
                      ),
                    )
                  : null,
              child: _build(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _build(BuildContext context, TerritoireInfoState state) {
    return switch (state.status) {
      AllPurposeStatus.notLoaded || AllPurposeStatus.loading => _LoadingView(),
      AllPurposeStatus.error => _ErrorView(),
      AllPurposeStatus.success => _SuccessView(
          departementsSuivis: state.departementsSuivis,
          regionsSuivies: state.regionsSuivies,
        ),
    };
  }
}

class _SuccessView extends StatelessWidget {
  final List<Territoire> departementsSuivis;
  final List<Territoire> regionsSuivies;

  const _SuccessView({required this.departementsSuivis, required this.regionsSuivies});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Vous suivez actuellement :", style: AgoraTextStyles.regular16),
          SizedBox(height: AgoraSpacings.base),
          Text(
            "Département 1 : ",
            style: AgoraTextStyles.regular16,
          ),
          SizedBox(height: AgoraSpacings.x0_25),
          departementsSuivis.isNotEmpty
              ? Row(
                  children: [
                    AgoraBadge(label: departementsSuivis[0].label.toUpperCase()),
                    SizedBox(width: AgoraSpacings.x0_5),
                    Text("-", style: AgoraTextStyles.medium16),
                    SizedBox(width: AgoraSpacings.x0_5),
                    AgoraBadge(
                      label: regionsSuivies[0].label.toUpperCase(),
                      backgroundColor: AgoraColors.badgeRegional,
                      textColor: AgoraColors.badgeRegionalTexte,
                    ),
                  ],
                )
              : Text(
                  "Non renseigné",
                  style: AgoraTextStyles.medium16.copyWith(color: AgoraColors.blue525),
                ),
          SizedBox(height: AgoraSpacings.base),
          Text(
            "Département 2 : ",
            style: AgoraTextStyles.regular16,
          ),
          SizedBox(height: AgoraSpacings.x0_25),
          departementsSuivis.length == 2
              ? Row(
                  children: [
                    AgoraBadge(label: departementsSuivis[1].label.toUpperCase()),
                    SizedBox(width: AgoraSpacings.x0_5),
                    Text("-", style: AgoraTextStyles.medium16),
                    SizedBox(width: AgoraSpacings.x0_5),
                    AgoraBadge(
                      label: regionsSuivies[1].label.toUpperCase(),
                      backgroundColor: AgoraColors.badgeRegional,
                      textColor: AgoraColors.badgeRegionalTexte,
                    ),
                  ],
                )
              : Text(
                  "Non renseigné",
                  style: AgoraTextStyles.medium16.copyWith(color: AgoraColors.blue525),
                ),
          SizedBox(height: AgoraSpacings.x1_5),
          AgoraLittleSeparator(),
          SizedBox(height: AgoraSpacings.base),
          Text(
            "Ces informations nous permettent de vous donner donner accès aux consultations propres aux départements et régions choisis. Conformément au RGPD, vous avez la possibilité de consulter, modifier ou supprimer l'ensemble des informations vous concernant.",
            style: AgoraTextStyles.light15,
          ),
          SizedBox(height: AgoraSpacings.x0_5),
          AgoraLinkText(
            label: DemographicStrings.demographicInformationNotice3,
            textPadding: EdgeInsets.zero,
            onTap: () => LaunchUrlHelper.webview(context, ProfileStrings.privacyPolicyLink),
          ),
          SizedBox(height: AgoraSpacings.x1_25),
          AgoraButton.withLabel(
            label: "Supprimer mes territoires",
            buttonStyle: AgoraButtonStyle.redBorder,
            onPressed: () {
              showAgoraDialog(
                context: context,
                columnChildren: [
                  Text("Êtes-vous sûr(e) de vouloir supprimer vos territoires ?", style: AgoraTextStyles.medium16),
                  SizedBox(height: AgoraSpacings.x1_5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AgoraButton.withLabel(
                          label: GenericStrings.yes,
                          buttonStyle: AgoraButtonStyle.primary,
                          onPressed: () {
                            context.read<TerritoireInfoBloc>().add(
                                  SendTerritoireInfoEvent(
                                    departementsSuivis: [],
                                    regionsSuivies: [],
                                  ),
                                );
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(width: AgoraSpacings.x1_5),
                      Expanded(
                        child: AgoraButton.withLabel(
                          label: GenericStrings.no,
                          buttonStyle: AgoraButtonStyle.secondary,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return AgoraRichText(
      policeStyle: AgoraRichTextPoliceStyle.toolbar,
      items: [
        AgoraRichTextItem(
          text: 'Mes ',
          style: AgoraRichTextItemStyle.regular,
        ),
        AgoraRichTextItem(
          text: "territoires",
          style: AgoraRichTextItemStyle.bold,
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height / 10 * 3),
        Center(
          child: AgoraErrorView(
            onReload: () => context.read<DemographicInformationBloc>().add(GetDemographicInformationEvent()),
          ),
        ),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(AgoraSpacings.base),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AgoraSpacings.base),
            SkeletonBox(height: 12, width: 100),
            SizedBox(height: AgoraSpacings.base),
            SkeletonBox(height: 12, width: 180),
            SizedBox(height: AgoraSpacings.x2),
            SkeletonBox(height: 12, width: 150),
            SizedBox(height: AgoraSpacings.base),
            SkeletonBox(height: 12, width: 90),
            SizedBox(height: AgoraSpacings.x2),
            SkeletonBox(height: 12, width: 170),
            SizedBox(height: AgoraSpacings.base),
            SkeletonBox(height: 12, width: 150),
          ],
        ),
      ),
    );
  }
}
