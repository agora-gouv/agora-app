import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<T?> showAgoraBottomSheet<T>({
  required BuildContext context,
  required List<Widget> columnChildren,
  bool dismissible = false,
}) {
  return showModalBottomSheet<T>(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: AgoraCorners.rounded12)),
    context: context,
    builder: (context) => Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AgoraSpacings.x1_75,
        vertical: AgoraSpacings.x1_25,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: AgoraSpacings.base),
              Center(child: SizedBox(width: 72, height: 3, child: Container(color: AgoraColors.primaryBlue))),
              Semantics(
                button: true,
                label: SemanticsStrings.close,
                child: GestureDetector(
                  child: SvgPicture.asset("assets/ic_close.svg", excludeFromSemantics: true),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          SizedBox(height: AgoraSpacings.x1_5),
          ...columnChildren,
        ],
      ),
    ),
  );
}
