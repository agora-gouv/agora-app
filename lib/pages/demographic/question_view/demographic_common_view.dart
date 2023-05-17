import 'package:agora/design/custom_view/agora_demographic_simple_view.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/domain/demographic/demographic_response.dart';
import 'package:agora/pages/demographic/demographic_helper.dart';
import 'package:agora/pages/demographic/demographic_response_helper.dart';
import 'package:flutter/material.dart';

class DemographicCommonView extends StatelessWidget {
  final List<DemographicResponseChoice> responseChoices;
  final Function(String responseCode) onContinuePressed;
  final VoidCallback onIgnorePressed;
  final DemographicResponse? oldResponse;

  const DemographicCommonView({
    super.key,
    required this.responseChoices,
    required this.onContinuePressed,
    required this.onIgnorePressed,
    required this.oldResponse,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _handleResponse(context),
    );
  }

  List<Widget> _handleResponse(BuildContext context) {
    final List<Widget> widgets = [];
    for (final responseChoice in responseChoices) {
      widgets.add(
        AgoraDemographicResponseCard(
          responseLabel: responseChoice.responseLabel,
          isSelected: oldResponse != null && responseChoice.responseCode == oldResponse!.response,
          onTap: () => onContinuePressed(responseChoice.responseCode),
        ),
      );
      widgets.add(SizedBox(height: AgoraSpacings.x0_25));
    }
    widgets.add(SizedBox(height: AgoraSpacings.x1_25));
    widgets.add(DemographicHelper.buildIgnoreButton(onPressed: onIgnorePressed));
    return widgets;
  }
}
