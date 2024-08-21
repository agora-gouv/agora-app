import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/card/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraConsultationResultBar extends StatefulWidget {
  final int participantsPercentage;
  final String response;
  final double? minusPadding;
  final bool isUserResponse;

  AgoraConsultationResultBar({
    required this.participantsPercentage,
    required this.response,
    this.minusPadding,
    required this.isUserResponse,
  });

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
    final participantsRatio = widget.participantsPercentage / 100;
    return MergeSemantics(
      child: Semantics(
        label: getSemanticLabel(widget.response, widget.isUserResponse, widget.participantsPercentage),
        child: ExcludeSemantics(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  AgoraRoundedCard(
                    cardColor: AgoraColors.white,
                    borderColor: widget.isUserResponse ? AgoraColors.primaryBlue : AgoraColors.border,
                    borderWidth: widget.isUserResponse ? 2 : 1,
                    padding: EdgeInsets.zero,
                    child: SizedBox(
                      height: barHeight,
                      width: totalWidth,
                    ),
                  ),
                  AgoraRoundedCard(
                    cardColor: AgoraColors.primaryBlueOpacity10,
                    padding: EdgeInsets.zero,
                    child: SizedBox(
                      height: barHeight,
                      width: totalWidth * participantsRatio,
                    ),
                  ),
                  Padding(
                    key: _barChildKey,
                    padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.base, vertical: AgoraSpacings.x0_5),
                    child: Row(
                      children: [
                        Text(
                          ConsultationStrings.percentage.format(widget.participantsPercentage.toString()),
                          style: AgoraTextStyles.medium14,
                        ),
                        SizedBox(width: AgoraSpacings.x0_5),
                        Expanded(child: Text(widget.response, style: AgoraTextStyles.light14)),
                      ],
                    ),
                  ),
                ],
              ),
              if (widget.isUserResponse)
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: AgoraSpacings.base),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AgoraColors.primaryBlue,
                        borderRadius: BorderRadius.vertical(bottom: AgoraCorners.rounded),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: AgoraSpacings.x0_5,
                          right: AgoraSpacings.x0_5,
                          bottom: AgoraSpacings.x0_375,
                        ),
                        child: Text(
                          'Votre réponse',
                          style: AgoraTextStyles.userResponseBox,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

String getSemanticLabel(String response, bool isUserResponse, int participantsPercentage) {
  if (isUserResponse) {
    return "Vous avez répondu $response comme $participantsPercentage pourcents des répondants";
  }
  return "$participantsPercentage pourcents des répondants ont répondu $response";
}
