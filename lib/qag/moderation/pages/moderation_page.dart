import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_secondary_style_view_button.dart';
import 'package:agora/design/custom_view/card/agora_qag_moderation_card.dart';
import 'package:agora/design/custom_view/error/agora_error_text.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/qag/moderation/bloc/list/qag_moderation_list_bloc.dart';
import 'package:agora/qag/moderation/bloc/list/qag_moderation_list_event.dart';
import 'package:agora/qag/moderation/bloc/list/qag_moderation_list_state.dart';
import 'package:agora/qag/moderation/bloc/list/qag_moderation_list_view_model.dart';
import 'package:agora/qag/moderation/bloc/moderate/qag_moderate_bloc.dart';
import 'package:agora/qag/moderation/bloc/moderate/qag_moderate_event.dart';
import 'package:agora/qag/moderation/bloc/moderate/qag_moderate_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModerationPage extends StatefulWidget {
  static const routeName = "/moderationPage";

  @override
  State<ModerationPage> createState() => _ModerationPageState();
}

class _ModerationPageState extends State<ModerationPage> {
  var shouldReloadQagsPage = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => QagModerationListBloc(
            qagRepository: RepositoryManager.getQagRepository(),
          )..add(FetchQagModerationListEvent()),
        ),
        BlocProvider(
          create: (BuildContext context) => QagModerateBloc(qagRepository: RepositoryManager.getQagRepository()),
        ),
      ],
      child: AgoraScaffold(
        popAction: () {
          _onBackClick(context);
          return false;
        },
        child: AgoraSecondaryStyleView(
          pageLabel: ProfileStrings.moderationCapitalize,
          onBackClick: () => _onBackClick(context),
          title: AgoraRichText(
            policeStyle: AgoraRichTextPoliceStyle.toolbar,
            items: [
              AgoraRichTextItem(
                text: ProfileStrings.moderationCapitalize,
                style: AgoraRichTextItemStyle.bold,
              ),
            ],
          ),
          child: BlocBuilder<QagModerationListBloc, QagModerationListState>(
            builder: (context, qagModerationListState) {
              if (qagModerationListState is QagModerationListSuccessState) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildQagsToModerate(context, qagModerationListState.viewModel),
                  ),
                );
              } else if (qagModerationListState is QagModerationListInitialState ||
                  qagModerationListState is QagModerationListLoadingState) {
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
                    Center(child: AgoraErrorText()),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _onBackClick(BuildContext context) {
    Navigator.pop(context, shouldReloadQagsPage);
  }

  List<Widget> _buildQagsToModerate(BuildContext context, QagModerationListViewModel viewModel) {
    final List<Widget> qagsWidgets = [
      Text(
        QagStrings.totalNumber.format(viewModel.totalNumber.toString()),
        style: AgoraTextStyles.regular16,
      ),
      SizedBox(height: AgoraSpacings.base),
    ];
    for (final qagToModerationViewModel in viewModel.qagsToModerationViewModels) {
      qagsWidgets.add(
        BlocConsumer<QagModerateBloc, QagModerateState>(
          listenWhen: (previousState, currentState) {
            return currentState is QagModerateSuccessState && currentState.qagId == qagToModerationViewModel.id;
          },
          listener: (context, currentState) {
            if (!shouldReloadQagsPage) {
              setState(() => shouldReloadQagsPage = true);
            }
            context
                .read<QagModerationListBloc>()
                .add(RemoveFromQagModerationListEvent(qagId: qagToModerationViewModel.id));
          },
          buildWhen: (previousState, currentState) {
            return currentState is QagModerateInitialState ||
                (currentState is QagModerateLoadingState && currentState.qagId == qagToModerationViewModel.id) ||
                (currentState is QagModerateSuccessState && currentState.qagId == qagToModerationViewModel.id) ||
                (currentState is QagModerateErrorState && currentState.qagId == qagToModerationViewModel.id);
          },
          builder: (context, qagModerateState) {
            return AgoraQagModerationCard(
              id: qagToModerationViewModel.id,
              thematique: qagToModerationViewModel.thematique,
              title: qagToModerationViewModel.title,
              description: qagToModerationViewModel.description,
              username: qagToModerationViewModel.username,
              date: qagToModerationViewModel.date,
              supportCount: qagToModerationViewModel.supportCount,
              isSupported: qagToModerationViewModel.isSupported,
              validateLoading: qagModerateState is QagModerateLoadingState && qagModerateState.isAccept,
              refuseLoading: qagModerateState is QagModerateLoadingState && !qagModerateState.isAccept,
              error: qagModerateState is QagModerateErrorState,
              onValidate: () => context
                  .read<QagModerateBloc>()
                  .add(QagModerateEvent(qagId: qagToModerationViewModel.id, isAccept: true)),
              onRefuse: () => context
                  .read<QagModerateBloc>()
                  .add(QagModerateEvent(qagId: qagToModerationViewModel.id, isAccept: false)),
            );
          },
        ),
      );
      qagsWidgets.add(SizedBox(height: AgoraSpacings.base));
    }
    if (viewModel.qagsToModerationViewModels.isEmpty) {
      qagsWidgets.add(SizedBox(height: AgoraSpacings.base));
      qagsWidgets.add(
        AgoraButton(
          label: GenericStrings.displayMore,
          isRounded: true,
          onTap: () => context.read<QagModerationListBloc>().add(FetchQagModerationListEvent()),
        ),
      );
      qagsWidgets.add(SizedBox(height: AgoraSpacings.base));
    }
    return qagsWidgets;
  }
}
