import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:flutter/material.dart';

class AgoraConsultationResultBar extends StatefulWidget {
  final int ratio;
  final String response;
  final double? minusPadding;

  AgoraConsultationResultBar({
    Key? key,
    required this.ratio,
    required this.response,
    this.minusPadding,
  }) : super(key: key);

  @override
  State<AgoraConsultationResultBar> createState() => _AgoraConsultationResultBarState();
}

class _AgoraConsultationResultBarState extends State<AgoraConsultationResultBar> {
  final GlobalKey _barChildKey = GlobalKey();
  bool isHeightCalculated = false;
  double barHeight = AgoraSpacings.x2_5;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!isHeightCalculated) {
        setState(() {
          isHeightCalculated = true;
          barHeight = (_barChildKey.currentContext?.findRenderObject() as RenderBox).size.height;
        });
      }
    });
    double totalWidth = MediaQuery.of(context).size.width;
    if (widget.minusPadding != null) {
      totalWidth = totalWidth - widget.minusPadding!;
    }
    final participantsPercentage = widget.ratio / 100;
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        AgoraRoundedCard(
          cardColor: AgoraColors.white,
          borderColor: AgoraColors.border,
          padding: null,
          child: SizedBox(
            height: barHeight,
            width: totalWidth,
          ),
        ),
        AgoraRoundedCard(
          cardColor: AgoraColors.blueFranceOpacity10,
          padding: null,
          child: SizedBox(
            height: barHeight,
            width: totalWidth * participantsPercentage,
          ),
        ),
        Padding(
          key: _barChildKey,
          padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.base, vertical: AgoraSpacings.x0_5),
          child: Row(
            children: [
              Text(ConsultationStrings.percentage.format(widget.ratio.toString()), style: AgoraTextStyles.medium14),
              SizedBox(width: AgoraSpacings.x0_5),
              Expanded(child: Text(widget.response, style: AgoraTextStyles.light14)),
            ],
          ),
        ),
      ],
    );
  }
}
