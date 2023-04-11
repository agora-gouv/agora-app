import 'package:agora/bloc/consultation/summary/consultation_summary_view_model.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_consultation_result_bar.dart';
import 'package:flutter/material.dart';

class AgoraConsultationResultView extends StatelessWidget {
  final String questionTitle;
  final List<ConsultationSummaryResponseViewModel> responses;

  AgoraConsultationResultView({
    Key? key,
    required this.questionTitle,
    required this.responses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AgoraSpacings.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
              Text(questionTitle, style: AgoraTextStyles.medium17),
              SizedBox(height: AgoraSpacings.x1_5),
            ] +
            _buildResponses(),
      ),
    );
  }

  List<Widget> _buildResponses() {
    final List<Widget> responseWidgets = [];
    for (var response in responses) {
      responseWidgets.add(
        AgoraConsultationResultBar(
          ratio: response.ratio,
          response: response.label,
          minusPadding: AgoraSpacings.horizontalPadding * 2,
        ),
      );
      responseWidgets.add(SizedBox(height: AgoraSpacings.x0_75));
    }
    return responseWidgets;
  }
}
