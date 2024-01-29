import 'package:agora/bloc/consultation/summary/consultation_summary_view_model.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_consultation_result_view.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConsultationSummaryResultsTabContent extends StatelessWidget {
  final String participantCount;
  final List<ConsultationSummaryResultsViewModel> results;
  final ScrollController nestedScrollController;

  ConsultationSummaryResultsTabContent({
    super.key,
    required this.participantCount,
    required this.results,
    required this.nestedScrollController,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      nestedScrollController.animateTo(
        nestedScrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn,
      );
    });
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: Container(
          color: AgoraColors.background,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AgoraSpacings.horizontalPadding,
              vertical: AgoraSpacings.x1_5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset("assets/ic_person.svg", excludeFromSemantics: true),
                    SizedBox(width: AgoraSpacings.x0_5),
                    Text(participantCount, style: AgoraTextStyles.light14),
                  ],
                ),
                SizedBox(height: AgoraSpacings.base),
                ...buildResults(),
                Text(ConsultationStrings.summaryInformation, style: AgoraTextStyles.light14),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<AgoraConsultationResultView> buildResults() {
    return results.map(
      (result) {
        if (result is ConsultationSummaryUniqueChoiceResultsViewModel) {
          return AgoraConsultationResultView(
            questionTitle: result.questionTitle,
            responses: result.responses,
            isMultipleChoice: false,
          );
        } else if (result is ConsultationSummaryMultipleChoicesResultsViewModel) {
          return AgoraConsultationResultView(
            questionTitle: result.questionTitle,
            responses: result.responses,
            isMultipleChoice: true,
          );
        } else {
          throw Exception("Results view model doesn't exists $result");
        }
      },
    ).toList();
  }
}
