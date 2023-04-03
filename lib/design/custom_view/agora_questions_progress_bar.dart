import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_corners.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:flutter/material.dart';

class AgoraQuestionsProgressBar extends StatelessWidget {
  const AgoraQuestionsProgressBar({
    Key? key,
    required this.nbQuestionsRepondues,
    required this.nbQuestionsTotales,
  }) : super(key: key);

  final int nbQuestionsRepondues;
  final int nbQuestionsTotales;

  static const _barHeight = 10.0;

  @override
  Widget build(BuildContext context) {
    return Row(children: _buildProgressBar());
  }

  List<Widget> _buildProgressBar() {
    final List<Widget> widgets = List.empty(growable: true);
    for (int i = 0; i < nbQuestionsRepondues; i++) {
      widgets.add(_buildBox(AgoraColors.primaryGreen));
      widgets.add(SizedBox(width: AgoraSpacings.x0_5));
    }
    for (int i = nbQuestionsRepondues; i < nbQuestionsTotales; i++) {
      widgets.add(_buildBox(AgoraColors.grey));
      widgets.add(SizedBox(width: AgoraSpacings.x0_5));
    }
    widgets.removeLast();
    return widgets;
  }

  Expanded _buildBox(Color color) {
    return Expanded(
      child: Container(
        height: _barHeight,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(AgoraCorners.rounded2),
        ),
      ),
    );
  }
}
