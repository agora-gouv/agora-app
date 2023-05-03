import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';

class AgoraMainToolbar extends StatelessWidget {
  final Widget title;

  const AgoraMainToolbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AgoraTopDiagonal(),
        Padding(
          padding: EdgeInsets.only(
            left: AgoraSpacings.horizontalPadding,
            top: AgoraSpacings.base,
            right: AgoraSpacings.horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: title),
                  AgoraRoundedButton(
                    icon: "ic_profil.svg",
                    label: GenericStrings.profil,
                    style: AgoraRoundedButtonStyle.lightGreyButton,
                    padding: AgoraRoundedButtonPadding.short,
                    onPressed: () {
                      // TODO
                    },
                  ),
                ],
              ),
              SizedBox(height: AgoraSpacings.x1_25),
              Container(
                color: AgoraColors.primaryGreen,
                height: 3,
                width: MediaQuery.of(context).size.width * 0.15,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
