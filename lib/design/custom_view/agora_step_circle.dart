import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';

class AgoraStepCircle extends StatelessWidget {
  final int currentStep;
  final int totalStep;

  const AgoraStepCircle({
    super.key,
    required this.currentStep,
    this.totalStep = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildStep(),
    );
  }

  List<Widget> _buildStep() {
    final List<Widget> widgets = [];
    for (int step = 1; step <= totalStep; step++) {
      if (step == currentStep) {
        widgets.add(_buildCircle(AgoraColors.primaryGreen));
      } else {
        widgets.add(_buildCircle(AgoraColors.gravelFint));
      }
      if (step != totalStep) {
        widgets.add(SizedBox(width: AgoraSpacings.x0_25));
      }
    }
    return widgets;
  }

  Widget _buildCircle(Color color) {
    return Container(
      width: 8.0,
      height: 8.0,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
