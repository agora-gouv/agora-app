import 'package:agora/design/agora_corners.dart';
import 'package:flutter/material.dart';

Future<T?> showAgoraDialog<T>({
  required BuildContext context,
  required List<Widget> columnChildren,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columnChildren,
        ),
      );
    },
  );
}
