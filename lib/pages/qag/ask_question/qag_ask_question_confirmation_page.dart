import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:agora/pages/qag/qags_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QagAskQuestionConfirmationPage extends StatelessWidget {
  static const routeName = "/qagAskQuestionConfirmationPage";

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      shouldPop: false,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            AgoraTopDiagonal(),
            SizedBox(height: AgoraSpacings.base),
            SvgPicture.asset(
              "assets/ic_question_confirmation.svg",
              width: MediaQuery.of(context).size.width - AgoraSpacings.base,
            ),
            Padding(
              padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Votre question est prise en compte.",
                    style: AgoraTextStyles.medium19,
                  ),
                  SizedBox(height: AgoraSpacings.base),
                  AgoraButton(
                    label: GenericStrings.close,
                    style: AgoraButtonStyle.primaryButtonStyle,
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        QagsPage.routeName,
                        ModalRoute.withName(LoadingPage.routeName),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
