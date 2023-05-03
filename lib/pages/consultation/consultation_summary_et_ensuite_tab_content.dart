import 'package:agora/bloc/consultation/summary/consultation_summary_view_model.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_html.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

class ConsultationSummaryEtEnsuiteTabContent extends StatelessWidget {
  final String title;
  final String consultationId;
  final ConsultationSummaryEtEnsuiteViewModel etEnsuiteViewModel;

  const ConsultationSummaryEtEnsuiteTabContent({
    super.key,
    required this.title,
    required this.consultationId,
    required this.etEnsuiteViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: Container(
          color: AgoraColors.background,
          child: Column(
            children: [
              Container(
                color: AgoraColors.stoicWhite,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AgoraSpacings.horizontalPadding,
                    vertical: AgoraSpacings.base,
                  ),
                  child: Row(
                    children: [
                      Image.asset(etEnsuiteViewModel.image, width: 115),
                      SizedBox(width: AgoraSpacings.base),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              etEnsuiteViewModel.step,
                              style: AgoraTextStyles.medium15.copyWith(color: AgoraColors.blueFrance),
                            ),
                            Text(etEnsuiteViewModel.title, style: AgoraTextStyles.medium18),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AgoraSpacings.horizontalPadding,
                  vertical: AgoraSpacings.x1_5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AgoraHtml(data: etEnsuiteViewModel.description),
                    SizedBox(height: AgoraSpacings.x2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: AgoraButton(
                            label: ConsultationStrings.returnToHome,
                            style: AgoraButtonStyle.lightGreyWithBorderButtonStyle,
                            onPressed: () {
                              Navigator.popUntil(context, ModalRoute.withName(LoadingPage.routeName));
                            },
                          ),
                        ),
                        SizedBox(width: AgoraSpacings.base),
                        AgoraButton(
                          label: ConsultationStrings.share,
                          icon: "ic_share_white.svg",
                          style: AgoraButtonStyle.primaryButtonStyle,
                          onPressed: () async {
                            Share.share('Consultation : $title\nagora://consultation.gouv.fr/$consultationId');
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: AgoraSpacings.x3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset("assets/ic_bell.svg"),
                        SizedBox(width: AgoraSpacings.x0_75),
                        Expanded(
                          child: Text(
                            ConsultationStrings.notificationInformation,
                            style: AgoraTextStyles.light14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AgoraSpacings.base),
                    AgoraButton(
                      label: ConsultationStrings.refuseNotification,
                      style: AgoraButtonStyle.greyButtonStyle,
                      onPressed: () {
                        // TODO activate notification
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
