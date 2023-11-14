import 'package:agora/bloc/qag/details/qag_details_view_model.dart';
import 'package:agora/design/custom_view/agora_html.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class QagDetailsTextResponseView extends StatelessWidget {
  final String qagId;
  final QagDetailsViewModel detailsViewModel;

  const QagDetailsTextResponseView({super.key, required this.qagId, required this.detailsViewModel});

  @override
  Widget build(BuildContext context) {
    final textResponse = detailsViewModel.textResponse!;
    return Container(
      width: double.infinity,
      color: AgoraColors.background,
      child: Padding(
        padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(header: true, child: Text(textResponse.responseLabel, style: AgoraTextStyles.medium17)),
            SizedBox(height: AgoraSpacings.base),
            AgoraHtml(data: textResponse.responseText),
            SizedBox(height: AgoraSpacings.x2),
          ],
        ),
      ),
    );
  }
}
