import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/parser/simple_html_parser.dart';
import 'package:agora/design/custom_view/bottom_sheet/agora_bottom_sheet.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/error/agora_error_view.dart';
import 'package:agora/design/custom_view/skeletons.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/qag/info/bloc/qags_info_bloc.dart';
import 'package:agora/qag/info/bloc/qags_info_event.dart';
import 'package:agora/qag/info/bloc/qags_info_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagsInformationBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => QagsInfoBloc(
        qagRepository: RepositoryManager.getQagRepository(),
      )..add(FetchQagsInfoEvent()),
      child: BlocBuilder<QagsInfoBloc, QagsInfoState>(
        builder: (context, state) => AgoraBottomSheet(
          content: switch (state.status) {
            AllPurposeStatus.notLoaded || AllPurposeStatus.loading => [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: AgoraSpacings.x2),
                    SkeletonBox(height: 15, width: 200, radius: 15),
                    SizedBox(height: AgoraSpacings.base),
                    SkeletonBox(height: 15, width: 200, radius: 15),
                    SizedBox(height: AgoraSpacings.base),
                    SkeletonBox(height: 15, width: 200, radius: 15),
                    SizedBox(height: AgoraSpacings.x2),
                  ],
                ),
              ],
            AllPurposeStatus.error => [
                AgoraErrorView(
                  onReload: () {
                    context.read<QagsInfoBloc>().add(FetchQagsInfoEvent());
                  },
                ),
              ],
            AllPurposeStatus.success => [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Le mois sur Agora",
                      style: AgoraTextStyles.bold34,
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      "Découvrez le programme et le fonctionnement",
                      style: AgoraTextStyles.light16,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AgoraSpacings.x1_25),
                    Text("PROGRAMME DU MOIS", style: AgoraTextStyles.bold18PrimaryBlue),
                    const SizedBox(height: AgoraSpacings.x0_5),
                    AgoraRichText(
                      policeStyle: AgoraRichTextPoliceStyle.sectionInterligne150,
                      semantic: AgoraRichTextSemantic(label: state.programmeDuMois),
                      items: [
                        ...parseSimpleHtml(state.programmeDuMois)
                            .map((data) => AgoraRichTextItem(text: data.text, style: data.style)),
                      ],
                    ),
                    const SizedBox(height: AgoraSpacings.x2),
                    Text("COMMENT ÇA MARCHE", style: AgoraTextStyles.bold18PrimaryBlue),
                    const SizedBox(height: AgoraSpacings.x0_5),
                    Text(state.commentCaMarche, style: AgoraTextStyles.light18),
                    const SizedBox(height: AgoraSpacings.x2),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: AgoraButton.withLabel(
                        label: "J’ai compris",
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ],
          },
        ),
      ),
    );
  }
}
