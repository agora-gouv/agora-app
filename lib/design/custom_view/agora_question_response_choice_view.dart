import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/custom_view/agora_text_field.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraQuestionResponseChoiceView extends StatefulWidget {
  final String responseId;
  final String responseLabel;
  final bool hasOpenTextField;
  final bool isSelected;
  final String previousOtherResponse;
  final Function(String responseId) onTap;
  final Function(String responseId, String otherResponse) onOtherResponseChanged;

  const AgoraQuestionResponseChoiceView({
    Key? key,
    required this.responseId,
    required this.responseLabel,
    required this.hasOpenTextField,
    required this.isSelected,
    required this.previousOtherResponse,
    required this.onTap,
    required this.onOtherResponseChanged,
  }) : super(key: key);

  @override
  State<AgoraQuestionResponseChoiceView> createState() => _AgoraQuestionResponseChoiceViewState();
}

class _AgoraQuestionResponseChoiceViewState extends State<AgoraQuestionResponseChoiceView> {
  String otherResponse = "";
  TextEditingController? textEditingController;
  bool shouldResetPreviousOtherResponse = true;

  @override
  Widget build(BuildContext context) {
    _resetPreviousResponse();
    return AgoraRoundedCard(
      borderColor: widget.isSelected ? AgoraColors.primaryBlue : AgoraColors.border,
      borderWidth: widget.isSelected ? 2.0 : 1.0,
      cardColor: AgoraColors.white,
      onTap: () => widget.onTap(widget.responseId),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.responseLabel, style: AgoraTextStyles.light14),
                  if (widget.hasOpenTextField && widget.isSelected) ...[
                    SizedBox(height: AgoraSpacings.x0_75),
                    AgoraTextField(
                      hintText: ConsultationStrings.otherChoiceHint,
                      controller: textEditingController,
                      showCounterText: true,
                      maxLength: 200,
                      onChanged: (otherResponseText) {
                        otherResponse = otherResponseText;
                        widget.onOtherResponseChanged(widget.responseId, otherResponse);
                      },
                    ),
                  ],
                ],
              ),
            ),
            if (widget.isSelected) ...[
              SizedBox(width: AgoraSpacings.x0_75),
              SvgPicture.asset("assets/ic_check.svg"),
            ],
          ],
        ),
      ),
    );
  }

  void _resetPreviousResponse() {
    if (widget.hasOpenTextField) {
      if (widget.isSelected) {
        if (shouldResetPreviousOtherResponse) {
          otherResponse = widget.previousOtherResponse;
          textEditingController = TextEditingController(text: otherResponse);
          shouldResetPreviousOtherResponse = false;
        }
      } else {
        shouldResetPreviousOtherResponse = true;
      }
    }
  }
}
