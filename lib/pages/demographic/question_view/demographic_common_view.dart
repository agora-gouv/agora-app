import 'package:agora/common/extension/string_extension.dart';
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
import 'package:agora/domain/demographic/demographic_response.dart';
import 'package:agora/pages/demographic/demographic_helper.dart';
import 'package:agora/pages/demographic/demographic_response_helper.dart';
import 'package:flutter/material.dart';

class DemographicCommonView extends StatefulWidget {
  final int step;
  final int totalStep;
  final List<DemographicResponseChoice> responseChoices;
  final Function(String responseCode) onContinuePressed;
  final VoidCallback onIgnorePressed;
  final VoidCallback onBackPressed;
  final DemographicResponse? oldResponse;
  final bool showWhatAbout;
  final String? whatAboutText;

  const DemographicCommonView({
    super.key,
    required this.step,
    required this.totalStep,
    required this.responseChoices,
    required this.onContinuePressed,
    required this.onIgnorePressed,
    required this.onBackPressed,
    required this.oldResponse,
    this.showWhatAbout = false,
    this.whatAboutText,
  }) : assert(showWhatAbout == false || (showWhatAbout == true && whatAboutText != null));

  @override
  State<DemographicCommonView> createState() => _DemographicCommonViewState();
}

class _DemographicCommonViewState extends State<DemographicCommonView> {
  DemographicType? currentDemographicType;
  String currentResponse = "";
  bool shouldResetPreviousResponses = true;

  @override
  Widget build(BuildContext context) {
    _resetPreviousResponses();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _handleResponse(context),
    );
  }

  List<Widget> _handleResponse(BuildContext context) {
    final List<Widget> widgets = [];
    if (widget.showWhatAbout) {
      widgets.addAll([
        InkWell(
          onTap: () {
            showAgoraDialog(
              context: context,
              columnChildren: [
                Text(widget.whatAboutText!, style: AgoraTextStyles.light16),
                SizedBox(height: AgoraSpacings.x0_75),
                AgoraButton(
                  label: GenericStrings.close,
                  style: AgoraButtonStyle.primaryButtonStyle,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
          child: Semantics(
            button: true,
            child: Text(
              DemographicStrings.whatAbout,
              style: AgoraTextStyles.regular14Underline.copyWith(color: AgoraColors.primaryBlue),
            ),
          ),
        ),
        SizedBox(height: AgoraSpacings.base),
      ]);
    }
    final totalLength = widget.responseChoices.length;
    for (var index = 0; index < totalLength; index++) {
      final responseChoice = widget.responseChoices[index];
      widgets.add(
        AgoraDemographicResponseCard(
          responseLabel: responseChoice.responseLabel,
          isSelected: responseChoice.responseCode == currentResponse,
          onTap: () {
            if (responseChoice.responseCode == currentResponse) {
              setState(() => currentResponse = "");
            } else {
              widget.onContinuePressed(responseChoice.responseCode);
            }
          },
          semantic: DemographicResponseCardSemantic(
            currentIndex: index + 1,
            totalIndex: totalLength,
          ),
        ),
      );
      widgets.add(SizedBox(height: AgoraSpacings.x0_25));
    }
    widgets.addAll([
      SizedBox(height: AgoraSpacings.x1_25),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          DemographicHelper.buildBackButton(step: widget.step, onBackTap: widget.onBackPressed),
          const SizedBox(width: AgoraSpacings.base),
          Flexible(
            child: currentResponse.isNotBlank()
                ? DemographicHelper.buildNextButton(
                    step: widget.step,
                    totalStep: widget.totalStep,
                    onPressed: () => widget.onContinuePressed(widget.oldResponse!.response),
                  )
                : DemographicHelper.buildIgnoreButton(onPressed: widget.onIgnorePressed),
          ),
        ],
      ),
    ]);
    return widgets;
  }

  void _resetPreviousResponses() {
    if (widget.oldResponse != null && currentDemographicType != widget.oldResponse!.demographicType) {
      currentDemographicType = widget.oldResponse!.demographicType;
      shouldResetPreviousResponses = true;
    }
    if (shouldResetPreviousResponses) {
      currentResponse = "";
      final previousSelectedResponses = widget.oldResponse;
      if (previousSelectedResponses != null) {
        currentResponse = previousSelectedResponses.response;
        shouldResetPreviousResponses = false;
      }
    }
  }
}
