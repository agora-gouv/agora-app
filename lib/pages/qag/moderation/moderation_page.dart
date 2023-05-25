import 'package:agora/bloc/qag/moderation/list/qag_moderation_list_bloc.dart';
import 'package:agora/bloc/qag/moderation/list/qag_moderation_list_event.dart';
import 'package:agora/bloc/qag/moderation/list/qag_moderation_list_state.dart';
import 'package:agora/bloc/qag/moderation/list/qag_moderation_list_view_model.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_qag_moderation_card.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_secondary_style_view.dart';
import 'package:agora/design/custom_view/agora_title_rich_text.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModerationPage extends StatelessWidget {
  static const routeName = "/moderationPage";

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) {
            return QagModerationListBloc(qagRepository: RepositoryManager.getQagRepository())
              ..add(FetchQagModerationListEvent());
          },
        ),
      ],
      child: AgoraScaffold(
        child: SingleChildScrollView(
          child: AgoraSecondaryStyleView(
            title: AgoraRichText(
              policeStyle: AgoraRichTextPoliceStyle.toolbar,
              items: [
                AgoraRichTextTextItem(
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
                      children: _buildQagsToModerate(qagModerationListState.viewModel),
                    ),
                  );
                } else if (qagModerationListState is QagModerationListInitialState ||
                    qagModerationListState is QagModerationListLoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Center(child: AgoraErrorView());
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildQagsToModerate(QagModerationListViewModel viewModel) {
    final List<Widget> qagsWidgets = [
      Text(
        QagStrings.totalNumber.format(viewModel.totalNumber.toString()),
        style: AgoraTextStyles.regular16,
      ),
      SizedBox(height: AgoraSpacings.base),
    ];
    for (final qagsToModerationViewModel in viewModel.qagsToModerationViewModels) {
      qagsWidgets.add(
        AgoraQagModerationCard(
          id: qagsToModerationViewModel.id,
          thematique: qagsToModerationViewModel.thematique,
          title: qagsToModerationViewModel.title,
          description: qagsToModerationViewModel.description,
          username: qagsToModerationViewModel.username,
          date: qagsToModerationViewModel.date,
          supportCount: qagsToModerationViewModel.supportCount,
          isSupported: qagsToModerationViewModel.isSupported,
        ),
      );
      qagsWidgets.add(SizedBox(height: AgoraSpacings.base));
    }
    if (viewModel.qagsToModerationViewModels.isEmpty) {
      qagsWidgets.add(SizedBox(height: AgoraSpacings.base));
      qagsWidgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AgoraRoundedButton(
              label: QagStrings.displayMore,
              style: AgoraRoundedButtonStyle.primaryButton,
              onPressed: () {
                // TODO
              },
            ),
          ],
        ),
      );
      qagsWidgets.add(SizedBox(height: AgoraSpacings.base));
    }
    return qagsWidgets;
  }
}
