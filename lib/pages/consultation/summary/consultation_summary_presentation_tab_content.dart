import 'package:agora/design/custom_view/agora_html.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/summary/consultation_summary_results_tab_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConsultationSummaryPresentationTabContent extends StatelessWidget {
  final String rangeDate;
  final String description;
  final String tipDescription;
  final ScrollController nestedScrollController;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _sousController = ScrollController();

  ConsultationSummaryPresentationTabContent({
    super.key,
    required this.rangeDate,
    required this.description,
    required this.tipDescription,
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
    return RawKeyboardListener(
      onKey: _sousController.accessibilityListener,
      focusNode: _focusNode,
      child: SingleChildScrollView(
        controller: _sousController,
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
                  _buildInformationItem(image: "ic_calendar.svg", text: rangeDate),
                  SizedBox(height: AgoraSpacings.base),
                  AgoraHtml(data: description),
                  SizedBox(height: AgoraSpacings.base),
                  AgoraRoundedCard(
                    cardColor: AgoraColors.white,
                    padding: const EdgeInsets.all(AgoraSpacings.base),
                    child: AgoraHtml(data: tipDescription),
                  ),
                  SizedBox(height: AgoraSpacings.base),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInformationItem({
    required String image,
    required String text,
    TextStyle textStyle = AgoraTextStyles.medium14,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset("assets/$image", excludeFromSemantics: true),
        SizedBox(width: AgoraSpacings.x0_5),
        Expanded(child: Text(text, style: textStyle)),
      ],
    );
  }
}
