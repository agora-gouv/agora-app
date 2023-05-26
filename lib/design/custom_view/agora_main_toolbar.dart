import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/custom_view/agora_little_separator.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/pages/profile/profile_page.dart';
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
                    icon: "ic_profile.svg",
                    label: GenericStrings.profil,
                    style: AgoraRoundedButtonStyle.greyBorderButtonStyle,
                    padding: AgoraRoundedButtonPadding.short,
                    onPressed: () {
                      Navigator.pushNamed(context, ProfilePage.routeName);
                    },
                  ),
                ],
              ),
              SizedBox(height: AgoraSpacings.x1_25),
              AgoraLittleSeparator(),
            ],
          ),
        ),
      ],
    );
  }
}
