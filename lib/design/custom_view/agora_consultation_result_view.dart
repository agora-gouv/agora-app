import 'package:agora/bloc/consultation/summary/consultation_summary_view_model.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_consultation_result_bar.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraConsultationResultView extends StatelessWidget {
  final String questionTitle;
  final List<ConsultationSummaryResponseViewModel> responses;
  final bool isMultipleChoice;
  final bool isOpenQuestion;

  AgoraConsultationResultView({
    super.key,
    required this.questionTitle,
    required this.responses,
    this.isMultipleChoice = false,
    this.isOpenQuestion = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AgoraSpacings.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(questionTitle, style: AgoraTextStyles.medium17),
          ),
          if (isOpenQuestion) ...[
            SizedBox(height: AgoraSpacings.x0_75),
            Text(ConsultationStrings.openQuestionInformation, style: AgoraTextStyles.light14Italic),
          ],
          SizedBox(height: AgoraSpacings.x1_5),
          ..._buildResponses(),
        ],
      ),
    );
  }

  List<Widget> _buildResponses() {
    final List<Widget> responseWidgets = [];
    if (isMultipleChoice) {
      responseWidgets.add(Text(ConsultationStrings.severalResponsePossible, style: AgoraTextStyles.medium14));
      responseWidgets.add(SizedBox(height: AgoraSpacings.x0_75));
    }
    for (var response in responses) {
      responseWidgets.add(
        MergeSemantics(
          child: Semantics(
            label: 'Choix ${responses.indexOf(response) + 1} sur ${responses.length}',
            child: AgoraConsultationResultBar(
              ratio: response.ratio,
              response: response.label,
              isUserResponse: response.isUserResponse,
              minusPadding: AgoraSpacings.horizontalPadding * 2,
            ),
          ),
        ),
      );
      responseWidgets.add(SizedBox(height: AgoraSpacings.x0_75));
    }
    return responseWidgets;
  }
}
