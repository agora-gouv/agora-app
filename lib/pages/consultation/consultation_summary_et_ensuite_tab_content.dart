import 'package:agora/bloc/consultation/summary/consultation_summary_view_model.dart';
import 'package:agora/design/agora_button.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:flutter/material.dart';

class ConsultationSummaryEtEnsuiteTabContent extends StatelessWidget {
  final ConsultationSummaryEtEnsuiteViewModel etEnsuiteViewModel;

  const ConsultationSummaryEtEnsuiteTabContent({super.key, required this.etEnsuiteViewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AgoraColors.background,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AgoraSpacings.horizontalPadding,
          vertical: AgoraSpacings.x1_5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  AgoraButton(
                    label: "Revenir au menu",
                    style: AgoraButtonStyle.primaryButtonStyle,
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        LoadingPage.routeName,
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
