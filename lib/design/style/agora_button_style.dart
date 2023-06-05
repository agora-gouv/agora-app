import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraButtonStyle {
  static ButtonStyle primaryButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.disabled)) {
          return AgoraColors.primaryBlueOpacity50;
        } else {
          return AgoraColors.primaryBlue;
        }
      },
    ),
    overlayColor: MaterialStateProperty.all(AgoraColors.overlay),
    textStyle: MaterialStateProperty.all(AgoraTextStyles.primaryButton),
    elevation: MaterialStateProperty.all(0),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded))),
    padding: MaterialStateProperty.all(
      EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
    ),
  );

  static ButtonStyle onboardingButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.disabled)) {
          return AgoraColors.primaryBlueOpacity50;
        } else {
          return AgoraColors.primaryBlue;
        }
      },
    ),
    overlayColor: MaterialStateProperty.all(AgoraColors.overlay),
    textStyle: MaterialStateProperty.all(AgoraTextStyles.primaryButton.copyWith(fontSize: 18.0)),
    elevation: MaterialStateProperty.all(0),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded))),
    padding: MaterialStateProperty.all(
      EdgeInsets.symmetric(vertical: AgoraSpacings.x0_75, horizontal: AgoraSpacings.x0_75),
    ),
  );

  static ButtonStyle blueBorderButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.disabled)) {
          return AgoraColors.stereotypicalDuck;
        } else {
          return AgoraColors.transparent;
        }
      },
    ),
    overlayColor: MaterialStateProperty.all(AgoraColors.overlay),
    textStyle: MaterialStateProperty.all(AgoraTextStyles.primaryBlueTextButton),
    elevation: MaterialStateProperty.all(0),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded))),
    side: MaterialStateProperty.all(BorderSide(color: AgoraColors.primaryBlue, width: 1.0, style: BorderStyle.solid)),
    padding: MaterialStateProperty.all(
      EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
    ),
  );

  static ButtonStyle redBorderButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.disabled)) {
          return AgoraColors.stereotypicalDuck;
        } else {
          return AgoraColors.transparent;
        }
      },
    ),
    overlayColor: MaterialStateProperty.all(AgoraColors.overlay),
    textStyle: MaterialStateProperty.all(AgoraTextStyles.redTextButton),
    elevation: MaterialStateProperty.all(0),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded))),
    side: MaterialStateProperty.all(BorderSide(color: AgoraColors.red, width: 1.0, style: BorderStyle.solid)),
    padding: MaterialStateProperty.all(
      EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
    ),
  );

  static ButtonStyle greyButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.disabled)) {
          return AgoraColors.stereotypicalDuck;
        } else {
          return AgoraColors.steam;
        }
      },
    ),
    overlayColor: MaterialStateProperty.all(AgoraColors.overlay),
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
        } else {
          return AgoraColors.cascadingWhite;
        }
      },
    ),
    overlayColor: MaterialStateProperty.all(AgoraColors.overlay),
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
        } else {
          return AgoraColors.cascadingWhite;
        }
      },
    ),
    overlayColor: MaterialStateProperty.all(AgoraColors.overlay),
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
