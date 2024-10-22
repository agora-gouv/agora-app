import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/design/custom_view/agora_bottom_sheet.dart';
import 'package:agora/design/custom_view/agora_demographic_simple_view.dart';
import 'package:agora/design/custom_view/agora_more_information.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_secondary_style_view_button.dart';
import 'package:agora/design/custom_view/error/agora_error_text.dart';
import 'package:agora/design/custom_view/shake_widget.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/custom_view/text/agora_text_field.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/profil/territoire/bloc/territoire_info_bloc.dart';
import 'package:agora/profil/territoire/bloc/territoire_info_event.dart';
import 'package:agora/profil/territoire/bloc/territoire_info_state.dart';
import 'package:agora/profil/territoire/pages/territoire_info_page.dart';
import 'package:agora/referentiel/bloc/referentiel_bloc.dart';
import 'package:agora/referentiel/bloc/referentiel_event.dart';
import 'package:agora/referentiel/bloc/referentiel_state.dart';
import 'package:agora/referentiel/departement.dart';
import 'package:agora/referentiel/territoire.dart';
import 'package:agora/referentiel/territoire_helper.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TerritoireEditingPageArguments {
  final List<Territoire> departementsSuivis;

  TerritoireEditingPageArguments({required this.departementsSuivis});
}

class TerritoireEditingPage extends StatefulWidget {
  static const routeName = "/territoireEditingPage";

  @override
  State<TerritoireEditingPage> createState() => _TerritoireEditingPageState();
}

class _TerritoireEditingPageState extends State<TerritoireEditingPage> {
  List<Departement> findDepartements = [];
  List<Departement> selectedDepartements = [];
  bool hasError = false;
  final _shakeKey = GlobalKey<ShakeWidgetState>();
  final firstElementKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as TerritoireEditingPageArguments;
      setState(() {
        selectedDepartements = args.departementsSuivis.map((territoire) => territoire as Departement).toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      child: AgoraSecondaryStyleView(
        semanticPageLabel: "Mes territoires",
        title: _Title(firstElementKey),
        button: _InfoBouton(),
        child: ShakeWidget(
          shakeCount: 4,
          key: _shakeKey,
          child: Padding(
            padding: const EdgeInsets.all(AgoraSpacings.base),
            child: Column(
              children: [
                Text(
                  "Choisissez un ou deux départements que vous souhaitez suivre sur Agora.",
                  style: AgoraTextStyles.light16,
                ),
                SizedBox(height: AgoraSpacings.base),
                if (!hasError && selectedDepartements.length == 2) ...[
                  Text(
                    "Vous avez choisi le maximum de départements.",
                    style: AgoraTextStyles.light14.copyWith(color: Colors.green),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: AgoraSpacings.x0_5),
                ],
                if (hasError) ...[
                  AgoraErrorText(
                    errorMessage: "Maximum atteint. Désélectionnez un département pour en choisir un autre.",
                  ),
                  SizedBox(height: AgoraSpacings.x0_5),
                ],
                BlocProvider(
                  create: (context) => ReferentielBloc(
                    referentielRepository: RepositoryManager.getReferentielRepository(),
                  )..add(FetchReferentielEvent()),
                  child: BlocBuilder<ReferentielBloc, ReferentielState>(
                    builder: (context, state) {
                      if (state.status == AllPurposeStatus.loading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state.status == AllPurposeStatus.error) {
                        return Center(child: AgoraErrorText(errorMessage: "Erreur lors du chargement des territoires"));
                      } else {
                        return AgoraTextField(
                          hintText: DemographicStrings.departmentHint,
                          rightIcon: TextFieldIcon.search,
                          onChanged: (String input) {
                            setState(() {
                              if (input.isNotBlank()) {
                                findDepartements = getDepartementFromReferentiel(state.referentiel)
                                    .where(
                                      (department) => department.displayLabel
                                          .toLowerCase()
                                          .removeDiacritics()
                                          .removePunctuationMark()
                                          .contains(input.toLowerCase().removeDiacritics().removePunctuationMark()),
                                    )
                                    .toList();
                              } else {
                                findDepartements = [];
                              }
                            });
                          },
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: AgoraSpacings.base),
                _Resultats(
                  findDepartements: findDepartements,
                  selectedDepartements: selectedDepartements,
                  onDepartementSelected: (departement) => setState(() {
                    if (selectedDepartements.contains(departement)) {
                      selectedDepartements.remove(departement);
                      hasError = false;
                    } else {
                      if (selectedDepartements.length == 2) {
                        _shakeKey.currentState?.shake();
                        Scrollable.ensureVisible(
                          firstElementKey.currentContext!,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
                        );
                        hasError = true;
                      } else {
                        hasError = false;
                        selectedDepartements.add(departement);
                      }
                    }
                    findDepartements = [];
                  }),
                  onDepartementUnselected: (departement) => setState(() {
                    selectedDepartements.remove(departement);
                    hasError = false;
                  }),
                ),
                SizedBox(height: AgoraSpacings.base),
                BlocProvider(
                  create: (context) => TerritoireInfoBloc(
                    referentielRepository: RepositoryManager.getReferentielRepository(),
                    demographicRepository: RepositoryManager.getDemographicRepository(),
                  ),
                  child: BlocBuilder<TerritoireInfoBloc, TerritoireInfoState>(
                    builder: (context, _) => Align(
                      alignment: Alignment.centerRight,
                      child: AgoraButton.withLabel(
                        label: "Valider",
                        buttonStyle: AgoraButtonStyle.primary,
                        size: AgoraButtonSize.medium,
                        onPressed: () {
                          context.read<TerritoireInfoBloc>().add(
                                SendTerritoireInfoEvent(
                                  departementsSuivis: selectedDepartements,
                                  regionsSuivies: [],
                                ),
                              );
                          Navigator.pushReplacementNamed(context, TerritoireInfoPage.routeName);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Resultats extends StatelessWidget {
  final List<Departement> findDepartements;
  final List<Departement> selectedDepartements;
  final Function(Departement) onDepartementSelected;
  final Function(Departement) onDepartementUnselected;

  const _Resultats({
    required this.findDepartements,
    required this.selectedDepartements,
    required this.onDepartementSelected,
    required this.onDepartementUnselected,
  });

  @override
  Widget build(BuildContext context) {
    final totalLength = findDepartements.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...findDepartements.mapIndexed(
          (index, departement) => AgoraDemographicResponseCard(
            responseLabel: departement.displayLabel,
            isSelected: selectedDepartements.contains(departement),
            onTap: () => onDepartementSelected(departement),
            semantic: DemographicResponseCardSemantic(
              currentIndex: index + 1,
              totalIndex: totalLength,
            ),
          ),
        ),
        ...selectedDepartements.map(
          (selectedDepartements) {
            if (!findDepartements.contains((selectedDepartements))) {
              return AgoraDemographicResponseCard(
                responseLabel: selectedDepartements.displayLabel,
                isSelected: true,
                onTap: () => onDepartementUnselected(selectedDepartements),
                semantic: DemographicResponseCardSemantic(
                  currentIndex: 1,
                  totalIndex: totalLength,
                ),
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final GlobalKey firstElementKey;

  const _Title(this.firstElementKey);

  @override
  Widget build(BuildContext context) {
    return AgoraRichText(
      key: firstElementKey,
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

class _InfoBouton extends StatelessWidget {
  const _InfoBouton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AgoraSpacings.x0_5),
      child: AgoraMoreInformation(
        semanticsLabel: "En savoir plus sur le fonctionnement des territoires",
        onClick: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: AgoraColors.transparent,
            builder: (context) => AgoraInformationBottomSheet(
              titre: "Précisions",
              description: Text(
                "Votre réponse n'a aucun impact sur le département d'habitation que vous avez peut-être renseigné dans la section \"Mes informations\". En choisissant de suivre un département, vous suivrez également la région de ce département.",
                style: AgoraTextStyles.light16,
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
