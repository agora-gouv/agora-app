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
          return AgoraColors.primaryGreenOpacity50;
        } else {
          return AgoraColors.primaryGreen;
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

  static ButtonStyle greenBorderButtonStyle = ButtonStyle(
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
    textStyle: MaterialStateProperty.all(AgoraTextStyles.greenTextButton),
    elevation: MaterialStateProperty.all(0),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded))),
    side: MaterialStateProperty.all(BorderSide(color: AgoraColors.primaryGreen, width: 1.0, style: BorderStyle.solid)),
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

  static ButtonStyle whiteButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.disabled)) {
          return AgoraColors.stereotypicalDuck;
        } else {
          return AgoraColors.white;
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
}
