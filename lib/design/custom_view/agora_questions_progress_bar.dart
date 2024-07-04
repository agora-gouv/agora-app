import 'package:agora/design/style/agora_colors.dart';
import 'package:flutter/material.dart';

class AgoraQuestionsProgressBar extends StatefulWidget {
  final int currentQuestionIndex;
  final int totalQuestions;
  final bool isLastQuestion;

  static const _barHeight = 10.0;

  const AgoraQuestionsProgressBar({
    super.key,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    this.isLastQuestion = false,
  });

  @override
  State<AgoraQuestionsProgressBar> createState() => _AgoraQuestionsProgressBarState();
}

class _AgoraQuestionsProgressBarState extends State<AgoraQuestionsProgressBar> {
  double previousCurrentQuestionIndex = 1;
  late double _size;

  @override
  void initState() {
    _size = widget.currentQuestionIndex / widget.totalQuestions;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AgoraQuestionsProgressBar oldWidget) {
    if (previousCurrentQuestionIndex != widget.currentQuestionIndex.toDouble()) {
      setState(() {
        previousCurrentQuestionIndex = widget.currentQuestionIndex.toDouble();
        _size = widget.isLastQuestion ? 1 : widget.currentQuestionIndex / widget.totalQuestions;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Progression du questionnaire ${(widget.currentQuestionIndex / widget.totalQuestions * 100).toInt()}%',
      child: Stack(
        children: [
          Container(
            height: AgoraQuestionsProgressBar._barHeight,
            width: MediaQuery.of(context).size.width - 48,
            decoration: const ShapeDecoration(
              color: AgoraColors.orochimaru,
              shape: StadiumBorder(),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: AgoraQuestionsProgressBar._barHeight,
            width: (MediaQuery.of(context).size.width - 48) * _size,
            decoration: const ShapeDecoration(
              color: AgoraColors.primaryBlue,
              shape: StadiumBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
