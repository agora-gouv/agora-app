import 'package:agora/bloc/consultation/consultation_view_model.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/custom_view/agora_consultation_finished_card.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';

class ConsultationsFinishedSection extends StatelessWidget {
  final List<ConsultationFinishedViewModel> finishedViewModels;

  const ConsultationsFinishedSection({super.key, required this.finishedViewModels});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AgoraSpacings.x1_25),
        Container(
          color: AgoraColors.doctor,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AgoraSpacings.horizontalPadding,
              vertical: AgoraSpacings.x1_25,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    AgoraRichText(
                      items: [
                        AgoraRichTextTextItem(
                          text: "${ConsultationStrings.finishConsultationPart1}\n",
                          style: AgoraRichTextItemStyle.regular,
                        ),
                        AgoraRichTextTextItem(
                          text: ConsultationStrings.finishConsultationPart2,
                          style: AgoraRichTextItemStyle.bold,
                        ),
                      ],
                    ),
                    Spacer(),
                    AgoraRoundedButton(
                      label: GenericStrings.all,
                      style: AgoraRoundedButtonStyle.greyBorderButtonStyle,
                      onPressed: () {
                        // TODO
                      },
                    ),
                  ],
                ),
                SizedBox(height: AgoraSpacings.base),
                finishedViewModels.isEmpty
                    ? Column(
                        children: [
                          SizedBox(height: AgoraSpacings.x0_5),
                          Text(ConsultationStrings.consultationEmpty),
                          SizedBox(height: AgoraSpacings.base),
                        ],
                      )
                    : LayoutBuilder(
                        builder: (context, constraint) {
                          return SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(minWidth: constraint.maxWidth),
                              child: IntrinsicHeight(
                                child: Row(children: _buildFinishedConsultations(context)),
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildFinishedConsultations(BuildContext context) {
    final List<Widget> finishedConsultationsWidget = List.empty(growable: true);
    for (final finishedViewModel in finishedViewModels) {
      finishedConsultationsWidget.add(
        AgoraConsultationFinishedCard(
          id: finishedViewModel.id,
          title: finishedViewModel.title,
          thematique: finishedViewModel.thematique,
          imageUrl: finishedViewModel.coverUrl,
          step: finishedViewModel.step,
        ),
      );
      finishedConsultationsWidget.add(SizedBox(width: AgoraSpacings.x0_5));
    }
    return finishedConsultationsWidget;
  }
}
