import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_demographic_simple_view.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/text/agora_link_text.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/profil/demographic/domain/demographic_question_type.dart';
import 'package:agora/profil/demographic/domain/demographic_response.dart';
import 'package:agora/profil/demographic/domain/demographic_response_choice.dart';
import 'package:agora/profil/demographic/pages/helpers/demographic_helper.dart';
import 'package:agora/profil/demographic/pages/helpers/demographic_response_helper.dart';
import 'package:flutter/material.dart';

class DemographicVoteView extends StatefulWidget {
  final int step;
  final int totalStep;
  final List<DemographicResponseChoice> responseChoices;
  final Function(
    String? voteFrequencyCode,
    String? publicMeetingFrequencyCode,
    String? consultationFrequencyCode,
  ) onContinuePressed;
  final VoidCallback onIgnorePressed;
  final VoidCallback onBackPressed;
  final List<DemographicResponse> oldResponses;

  const DemographicVoteView({
    super.key,
    required this.step,
    required this.totalStep,
    required this.responseChoices,
    required this.onContinuePressed,
    required this.onIgnorePressed,
    required this.onBackPressed,
    required this.oldResponses,
  });

  @override
  State<DemographicVoteView> createState() => _DemographicVoteViewState();
}

class _DemographicVoteViewState extends State<DemographicVoteView> {
  String? voteFrequencyCode;
  String? publicMeetingFrequencyCode;
  String? consultationFrequencyCode;

  @override
  void initState() {
    super.initState();
    voteFrequencyCode = widget.oldResponses
        .where((element) => element.demographicType == DemographicQuestionType.voteFrequency)
        .firstOrNull
        ?.response;
    publicMeetingFrequencyCode = widget.oldResponses
        .where((element) => element.demographicType == DemographicQuestionType.publicMeetingFrequency)
        .firstOrNull
        ?.response;
    consultationFrequencyCode = widget.oldResponses
        .where((element) => element.demographicType == DemographicQuestionType.consultationFrequency)
        .firstOrNull
        ?.response;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AgoraLinkText(
          label: DemographicStrings.whyAsk,
          textPadding: EdgeInsets.zero,
          onTap: () {
            showAgoraDialog(
              context: context,
              columnChildren: [
                Text(DemographicStrings.whyAskContent, style: AgoraTextStyles.light16),
                SizedBox(height: AgoraSpacings.x0_75),
                AgoraButton.withLabel(
                  label: GenericStrings.close,
                  buttonStyle: AgoraButtonStyle.primary,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        ),
        SizedBox(height: AgoraSpacings.x0_5),
        Text(DemographicStrings.question6_1, style: AgoraTextStyles.medium18),
        SizedBox(height: AgoraSpacings.x0_75),
        _buildResponseRow(
          demographicType: DemographicQuestionType.voteFrequency,
          onPressed: (responseCode) {
            setState(() {
              if (voteFrequencyCode == responseCode) {
                voteFrequencyCode = null;
              } else {
                voteFrequencyCode = responseCode;
              }
            });
          },
        ),
        SizedBox(height: AgoraSpacings.x0_75),
        Text(DemographicStrings.question6_2, style: AgoraTextStyles.medium18),
        SizedBox(height: AgoraSpacings.x0_25),
        Text(DemographicStrings.question6_2Description, style: AgoraTextStyles.light14),
        SizedBox(height: AgoraSpacings.x0_75),
        _buildResponseRow(
          demographicType: DemographicQuestionType.publicMeetingFrequency,
          onPressed: (responseCode) {
            setState(() {
              if (publicMeetingFrequencyCode == responseCode) {
                publicMeetingFrequencyCode = null;
              } else {
                publicMeetingFrequencyCode = responseCode;
              }
            });
          },
        ),
        SizedBox(height: AgoraSpacings.x0_75),
        Text(DemographicStrings.question6_3, style: AgoraTextStyles.medium18),
        SizedBox(height: AgoraSpacings.x0_25),
        Text(DemographicStrings.question6_3Description, style: AgoraTextStyles.light14),
        SizedBox(height: AgoraSpacings.x0_75),
        _buildResponseRow(
          demographicType: DemographicQuestionType.consultationFrequency,
          onPressed: (responseCode) {
            setState(() {
              if (consultationFrequencyCode == responseCode) {
                consultationFrequencyCode = null;
              } else {
                consultationFrequencyCode = responseCode;
              }
            });
          },
        ),
        SizedBox(height: AgoraSpacings.x0_75),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DemographicHelper.buildBackButton(step: widget.step, onBackTap: widget.onBackPressed),
            const SizedBox(width: AgoraSpacings.base),
            Flexible(
              child:
                  voteFrequencyCode != null || publicMeetingFrequencyCode != null || consultationFrequencyCode != null
                      ? DemographicHelper.buildNextButton(
                          step: widget.step,
                          totalStep: widget.totalStep,
                          onPressed: () => setState(
                            () => widget.onContinuePressed(
                              voteFrequencyCode,
                              publicMeetingFrequencyCode,
                              consultationFrequencyCode,
                            ),
                          ),
                        )
                      : DemographicHelper.buildIgnoreButton(onPressed: widget.onIgnorePressed),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResponseRow({
    required DemographicQuestionType demographicType,
    required Function(String) onPressed,
  }) {
    final responseChoices = DemographicResponseHelper.question6ResponseChoice();
    final List<Widget> rowWidgets = [];

    final totalLength = responseChoices.length;
    for (var index = 0; index < totalLength; index++) {
      final responseChoice = responseChoices[index];
      rowWidgets.add(
        Expanded(
          child: AgoraDemographicResponseCard(
            responseLabel: responseChoice.responseLabel,
            textAlign: TextAlign.center,
            isSelected: isSelected(demographicType: demographicType, responseChoice: responseChoice),
            padding: const EdgeInsets.symmetric(vertical: AgoraSpacings.base, horizontal: 0),
            iconPlace: DemographicSelectedIconPlace.centerBottom,
            onTap: () => onPressed(responseChoice.responseCode),
            semantic: DemographicResponseCardSemantic(
              currentIndex: index + 1,
              totalIndex: totalLength,
            ),
          ),
        ),
      );
      rowWidgets.add(SizedBox(width: AgoraSpacings.x0_75));
    }
    rowWidgets.removeLast();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rowWidgets,
    );
  }

  bool isSelected({
    required DemographicQuestionType demographicType,
    required DemographicResponseChoice responseChoice,
  }) {
    switch (demographicType) {
      case DemographicQuestionType.voteFrequency:
        return responseChoice.responseCode == voteFrequencyCode;
      case DemographicQuestionType.publicMeetingFrequency:
        return responseChoice.responseCode == publicMeetingFrequencyCode;
      case DemographicQuestionType.consultationFrequency:
        return responseChoice.responseCode == consultationFrequencyCode;
      default:
        return false;
    }
  }
}
