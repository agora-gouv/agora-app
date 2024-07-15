import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';

Future<T?> showAgoraDialog<T>({
  required BuildContext context,
  required List<Widget> columnChildren,
  bool dismissible = false,
}) {
  return showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (context) {
      return Dialog(
        backgroundColor: AgoraColors.background,
        surfaceTintColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AgoraSpacings.x1_75,
            vertical: AgoraSpacings.x1_25,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: columnChildren,
            ),
          ),
        ),
      );
    },
  );
}
