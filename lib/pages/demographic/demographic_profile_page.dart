import 'package:agora/bloc/demographic/get/demographic_information_bloc.dart';
import 'package:agora/bloc/demographic/get/demographic_information_event.dart';
import 'package:agora/bloc/demographic/get/demographic_information_state.dart';
import 'package:agora/bloc/demographic/get/demographic_information_view_model.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_green_separator.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_secondary_style_view.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/agora_title_rich_text.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/demographic/demographic_question_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DemographicProfileArguments {
  final bool modificationSuccess;

  DemographicProfileArguments({required this.modificationSuccess});
}

class DemographicProfilePage extends StatefulWidget {
  static const routeName = "/demographicProfilePage";

  @override
  State<DemographicProfilePage> createState() => _DemographicProfilePageState();
}

class _DemographicProfilePageState extends State<DemographicProfilePage> {
  bool isFirstTimeDisplayedPopUp = true;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleModification(context);
    });
    return MultiBlocProvider(
      providers: [
        BlocProvider<DemographicInformationBloc>(
          create: (BuildContext context) =>
              DemographicInformationBloc(demographicRepository: RepositoryManager.getDemographicRepository())
                ..add(GetDemographicInformationEvent()),
        ),
      ],
      child: AgoraScaffold(
        shouldPop: false,
        child: BlocBuilder<DemographicInformationBloc, DemographicInformationState>(
          builder: (context, state) {
            if (state is GetDemographicInformationSuccessState) {
              return AgoraSingleScrollView(
                child: AgoraSecondaryStyleView(
                  title: AgoraRichText(
                    policeStyle: AgoraRichTextPoliceStyle.toolbar,
                    items: [
                      AgoraRichTextTextItem(
                        text: DemographicStrings.yours,
                        style: AgoraRichTextItemStyle.regular,
                      ),
                      AgoraRichTextSpaceItem(),
                      AgoraRichTextTextItem(
                        text: DemographicStrings.information,
                        style: AgoraRichTextItemStyle.bold,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AgoraSpacings.horizontalPadding,
                      vertical: AgoraSpacings.base,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                            Row(
                              children: [
                                AgoraRichText(
                                  policeStyle: AgoraRichTextPoliceStyle.section,
                                  items: [
                                    AgoraRichTextTextItem(
                                      text: DemographicStrings.informationCapitalize,
                                      style: AgoraRichTextItemStyle.regular,
                                    ),
                                    AgoraRichTextTextItem(
                                      text: DemographicStrings.general,
                                      style: AgoraRichTextItemStyle.bold,
                                    ),
                                  ],
                                ),
                                Spacer(),
                                AgoraRoundedButton(
                                  label: GenericStrings.modify,
                                  style: AgoraRoundedButtonStyle.whiteButton,
                                  onPressed: () {
                                    Navigator.pushNamed(context, DemographicQuestionPage.routeName);
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: AgoraSpacings.base),
                          ] +
                          _buildDemographicInformation(state.demographicInformationViewModels) +
                          [
                            SizedBox(height: AgoraSpacings.base),
                            AgoraGreenSeparator(),
                            SizedBox(height: AgoraSpacings.base),
                            Text(DemographicStrings.demographicInformationNotice1, style: AgoraTextStyles.light14),
                            SizedBox(height: AgoraSpacings.x0_5),
                            Text(DemographicStrings.demographicInformationNotice2, style: AgoraTextStyles.light14),
                            SizedBox(height: AgoraSpacings.x1_25),
                            AgoraButton(
                              label: DemographicStrings.suppressMyInformation,
                              style: AgoraButtonStyle.whiteButtonWithRedBorderStyle,
                              onPressed: () {
                                // TODO
                              },
                            ),
                            SizedBox(height: AgoraSpacings.base),
                          ],
                    ),
                  ),
                ),
              );
            } else if (state is GetDemographicInformationInitialLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: AgoraErrorView());
            }
          },
        ),
      ),
    );
  }

  void _handleModification(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as DemographicProfileArguments?;
    if (isFirstTimeDisplayedPopUp && arguments != null) {
      isFirstTimeDisplayedPopUp = false;
      if (arguments.modificationSuccess) {
        showAgoraDialog(
          context: context,
          columnChildren: [
            Text(GenericStrings.modificationSuccess, style: AgoraTextStyles.medium16),
            SizedBox(height: AgoraSpacings.x0_75),
            AgoraButton(
              label: GenericStrings.close,
              style: AgoraButtonStyle.primaryButtonStyle,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      } else {
        showAgoraDialog(
          context: context,
          columnChildren: [
            Text(GenericStrings.errorMessage, style: AgoraTextStyles.medium16),
            SizedBox(height: AgoraSpacings.x0_75),
            AgoraButton(
              label: GenericStrings.close,
              style: AgoraButtonStyle.primaryButtonStyle,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      }
    }
  }

  List<Widget> _buildDemographicInformation(List<DemographicInformationViewModel> demographicInformationViewModels) {
    final List<Widget> widgets = [];
    for (final viewModel in demographicInformationViewModels) {
      widgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              viewModel.demographicType,
              style: AgoraTextStyles.regular16.copyWith(color: AgoraColors.primaryGreen),
            ),
            SizedBox(height: AgoraSpacings.x0_25),
            Text(viewModel.data, style: AgoraTextStyles.medium18),
          ],
        ),
      );
      widgets.add(SizedBox(height: AgoraSpacings.base));
    }
    return widgets;
  }
}
