import 'package:agora/bloc/demographic/get/demographic_information_bloc.dart';
import 'package:agora/bloc/demographic/get/demographic_information_event.dart';
import 'package:agora/bloc/demographic/get/demographic_information_state.dart';
import 'package:agora/bloc/demographic/get/demographic_information_view_model.dart';
import 'package:agora/bloc/demographic/send/demographic_responses_send_bloc.dart';
import 'package:agora/bloc/demographic/send/demographic_responses_send_event.dart';
import 'package:agora/bloc/demographic/send/demographic_responses_send_state.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_little_separator.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_secondary_style_view.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/demographic/demographic_question_page.dart';
import 'package:flutter/gestures.dart';
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
          create: (BuildContext context) => DemographicInformationBloc(
            demographicRepository: RepositoryManager.getDemographicRepository(),
          )..add(GetDemographicInformationEvent()),
        ),
        BlocProvider(
          create: (BuildContext context) => SendDemographicResponsesBloc(
            demographicRepository: RepositoryManager.getDemographicRepository(),
            profileDemographicStorageClient: StorageManager.getProfileDemographicStorageClient(),
          ),
        ),
      ],
      child: AgoraScaffold(
        child: BlocBuilder<DemographicInformationBloc, DemographicInformationState>(
          builder: (context, state) {
            return AgoraSecondaryStyleView(
              title: AgoraRichText(
                policeStyle: AgoraRichTextPoliceStyle.toolbar,
                items: [
                  AgoraRichTextItem(
                    text: DemographicStrings.my,
                    style: AgoraRichTextItemStyle.regular,
                  ),
                  AgoraRichTextItem(
                    text: DemographicStrings.information,
                    style: AgoraRichTextItemStyle.bold,
                  ),
                ],
              ),
              child: _build(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _build(BuildContext context, DemographicInformationState state) {
    if (state is GetDemographicInformationSuccessState) {
      return _buildContent(context, state.demographicInformationViewModels);
    } else if (state is GetDemographicInformationInitialLoadingState) {
      return Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 3),
          Center(child: CircularProgressIndicator()),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 3),
          Center(child: AgoraErrorView()),
        ],
      );
    }
  }

  Widget _buildContent(BuildContext context, List<DemographicInformationViewModel> demographicInformationViewModels) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AgoraSpacings.horizontalPadding,
        vertical: AgoraSpacings.base,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AgoraRichText(
                  policeStyle: AgoraRichTextPoliceStyle.section,
                  items: [
                    AgoraRichTextItem(
                      text: DemographicStrings.informationCapitalize,
                      style: AgoraRichTextItemStyle.regular,
                    ),
                    AgoraRichTextItem(
                      text: DemographicStrings.demographic,
                      style: AgoraRichTextItemStyle.bold,
                    ),
                  ],
                ),
              ),
              SizedBox(width: AgoraSpacings.x0_5),
              AgoraRoundedButton(
                label: GenericStrings.modify,
                style: AgoraRoundedButtonStyle.greyBorderButtonStyle,
                onPressed: () {
                  Navigator.pushNamed(context, DemographicQuestionPage.routeName);
                },
              ),
            ],
          ),
          SizedBox(height: AgoraSpacings.base),
          ..._buildDemographicInformation(demographicInformationViewModels),
          SizedBox(height: AgoraSpacings.base),
          AgoraLittleSeparator(),
          SizedBox(height: AgoraSpacings.base),
          Text(DemographicStrings.demographicInformationNotice1, style: AgoraTextStyles.light14),
          SizedBox(height: AgoraSpacings.x0_5),
          RichText(
            textScaler: MediaQuery.of(context).textScaler,
            text: TextSpan(
              style: AgoraTextStyles.light14,
              children: [
                TextSpan(text: DemographicStrings.demographicInformationNotice2),
                WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                TextSpan(
                  text: DemographicStrings.demographicInformationNotice3,
                  style: AgoraTextStyles.light14Underline.copyWith(color: AgoraColors.primaryBlue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => LaunchUrlHelper.webview(context, ProfileStrings.privacyPolicyLink),
                ),
              ],
            ),
          ),
          SizedBox(height: AgoraSpacings.x1_25),
          BlocListener<SendDemographicResponsesBloc, SendDemographicResponsesState>(
            listener: (previousState, currentState) {
              if (currentState is SendDemographicResponsesSuccessState) {
                context.read<DemographicInformationBloc>().add(RemoveDemographicInformationEvent());
                _modificationSuccess(context);
              } else if (currentState is SendDemographicResponsesFailureState) {
                _modificationError(context);
              }
            },
            child: AgoraButton(
              label: DemographicStrings.suppressMyInformation,
              style: AgoraButtonStyle.redBorderButtonStyle,
              onPressed: () {
                showAgoraDialog(
                  context: context,
                  columnChildren: [
                    Text(ProfileStrings.suppressDemographicPopUp, style: AgoraTextStyles.medium16),
                    SizedBox(height: AgoraSpacings.x0_75),
                    Row(
                      children: [
                        AgoraButton(
                          label: GenericStrings.yes,
                          style: AgoraButtonStyle.primaryButtonStyle,
                          onPressed: () {
                            context
                                .read<SendDemographicResponsesBloc>()
                                .add(SendDemographicResponsesEvent(demographicResponses: []));
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: AgoraSpacings.x0_75),
                        AgoraButton(
                          label: GenericStrings.no,
                          style: AgoraButtonStyle.blueBorderButtonStyle,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: AgoraSpacings.base),
        ],
      ),
    );
  }

  void _handleModification(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as DemographicProfileArguments?;
    if (isFirstTimeDisplayedPopUp && arguments != null) {
      isFirstTimeDisplayedPopUp = false;
      if (arguments.modificationSuccess) {
        _modificationSuccess(context);
      } else {
        _modificationError(context);
      }
    }
  }

  void _modificationError(BuildContext context) {
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

  void _modificationSuccess(BuildContext context) {
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
              style: AgoraTextStyles.regular16.copyWith(color: AgoraColors.blue525),
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
