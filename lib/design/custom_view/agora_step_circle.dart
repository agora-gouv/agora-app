import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';

enum AgoraStepCircleStyle { single, multiple }

class AgoraStepCircle extends StatelessWidget {
  final int currentStep;
  final int totalStep;
  final AgoraStepCircleStyle style;

  const AgoraStepCircle({
    super.key,
    required this.currentStep,
    this.totalStep = 3,
    this.style = AgoraStepCircleStyle.multiple,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: SemanticsStrings.stepV2.format2(currentStep.toString(), totalStep.toString()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildStep(),
      ),
    );
  }

  List<Widget> _buildStep() {
    final List<Widget> widgets = [];
    if (style == AgoraStepCircleStyle.single) {
      for (int step = 1; step <= totalStep; step++) {
        widgets.add(_buildCircle(step == currentStep));
        if (step != totalStep) {
          widgets.add(SizedBox(width: AgoraSpacings.x0_25));
        }
      }
    } else {
      for (int step = 1; step <= totalStep; step++) {
        widgets.add(_buildCircle(step <= currentStep));
        if (step != totalStep) {
          widgets.add(SizedBox(width: AgoraSpacings.x0_25));
        }
      }
    }
    return widgets;
  }

  Widget _buildCircle(bool isCurrent) {
    return Container(
      width: isCurrent ? 12 : 6,
      height: isCurrent ? 12 : 6,
      decoration: BoxDecoration(
        color: isCurrent ? AgoraColors.blue525 : AgoraColors.gravelFint,
        shape: BoxShape.circle,
      ),
    );
  }
}
