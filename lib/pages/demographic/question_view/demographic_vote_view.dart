import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_demographic_simple_view.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/domain/demographic/demographic_question_type.dart';
import 'package:agora/pages/demographic/demographic_helper.dart';
import 'package:agora/pages/demographic/demographic_response_helper.dart';
import 'package:flutter/material.dart';

class DemographicVoteView extends StatefulWidget {
  final List<DemographicResponseChoice> responseChoices;
  final Function(
    String? voteFrequencyCode,
    String? publicMeetingFrequencyCode,
    String? consultationFrequencyCode,
  ) onContinuePressed;
  final VoidCallback onIgnorePressed;

  const DemographicVoteView({
    super.key,
    required this.responseChoices,
    required this.onContinuePressed,
    required this.onIgnorePressed,
  });

  @override
  State<DemographicVoteView> createState() => _DemographicVoteViewState();
}

class _DemographicVoteViewState extends State<DemographicVoteView> {
  String? voteFrequencyCode;
  String? publicMeetingFrequencyCode;
  String? consultationFrequencyCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            showAgoraDialog(
              context: context,
              columnChildren: [
                Text(DemographicStrings.whyAskContent, style: AgoraTextStyles.light16),
                SizedBox(height: AgoraSpacings.x0_75),
                AgoraButton(
                  label: GenericStrings.close,
                  style: AgoraButtonStyle.primaryButtonStyle,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
          child: Text(
            DemographicStrings.whyAsk,
            style: AgoraTextStyles.regular14Underline.copyWith(color: AgoraColors.primaryBlue),
          ),
        ),
        SizedBox(height: AgoraSpacings.base),
        Text(DemographicStrings.question6_1, style: AgoraTextStyles.medium18),
        SizedBox(height: AgoraSpacings.x0_75),
        _buildResponseRow(
          demographicType: DemographicType.voteFrequency,
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
          demographicType: DemographicType.publicMeetingFrequency,
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
          demographicType: DemographicType.consultationFrequency,
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
        voteFrequencyCode != null || publicMeetingFrequencyCode != null || consultationFrequencyCode != null
            ? AgoraButton(
                label: DemographicStrings.send,
                style: AgoraButtonStyle.primaryButtonStyle,
                onPressed: () {
                  setState(() {
                    widget.onContinuePressed(
                      voteFrequencyCode,
                      publicMeetingFrequencyCode,
                      consultationFrequencyCode,
                    );
                  });
                },
              )
            : DemographicHelper.buildIgnoreButton(onPressed: widget.onIgnorePressed),
      ],
    );
  }

  Widget _buildResponseRow({
    required DemographicType demographicType,
    required Function(String) onPressed,
  }) {
    final responseChoices = DemographicResponseHelper.question6ResponseChoice();
    final List<Widget> rowWidgets = [];
    for (final responseChoice in responseChoices) {
      rowWidgets.add(
        Expanded(
          child: AgoraDemographicResponseCard(
            responseLabel: responseChoice.responseLabel,
            textAlign: TextAlign.center,
            isSelected: isSelected(demographicType: demographicType, responseChoice: responseChoice),
            padding: const EdgeInsets.symmetric(vertical: AgoraSpacings.base, horizontal: 0),
            iconPlace: DemographicSelectedIconPlace.centerBottom,
            onTap: () => onPressed(responseChoice.responseCode),
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
    required DemographicType demographicType,
    required DemographicResponseChoice responseChoice,
  }) {
    switch (demographicType) {
      case DemographicType.voteFrequency:
        return responseChoice.responseCode == voteFrequencyCode;
      case DemographicType.publicMeetingFrequency:
        return responseChoice.responseCode == publicMeetingFrequencyCode;
      case DemographicType.consultationFrequency:
        return responseChoice.responseCode == consultationFrequencyCode;
      default:
        return false;
    }
  }
}
