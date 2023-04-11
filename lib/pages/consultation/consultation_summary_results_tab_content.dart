import 'package:agora/bloc/consultation/summary/consultation_summary_view_model.dart';
import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_consultation_result_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConsultationSummaryResultsTabContent extends StatelessWidget {
  final String participantCount;
  final List<ConsultationSummaryResultsViewModel> results;

  const ConsultationSummaryResultsTabContent({super.key, required this.participantCount, required this.results});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: AgoraColors.background,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AgoraSpacings.horizontalPadding,
            vertical: AgoraSpacings.x1_5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                  Row(
                    children: [
                      SvgPicture.asset("assets/ic_person.svg"),
                      SizedBox(width: AgoraSpacings.x0_5),
                      Text(participantCount, style: AgoraTextStyles.light14),
                    ],
                  ),
                  SizedBox(height: AgoraSpacings.base),
                ] +
                results
                    .map(
                      (result) => AgoraConsultationResultView(
                        questionTitle: result.questionTitle,
                        responses: result.responses,
                      ),
                    )
                    .toList(),
          ),
        ),
      ),
    );
  }
}
