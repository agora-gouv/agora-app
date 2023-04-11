import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_corners.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraButtonStyle {
  static ButtonStyle primaryButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.disabled)) {
          return AgoraColors.stereotypicalDuck;
        } else if (states.contains(MaterialState.pressed)) {
          return AgoraColors.stereotypicalDuck;
        } else {
          return AgoraColors.primaryGreen;
        }
      },
    ),
    textStyle: MaterialStateProperty.all(AgoraTextStyles.primaryButton),
    elevation: MaterialStateProperty.all(0),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded))),
    padding: MaterialStateProperty.all(
      EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
    ),
  );

  static ButtonStyle greyButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.disabled)) {
          return AgoraColors.stereotypicalDuck;
        } else if (states.contains(MaterialState.pressed)) {
          return AgoraColors.stereotypicalDuck;
        } else {
          return AgoraColors.steam;
        }
      },
    ),
    textStyle: MaterialStateProperty.all(AgoraTextStyles.lightGreyButton),
    elevation: MaterialStateProperty.all(0),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded))),
    padding: MaterialStateProperty.all(
      EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
    ),
  );

  static ButtonStyle lightGreyButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.disabled)) {
          return AgoraColors.stereotypicalDuck;
        } else if (states.contains(MaterialState.pressed)) {
          return AgoraColors.stereotypicalDuck;
        } else {
          return AgoraColors.cascadingWhite;
        }
      },
    ),
    textStyle: MaterialStateProperty.all(AgoraTextStyles.lightGreyButton),
    elevation: MaterialStateProperty.all(0),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded))),
    padding: MaterialStateProperty.all(
      EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
    ),
  );

  static ButtonStyle lightGreyWithBorderButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.disabled)) {
          return AgoraColors.stereotypicalDuck;
        } else if (states.contains(MaterialState.pressed)) {
          return AgoraColors.stereotypicalDuck;
        } else {
          return AgoraColors.cascadingWhite;
        }
      },
    ),
    textStyle: MaterialStateProperty.all(AgoraTextStyles.lightGreyButton),
    elevation: MaterialStateProperty.all(0),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        side: BorderSide(
          color: AgoraColors.border,
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(AgoraCorners.rounded),
      ),
    ),
    padding: MaterialStateProperty.all(
      EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
    ),
  );
}
