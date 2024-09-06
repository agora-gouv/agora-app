import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_secondary_style_view_button.dart';
import 'package:agora/design/custom_view/error/agora_error_text.dart';
import 'package:agora/design/custom_view/skeletons.dart';
import 'package:agora/design/custom_view/text/agora_html.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/profil/participation_charter/bloc/participation_charter_bloc.dart';
import 'package:agora/profil/participation_charter/bloc/participation_charter_event.dart';
import 'package:agora/profil/participation_charter/bloc/participation_charter_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParticipationCharterPage extends StatelessWidget {
  static const routeName = "/participationCharterPage";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PartcipationCharterBloc(
        repository: RepositoryManager.getParticipationCharterRepository(),
      )..add(GetParticipationCharterEvent()),
      child: AgoraScaffold(
        child: AgoraSecondaryStyleView(
          semanticPageLabel: ProfileStrings.charter + ProfileStrings.participation,
          title: _Title(),
          child: Padding(
            padding: const EdgeInsets.only(
              left: AgoraSpacings.horizontalPadding,
              right: AgoraSpacings.horizontalPadding,
              bottom: AgoraSpacings.x2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<PartcipationCharterBloc, ParticipationCharterState>(
                  builder: (context, participationState) {
                    if (participationState is GetParticipationCharterLoadingState) {
                      return _Loading();
                    } else if (participationState is GetParticipationCharterLoadedState) {
                      return _Content(participationState.extraText);
                    } else {
                      return AgoraErrorText();
                    }
                  },
                ),
                _Buttons(),
              ],
            ),
          ),
        ),
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
          text: ProfileStrings.charter,
          style: AgoraRichTextItemStyle.regular,
        ),
        AgoraRichTextItem(
          text: ProfileStrings.participation,
          style: AgoraRichTextItemStyle.bold,
        ),
      ],
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: AgoraButton(
            label: GenericStrings.readCompleteCharter,
            buttonStyle: AgoraButtonStyle.secondary,
            onPressed: () {
              LaunchUrlHelper.webview(context, ProfileStrings.participateCharterLink);
            },
            suffixIcon: "ic_external_link.svg",
            suffixIconColorFilter: ColorFilter.mode(AgoraColors.primaryBlue, BlendMode.srcIn),
          ),
        ),
        SizedBox(width: AgoraSpacings.base),
        AgoraButton(
          label: GenericStrings.back,
          buttonStyle: AgoraButtonStyle.primary,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final String extraText;

  const _Content(this.extraText);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AgoraSpacings.base),
      child: AgoraHtml(
        data: extraText,
        fontSize: 14,
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: AgoraSpacings.base),
        SkeletonBox(width: 400.0, height: 60),
        SizedBox(height: AgoraSpacings.x2),
        SkeletonBox(width: 400.0, height: 150),
        SizedBox(height: AgoraSpacings.x3),
        SkeletonBox(width: 400.0, height: 150),
        SizedBox(height: AgoraSpacings.x3),
      ],
    );
  }
}
