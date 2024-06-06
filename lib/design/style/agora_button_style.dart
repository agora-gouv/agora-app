import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AgoraButtonStyle {
  static ButtonStyle primaryButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.disabled)) {
          return AgoraColors.gravelFint;
        } else {
          return AgoraColors.primaryBlue;
        }
      },
    ),
    overlayColor: WidgetStateProperty.all(AgoraColors.overlay),
    textStyle: WidgetStateProperty.all(AgoraTextStyles.primaryButton),
    elevation: WidgetStateProperty.all(0),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded))),
    padding: WidgetStateProperty.all(
      EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
    ),
    minimumSize: kIsWeb ? WidgetStateProperty.all(Size(0, 48)) : WidgetStateProperty.all(Size(0, 0)),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  static ButtonStyle blueBorderButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.disabled)) {
          return AgoraColors.stereotypicalDuck;
        } else {
          return AgoraColors.transparent;
        }
      },
    ),
    overlayColor: WidgetStateProperty.all(AgoraColors.overlay),
    textStyle: WidgetStateProperty.all(AgoraTextStyles.primaryBlueTextButton),
    elevation: WidgetStateProperty.all(0),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded))),
    side: WidgetStateProperty.all(BorderSide(color: AgoraColors.primaryBlue, width: 1.0, style: BorderStyle.solid)),
    padding: WidgetStateProperty.all(
      EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
    ),
    minimumSize: kIsWeb ? WidgetStateProperty.all(Size(0, 48)) : WidgetStateProperty.all(Size(0, 0)),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  static ButtonStyle redBorderButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.disabled)) {
          return AgoraColors.stereotypicalDuck;
        } else {
          return AgoraColors.transparent;
        }
      },
    ),
    overlayColor: WidgetStateProperty.all(AgoraColors.overlay),
    textStyle: WidgetStateProperty.all(AgoraTextStyles.redTextButton),
    elevation: WidgetStateProperty.all(0),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded))),
    side: WidgetStateProperty.all(BorderSide(color: AgoraColors.red, width: 1.0, style: BorderStyle.solid)),
    padding: WidgetStateProperty.all(
      EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
    ),
    minimumSize: kIsWeb ? WidgetStateProperty.all(Size(0, 48)) : WidgetStateProperty.all(Size(0, 0)),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  static ButtonStyle greyButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.disabled)) {
          return AgoraColors.stereotypicalDuck;
        } else {
          return AgoraColors.steam;
        }
      },
    ),
    overlayColor: WidgetStateProperty.all(AgoraColors.overlay),
    textStyle: WidgetStateProperty.all(AgoraTextStyles.lightGreyButton),
    elevation: WidgetStateProperty.all(0),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded))),
    padding: WidgetStateProperty.all(
      EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
    ),
    minimumSize: kIsWeb ? WidgetStateProperty.all(Size(0, 48)) : WidgetStateProperty.all(Size(0, 0)),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  static ButtonStyle lightGreyButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.disabled)) {
          return AgoraColors.stereotypicalDuck;
        } else {
          return AgoraColors.cascadingWhite;
        }
      },
    ),
    overlayColor: WidgetStateProperty.all(AgoraColors.overlay),
    textStyle: WidgetStateProperty.all(AgoraTextStyles.lightGreyButton),
    elevation: WidgetStateProperty.all(0),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded))),
    padding: WidgetStateProperty.all(
      EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
    ),
    minimumSize: kIsWeb ? WidgetStateProperty.all(Size(0, 48)) : WidgetStateProperty.all(Size(0, 0)),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  static ButtonStyle lightGreyWithBorderButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.disabled)) {
          return AgoraColors.stereotypicalDuck;
        } else {
          return AgoraColors.cascadingWhite;
        }
      },
    ),
    overlayColor: WidgetStateProperty.all(AgoraColors.overlay),
    textStyle: WidgetStateProperty.all(AgoraTextStyles.lightGreyButton),
    elevation: WidgetStateProperty.all(0),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        side: BorderSide(
          color: AgoraColors.border,
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(AgoraCorners.rounded),
      ),
    ),
    padding: WidgetStateProperty.all(
      EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
    ),
    minimumSize: kIsWeb ? WidgetStateProperty.all(Size(0, 48)) : WidgetStateProperty.all(Size(0, 0)),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}
