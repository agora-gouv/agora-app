import 'package:agora/bloc/participation_charter/participation_charter_bloc.dart';
import 'package:agora/bloc/participation_charter/participation_charter_event.dart';
import 'package:agora/bloc/participation_charter/participation_charter_state.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/participate_charter_strings.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_html.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_secondary_style_view.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/skeletons.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParticipationCharterPage extends StatelessWidget {
  static const routeName = "/participationCharterPage";

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => PartcipationCharterBloc(
            repository: RepositoryManager.getParticipationCharterRepository(),
          )..add(GetParticipationCharterEvent()),
        ),
      ],
      child: AgoraScaffold(
        child: AgoraSecondaryStyleView(
          title: AgoraRichText(
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
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: AgoraSpacings.horizontalPadding,
              right: AgoraSpacings.horizontalPadding,
              bottom: AgoraSpacings.x2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._paragraph1(context),
                Row(
                  children: [
                    Flexible(
                      child: AgoraButton(
                        label: GenericStrings.readCompleteCharter,
                        style: AgoraButtonStyle.blueBorderButtonStyle,
                        onPressed: () {
                          LaunchUrlHelper.webview(context, ProfileStrings.participateCharterLink);
                        },
                      ),
                    ),
                    SizedBox(width: AgoraSpacings.base),
                    AgoraButton(
                      label: GenericStrings.back,
                      style: AgoraButtonStyle.primaryButtonStyle,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _paragraph1(BuildContext context) {
    return [
      Text(PrivacyPolicyStrings.title1, style: AgoraTextStyles.medium18),
      SizedBox(height: AgoraSpacings.x0_75),
      Text(PrivacyPolicyStrings.description1_1, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description1_2, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description1_3, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_5),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_3_1),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_3_2),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_3_3),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildRichText(
        context,
        [
          TextSpan(text: PrivacyPolicyStrings.description1_3_4_1),
          WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
          TextSpan(text: PrivacyPolicyStrings.description1_3_4_2, style: AgoraTextStyles.light14Italic),
          WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
          TextSpan(text: PrivacyPolicyStrings.description1_3_4_3),
          WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
        ],
      ),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_3_5),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_3_6),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_3_7),
      SizedBox(height: AgoraSpacings.x0_5),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_3_8),
      SizedBox(height: AgoraSpacings.x0_5),
      BlocBuilder<PartcipationCharterBloc, ParticipationCharterState>(
        builder: (context, participationState) {
          if (participationState is GetParticipationCharterLoadingState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SkeletonBox(width: 400.0),
                SizedBox(height: AgoraSpacings.x0_5),
                SkeletonBox(width: 400.0),
              ],
            );
          } else if (participationState is GetParticipationCharterLoadedState) {
            return AgoraHtml(data: participationState.extraText);
          } else {
            return AgoraErrorView();
          }
        },
      ),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description1_4, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_4_1),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_4_2),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_4_3),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_4_4),
      SizedBox(height: AgoraSpacings.x0_25),
      _buildTextWithBulletPoint(PrivacyPolicyStrings.description1_4_5),
      SizedBox(height: AgoraSpacings.x0_5),
      Text(PrivacyPolicyStrings.description1_5, style: AgoraTextStyles.light14),
      SizedBox(height: AgoraSpacings.base),
    ];
  }

  Widget _buildTextWithBulletPoint(String text, {TextStyle style = AgoraTextStyles.light14}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("  \u2022", style: style),
        SizedBox(width: AgoraSpacings.x0_5),
        Expanded(child: Text(text, style: style)),
      ],
    );
  }

  Widget _buildRichText(
    BuildContext context,
    List<InlineSpan> spans, {
    TextStyle style = AgoraTextStyles.light14,
    bool withBulletPoint = true,
  }) {
    if (withBulletPoint) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("  \u2022", style: style),
          SizedBox(width: AgoraSpacings.x0_5),
          Expanded(
            child: RichText(
              textScaler: MediaQuery.of(context).textScaler,
              text: TextSpan(style: style, children: spans),
            ),
          ),
        ],
      );
    } else {
      return RichText(
        textScaler: MediaQuery.of(context).textScaler,
        text: TextSpan(style: style, children: spans),
      );
    }
  }
}
