import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
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
import 'package:agora/profil/demographic/bloc/get/demographic_information_state.dart';
import 'package:agora/profil/demographic/bloc/get/demographic_information_view_model.dart';
import 'package:agora/profil/demographic/bloc/send/demographic_responses_send_bloc.dart';
import 'package:agora/profil/demographic/bloc/send/demographic_responses_send_event.dart';
import 'package:agora/profil/demographic/bloc/send/demographic_responses_send_state.dart';
import 'package:agora/profil/demographic/domain/demographic_information.dart';
import 'package:agora/profil/demographic/pages/demographic_question_page.dart';
import 'package:agora/profil/demographic/repository/demographic_information_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DemographicProfileArguments {
  final bool modificationSuccess;

  DemographicProfileArguments({required this.modificationSuccess});
}

class DemographicProfilPage extends StatefulWidget {
  static const routeName = "/demographicProfilPage";

  @override
  State<DemographicProfilPage> createState() => _DemographicProfilPageState();
}

class _DemographicProfilPageState extends State<DemographicProfilPage> {
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
              semanticPageLabel: DemographicStrings.my + DemographicStrings.information,
              title: _Title(),
              button: state is GetDemographicInformationSuccessState
                  ? AgoraSecondaryStyleViewButton(
                      icon: null,
                      title: GenericStrings.modify,
                      accessibilityLabel: "Modifier mes informations",
                      onClick: () {
                        Navigator.pushNamed(
                          context,
                          DemographicQuestionPage.routeName,
                          arguments: DemographicQuestionArgumentsFromModify(state.demographicInformationResponse),
                        );
                      },
                    )
                  : null,
              child: _build(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _build(BuildContext context, DemographicInformationState state) {
    if (state is GetDemographicInformationSuccessState) {
      final viewModels = DemographicInformationPresenter.present(state.demographicInformationResponse);
      return _buildContent(context, viewModels, state.demographicInformationResponse);
    } else if (state is GetDemographicInformationInitialLoadingState) {
      return _LoadingView();
    } else {
      return _ErrorView();
    }
  }

  Widget _buildContent(
    BuildContext context,
    List<DemographicInformationViewModel> demographicInformationViewModels,
    List<DemographicInformation> demographicInformationResponse,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AgoraSpacings.horizontalPadding,
        vertical: AgoraSpacings.base,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._buildDemographicInformation(demographicInformationViewModels),
          SizedBox(height: AgoraSpacings.base),
          AgoraLittleSeparator(),
          SizedBox(height: AgoraSpacings.base),
          Text(DemographicStrings.demographicInformationNotice1, style: AgoraTextStyles.light14),
          SizedBox(height: AgoraSpacings.x0_5),
          Text(DemographicStrings.demographicInformationNotice2, style: AgoraTextStyles.light14),
          SizedBox(height: AgoraSpacings.x0_5),
          AgoraLinkText(
            label: DemographicStrings.demographicInformationNotice3,
            textPadding: EdgeInsets.zero,
            onTap: () => LaunchUrlHelper.webview(context, ProfileStrings.privacyPolicyLink),
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
              buttonStyle: AgoraButtonStyle.redBorder,
              onPressed: () {
                showAgoraDialog(
                  context: context,
                  columnChildren: [
                    Text(ProfileStrings.suppressDemographicPopUp, style: AgoraTextStyles.medium16),
                    SizedBox(height: AgoraSpacings.x1_5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: AgoraButton(
                            label: GenericStrings.yes,
                            buttonStyle: AgoraButtonStyle.primary,
                            onPressed: () {
                              context
                                  .read<SendDemographicResponsesBloc>()
                                  .add(SendDemographicResponsesEvent(demographicResponses: []));
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        SizedBox(width: AgoraSpacings.x1_5),
                        Expanded(
                          child: AgoraButton(
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
          buttonStyle: AgoraButtonStyle.primary,
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
          buttonStyle: AgoraButtonStyle.primary,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  List<Widget> _buildDemographicInformation(List<DemographicInformationViewModel> demographicInformationViewModels) {
    final List<Widget> widgets = [];
    for (final viewModel in demographicInformationViewModels) {
      widgets.add(
        MergeSemantics(
          child: Column(
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
        ),
      );
      widgets.add(SizedBox(height: AgoraSpacings.base));
    }
    return widgets;
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
          text: '${DemographicStrings.my}\n',
          style: AgoraRichTextItemStyle.regular,
        ),
        AgoraRichTextItem(
          text: DemographicStrings.information,
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
            SizedBox(height: AgoraSpacings.x2),
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
